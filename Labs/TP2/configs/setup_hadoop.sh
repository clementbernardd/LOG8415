#!/bin/bash
export HADOOP_PREFIX=/usr/local/hadoop-2.10.1

$HADOOP_PREFIX/bin/hdfs namenode -format

$HADOOP_PREFIX/sbin/start-dfs.sh

