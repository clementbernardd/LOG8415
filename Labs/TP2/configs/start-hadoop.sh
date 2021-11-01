#!/bin/bash

#/etc/init.d/ssh start

$HADOOP_PREFIX/bin/hdfs namenode -format 

$HADOOP_PREFIX/sbin/start-dfs.sh

hdfs dfs -mkdir -p input

hdfs dfs -copyFromLocal ../files/* input
