#!/bin/bash

function get_linux_times(){
  files=$(ls ../files/);
  mkdir -p "../results/linux";
  for file in $files  ;
  do
    for i in $(seq 1 3);
    do
         name_result="../results/linux/$file";
         given_time=$(/usr/bin/time -f "%E"  bash count_words.sh "../files/$file" 2>> $name_result );
    done;
  done;
}

function get_hadoop_times(){
  files=$(ls ../files/);
  mkdir -p "../results/hadoop";
  for file in $files  ;
  do
    for i in $(seq 1 3);
    do
         name_result="../results/hadoop/$file";
         given_time=$(/usr/bin/time -f "%E"  bash count_words_hadoop.sh $file $i  2>> $name_result );
    done;
  done;
}

get_linux_times
get_hadoop_times