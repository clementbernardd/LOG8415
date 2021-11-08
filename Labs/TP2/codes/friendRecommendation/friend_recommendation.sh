#!/bin/bash
${HADOOP_PREFIX}/bin/hdfs namenode -format
${HADOOP_PREFIX}/sbin/start-dfs.sh
${JAVA_HOME}/bin/javac -classpath `${HADOOP_PREFIX}/bin/hadoop classpath`  FriendDegreeWritable.java FriendRecommendation*.java
${JAVA_HOME}/bin/jar cf FriendRecommendation.jar FriendRecommendation*.class FriendDegreeWritable.class
hdfs dfs -rm /input
hdfs dfs -rm -r /output
hdfs dfs -mkdir /input
hdfs dfs -copyFromLocal ../../files/soc-LiveJournal1Adj.txt /input
hadoop jar FriendRecommendation.jar FriendRecommendation /input /output
hdfs dfs -cat /output/part-00000 > ../../results/result_friend_recommendation.txt

echo "" > ../../results/resultats_specifiques.txt

usersToDisplay=(924 8941 8942 9019 9020 9021 9022 9990 9992 9993)
for i in "${usersToDisplay[@]}"
do
        grep -P "^${i}\t" ../../results/result_friend_recommendation.txt >> ../../results/resultats_specifiques.txt
done
cat ../../results/resultats_specifiques.txt