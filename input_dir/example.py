import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)


AmazonS3_node1716182122982 = glueContext.create_dynamic_frame.from_options(format_options={"multiline": False}, connection_type="s3", format="json", connection_options={"paths": ["s3://tokyo-rawdata-bucket"], "recurse": True}, transformation_ctx="AmazonS3_node1716182122982")


AmazonS3_node1716182147104 = glueContext.write_dynamic_frame.from_options(frame=AmazonS3_node1716182122982, connection_type="s3", format="csv", connection_options={"path": "s3://tokyo-extension-bucket", "partitionKeys": []}, transformation_ctx="AmazonS3_node1716182147104")

job.commit()