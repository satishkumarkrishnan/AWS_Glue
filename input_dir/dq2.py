import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job


sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)                   
                
from awsgluedq.transforms import EvaluateDataQuality
accountdata = spark.read.format("csv") \
    .option("header", "false") \
    .option("inferSchema", "true") \
    .option("delimiter", "|") \
    .load('s3://ddsl-dq1/good/9000_segregated.txt')

accountdata.printSchema()
accountdata.show()
from awsglue.dynamicframe import DynamicFrame
accountdata_dyf = DynamicFrame.fromDF(accountdata,glueContext,"accountdata_dyf") 
EvaluateDataQuality_ruleset = """
    Rules = [
      
        RowCount =95,
        IsComplete "_c0",
        ColumnCount = 10
]
    ]
"""               
                
EvaluateDataQualityMultiframe = EvaluateDataQuality().process_rows(
    frame=accountdata_dyf,
    ruleset=EvaluateDataQuality_ruleset,
    publishing_options={
        "dataQualityEvaluationContext": "EvaluateDataQualityMultiframe",
        "enableDataQualityCloudWatchMetrics": False,
        "enableDataQualityResultsPublishing": False,
    },
    additional_options={"performanceTuning.caching": "CACHE_NOTHING"},
)      
                
ruleOutcomes = SelectFromCollection.apply(
    dfc=EvaluateDataQualityMultiframe,
    key="ruleOutcomes",
    transformation_ctx="ruleOutcomes",
)

ruleOutcomes.toDF().show(truncate=False)                                             
                
rowLevelOutcomes = SelectFromCollection.apply(
dfc=EvaluateDataQualityMultiframe,
key="rowLevelOutcomes",
transformation_ctx="rowLevelOutcomes",
)

rowLevelOutcomes_df = rowLevelOutcomes.toDF() # Convert Glue DynamicFrame to SparkSQL DataFrame
rowLevelOutcomes_df_passed = rowLevelOutcomes_df.filter(rowLevelOutcomes_df.DataQualityEvaluationResult == "Passed") # Filter only the Passed records.
rowLevelOutcomes_df_failed = rowLevelOutcomes_df.filter(rowLevelOutcomes_df.DataQualityEvaluationResult == "Failed") # Review the Failed records                    
                
dynamic_frame_passed = DynamicFrame.fromDF(rowLevelOutcomes_df_passed, glueContext, "dynamic_frame_passed")
glueContext.write_dynamic_frame.from_options(
    frame=dynamic_frame_passed,
    connection_type="s3",
    connection_options={"path": "s3://ddsl-dq2/pass/"},
    format="parquet"
)
dynamic_frame_failed = DynamicFrame.fromDF(rowLevelOutcomes_df_failed, glueContext, "dynamic_frame_failed")
# Check if there are any records in the failed DynamicFrame
if dynamic_frame_failed.count() > 0:
    # Write failed records to S3
    glueContext.write_dynamic_frame.from_options(
        frame=dynamic_frame_failed,
        connection_type="s3",
        connection_options={"path": "s3://ddsl-dq2/failed/"},
        format="parquet"
    )
else:
    print("No failed records to write.")

job.commit()
