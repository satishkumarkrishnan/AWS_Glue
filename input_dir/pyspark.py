from pyspark.sql import SparkSession

# Path to the OpenLineage Spark agent JAR file
jar_path = "s3://ddsl-rawdata-bucket/openlineage-spark_2.13-1.13.1.jar"

# Initialize the Spark session
spark = SparkSession.builder \
    .appName("OpenLineageExample") \
    .config("spark.jars", jar_path) \
    .config("spark.openlineage.transport.type", "http") \
    .getOrCreate() \
    .config("spark.extraListeners", "io.openlineage.spark.agent.OpenLineageSparkListener") \
    .config("spark.openlineage.transport.type", "http") \
    .config("spark.openlineage.transport.url", "http://localhost:5000") \
    .config("spark.openlineage.namespace", "spark_namespace") \
    .config("spark.openlineage.parentJobNamespace", "airflow_namespace") \
    .config("spark.openlineage.parentJobName", "airflow_dag.airflow_task") \
    .config("spark.openlineage.parentRunId", "xxxx-xxxx-xxxx-xxxx") \


# Your Spark job code
# ...

spark.stop()