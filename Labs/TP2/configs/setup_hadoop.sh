#!/bin/bash
export HADOOP_PREFIX=/usr/local/hadoop-2.10.1
RED='\033[0;31m'
NC='\033[0m'

function show(){
  echo -e "${RED} $1 ${NC}" ;
}

function start_namenode(){
  show "START FORMAT HDFS" ;
  echo 'Y' | $HADOOP_PREFIX/bin/hdfs namenode -format  &>/dev/null ;
  show "HDFS FORMAT WITH SUCCESS";
  show "START HADOOP SINGLE NODE CLUSTER"
  $HADOOP_PREFIX/sbin/start-dfs.sh &>/dev/null ;
  show "START HADOOP WITH SUCCESS";
}

function stop_namenode(){
  show "STOP HADOOP NODE";
  $HADOOP_PREFIX/sbin/stop-dfs.sh &>/dev/null ;
  show "STOP HADOOP NODE WITH SUCCESS";
}

function add_directory(){
  show "CREATE DIRECTORY IN HADOOP";
  hdfs dfs -mkdir -p input &>/dev/null ;
  show "COPY LOCAL FILE TO HADOOP DIRECTORY";
  hdfs dfs -copyFromLocal files/* input &>/dev/null ;
  show "COPY OF THE FILES WITH SUCCESS";
}

function set_standalone(){
  show "SETUP STANDALONE MODE";
  cp ./configs/core-site-standalone.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
  cp ./configs/hdfs-site-standalone.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
  show "END SETUP STANDALONE MODE";
}

function set_distributed(){
  show "SETUP PSEUDO-DISTRIBUTED MODE";
  cp ./configs/core-site.xml ./configs/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/
  start_namenode;
  add_directory;
  show "HADOOP IN PSEUDO-DISTRIBUTED MODE";
}

function example(){
  show "COUNT WORDS IN PSEUDO-DISTRIBUTED MODE" ;
  hadoop jar $HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.10.1.jar wordcount input/dataset0.txt output/dataset0  ;
  show "SHOW 10 outputs" ;
  hdfs dfs -cat output/dataset0/part-r-00000 | tail -n 10 ;
  show "END COUNT WORDS IN PSEUDO-DISTRIBUTED MODE";
}