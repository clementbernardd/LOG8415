#!/bin/bash

HOME_PATH=.
FILE_PATH=$HOME_PATH/files
RESULT_PATH=$HOME_PATH/results


RED='\033[0;31m'
NC='\033[0m'

function show(){
  echo -e "${RED} $1 ${NC}" ;
}

function get_linux_times(){
  files=$(ls $FILE_PATH | grep dataset );
  dir=$RESULT_PATH/local/linux/time;
  dir_out=$RESULT_PATH/local/linux/counts;
  mkdir -p $dir $dir_out && rm -rf $dir/* $dir_out/* || true ;
  show "GET LINUX TIMES";
  for file in $files  ;
  do
     name_result=$dir/$file;
     show "FILE : $file"
    for i in $(seq 1 3);
    do
         given_time=$(/usr/bin/time -f "%U"  bash $HOME_PATH/codes/bash/count_words.sh $FILE_PATH/$file $dir_out/$file 2>> $name_result );
    done;
  done;
  show "END GET LINUX TIMES";
}

function get_hadoop_times(){
  files=$(ls $FILE_PATH | grep dataset );
  dir=$RESULT_PATH/local/hadoop/time;
  dir_out=$RESULT_PATH/local/hadoop/counts;
  mkdir -p $dir $dir_out && rm -rf $dir/* $dir_out/* || true ;
  show "GET HADOOP TIMES";
  for file in $files  ;
  do
   name_result=$dir/$file;
   show "FILE : $file";
    for i in $(seq 1 3);
    do
         given_time=$(/usr/bin/time -f "%U"  bash $HOME_PATH/codes/bash/count_words_hadoop.sh $file $i 2>> $name_result );
         hdfs dfs -cat "output/${file}_${i}/part-r-00000" | tail -n 10 &>> $dir_out/$file ;
    done;
  done;
  show "END GET HADOOP TIMES";
}

get_linux_times
get_hadoop_times
