from pyspark.sql import SparkSession
spark = SparkSession.builder.appName('abc').getOrCreate()
df=spark.read.csv('filename.csv',header=True)