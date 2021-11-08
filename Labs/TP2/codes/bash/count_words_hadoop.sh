#!/bin/bash 

hadoop jar $HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.10.1.jar wordcount files/$1 output/"${1}_${2}" &> /tmp/null.txt ;
