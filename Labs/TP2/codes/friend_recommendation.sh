#!/bin/bash

javac -classpath `${HADOOP_PREFIX}/bin/hadoop classpath` FriendRecommendation.java

${JAVA_HOME}/bin/jar cf FriendRecommendation.jar FriendRecommendation*.class

hdfs dfs -rm input/*

hdfs dfs -copyFromLocal ../files/soc-LiveJournal1Adj.txt input

hadoop jar FriendRecommendation.jar FriendRecommendation input output3

hdfs dfs -ls output/part-r-00000 > ../files/results.txt