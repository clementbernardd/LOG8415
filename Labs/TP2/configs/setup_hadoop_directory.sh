#!/bin/bash 

hdfs dfs -mkdir -p input

hdfs dfs -copyFromLocal ../files/* input

