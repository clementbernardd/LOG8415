#!/bin/bash 

hadoop jar $HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.10.1.jar wordcount input/$1 output/"${1}_${2}" &> /tmp/null.txt ;