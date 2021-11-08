from pyspark.sql.functions import *
from pyspark.sql import SparkSession
import argparse
from pyspark import SparkContext
import json

parser = argparse.ArgumentParser()

parser.add_argument("--file")
parser.add_argument("--output")
args = parser.parse_args()

if args.file:
    fileName = args.file
    output = args.output


sc = SparkContext("local", "PySpark Word Count TP2 LOG8415")
textFile = sc.textFile(fileName).flatMap(lambda line: line.split(" "))
wordCounts = textFile.map(lambda word: (word, 1)).reduceByKey(lambda a,b:a +b)
wordCounts=wordCounts.collect()[-10:]

with open(output, 'w') as f:
    json.dump(wordCounts, f)