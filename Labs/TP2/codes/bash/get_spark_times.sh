#!/bin/bash

function get_spark_times(){
  files=$(ls ./files/);
  mkdir -p "./results/spark";
  for file in $files  ;
  do
    for i in $(seq 1 3);
    do
         name_result="./results/spark/$file";
         given_time=$(/usr/bin/time -f "%U"  bash count_words_spark.sh "./files/$file" 2>> $name_result );
    done;
  done;
}

get_spark_times;

