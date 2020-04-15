#!/bin/bash

docker build --build-arg HADOOP_VERSION=3.1.1 --build-arg HIVE_VERSION=3.1.0 -t hadoop-hive-agens:0.2 ./
docker run -it --rm hadoop-hive-agens:0.2 
if [[ $? -eq 0 ]]; then
	echo "HADOOP_VERSION=3.1.1 test succeeded"
else
	echo "HADOOP_VERSION=3.1.1 test failed"
fi

docker build --build-arg HADOOP_VERSION=3.0.3 --build-arg HIVE_VERSION=3.1.0 -t hadoop-hive-agens:0.3 ./
docker run -it --rm hadoop-hive-agens:0.3 
if [[ $? -eq 0 ]]; then
	echo "HADOOP_VERSION=3.0.3 test succeeded"
else
	echo "HADOOP_VERSION=3.0.3 test failed"
fi

docker build --build-arg HADOOP_VERSION=3.0.2 --build-arg HIVE_VERSION=3.1.0 -t hadoop-hive-agens:0.4 ./
docker run -it --rm hadoop-hive-agens:0.4 
if [[ $? -eq 0 ]]; then
	echo "HADOOP_VERSION=3.0.2 test succeeded"
else
	echo "HADOOP_VERSION=3.0.2 test failed"
fi


