#!/bin/bash

HOME_PATH=.
FILE_PATH=$HOME_PATH/files
RESULT_PATH=$HOME_PATH/results

RED='\033[0;31m'
NC='\033[0m'

function show(){
  echo -e "${RED} $1 ${NC}" ;
}

function get_hadoop_times(){
  files=$(ls $FILE_PATH);
  dir=$RESULT_PATH/azure/hadoop;
  mkdir -p $dir;
  show "GET HADOOP TIMES";
  for file in $files  ;
  do
   name_result=$dir/$file;
   show "FILE : $file";
    for i in $(seq 1 3);
    do
         given_time=$(/usr/bin/time -f "%U"  bash $HOME_PATH/codes/bash/count_words_hadoop.sh $file $i  2>> $name_result );
    done;
  done;
  show "END GET LINUX TIMES";
}


function get_spark_times(){
  files=$(ls $FILE_PATH);
  dir=$RESULT_PATH/azure/spark;
  mkdir -p $dir;
  show "GET SPARK TIMES";
  for file in $files  ;
  do
   name_result=$dir/$file;
   show "FILE : $file";
    for i in $(seq 1 3);
    do
         given_time=$(/usr/bin/time -f "%U"  bash $HOME_PATH/codes/bash/count_words_spark.sh $FILE_PATH/$file 2>> $name_result );
    done;
  done;
  show "END GET SPARK TIMES";
}

get_hadoop_times;
get_spark_times;