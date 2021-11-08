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
  hdfs dfs -rm -r .;
  show "CREATE DIRECTORY IN HADOOP";
  hdfs dfs -mkdir -p input &>/dev/null ;
  show "COPY LOCAL FILE TO HADOOP DIRECTORY";
  hdfs dfs -copyFromLocal files/* input &>/dev/null ;
  show "COPY OF THE FILES WITH SUCCESS";

}
