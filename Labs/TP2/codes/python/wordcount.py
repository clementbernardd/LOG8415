from pyspark.sql.functions import *
from pyspark.sql import SparkSession
import argparse
from pyspark import SparkContext

parser = argparse.ArgumentParser()

parser.add_argument("--file")

args = parser.parse_args()

if args.file:
    fileName = args.file


sc = SparkContext("local", "PySpark Word Count TP2 LOG8415")
textFile = sc.textFile(fileName).flatMap(lambda line: line.split(" "))
wordCounts = textFile.map(lambda word: (word, 1)).reduceByKey(lambda a,b:a +b)

