from pyspark.sql.functions import *
from pyspark.sql import SparkSession
import argparse

parser = argparse.ArgumentParser()

parser.add_argument("--file")

args = parser.parse_args()

if args.file:
    fileName = args.file

spark = SparkSession.builder.appName("WordCount").getOrCreate()

textFile = spark.read.text(fileName)

wordCounts = textFile.select(explode(split(textFile.value, "\s+")).alias("word")).groupBy("word").count()
