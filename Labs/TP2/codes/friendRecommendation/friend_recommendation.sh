#!/bin/bash

#export HADOOP_PREFIX=/usr/local/hadoop-2.10.1
RED='\033[0;31m'
NC='\033[0m'
PATH_TO_RECOMMENDATION=./codes/friendRecommendation
PARENT_PATH=../..

function show(){
  echo -e "${RED} $1 ${NC}" ;
}

function setup_hadoop_recommendation(){
  cd $PATH_TO_RECOMMENDATION;
  ${JAVA_HOME}/bin/javac -classpath `${HADOOP_PREFIX}/bin/hadoop classpath`  ./FriendDegreeWritable.java ./FriendRecommendation*.java
  ${JAVA_HOME}/bin/jar cf ./FriendRecommendation.jar ./FriendRecommendation*.class ./FriendDegreeWritable.class
}

function do_recommendation(){
#  ls ;
  hadoop jar ./FriendRecommendation.jar FriendRecommendation input/soc-LiveJournal1Adj.txt output
  cd $PARENT_PATH;
  mkdir -p results/recommendation
  hdfs dfs -cat output/part-00000 > ./results/recommendation/result_friend_recommendation.txt
  echo "" > ./results/recommendation/resultats_specifiques.txt
  usersToDisplay=(924 8941 8942 9019 9020 9021 9022 9990 9992 9993)
  for i in "${usersToDisplay[@]}"
  do
          grep -P "^${i}\t" ./results/recommendation/result_friend_recommendation.txt >> ./results/resultats_specifiques.txt
  done
  show ./results/resultats_specifiques.txt
}


