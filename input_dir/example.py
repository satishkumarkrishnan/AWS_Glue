import json
import csv
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

glueContext = GlueContext(SparkContext.getOrCreate())

# Script generated for node Amazon S3
AmazonS3_node1698837830668 = glueContext.create_dynamic_frame.from_options(
    format_options={"multiline": False},
    connection_type="s3",
    format="json",
    connection_options={"paths": ["s3://tokyo-rawdata-bucket"]},
    transformation_ctx="AmazonS3_node1698837830668",
)

# Script generated for node Explode Array Or Map Into Rows
ExplodeArrayOrMapIntoRows_node1698843098805 = AmazonS3_node1698837830668.gs_explode(
    colName="data", newCol="data"
)

# Script generated for node Flatten
Flatten_node1698843497504 = ExplodeArrayOrMapIntoRows_node1698843098805.gs_flatten()

# Script generated for node Amazon S3
AmazonS3_node1698837833637 = glueContext.write_dynamic_frame.from_options(
    frame=Flatten_node1698843497504,
    connection_type="s3",
    format="csv",
    connection_options={"path": "s3://tokyo-extension-bucket ", "partitionKeys": []},
    transformation_ctx="AmazonS3_node1698837833637",
)

job.commit()