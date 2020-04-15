#!/bin/bash

#if [ ! -d log ]; then
#	mkdir log
#fi

#docker rmi -f $(docker images -q pgbouncer)
docker build -t pgbouncer:latest ./
docker run --rm pgbouncer:latest
if [ $? -eq 0 ]; then
	#echo "$(date): succeeded!" >> log/$(date "+%Y-%m").log
	exit 0 	
else
	#echo "$(date): failed!" >> log/$(date "+%Y-%m").log
	exit 1	
fi

echo "test end."
