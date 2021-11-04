#!/bin/bash

HOME_PATH=../..
FILE_PATH=$HOME_PATH/files
RESULT_PATH=$HOME_PATH/results

function get_linux_times(){
  files=$(ls $FILE_PATH);
  dir=$RESULT_PATH/linux;
  mkdir -p $dir;
  for file in $files  ;
  do
     name_result=$dir/$file;
    for i in $(seq 1 3);
    do
         given_time=$(/usr/bin/time -f "%U"  bash count_words.sh $FILE_PATH/$file 2>> $name_result );
    done;
  done;
}

function get_hadoop_times(){
  files=$(ls $FILE_PATH);
  dir=$RESULT_PATH/hadoop;
  mkdir -p $dir;
  for file in $files  ;
  do
   name_result=$dir/$file;
    for i in $(seq 1 3);
    do
         given_time=$(/usr/bin/time -f "%U"  bash count_words_hadoop.sh $file $i  2>> $name_result );
    done;
  done;
}

get_linux_times
get_hadoop_times
