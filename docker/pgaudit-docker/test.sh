#!/bin/bash

#if [ ! -d log ]; then
#	mkdir log
#fi

#docker rmi -f $(docker images -q pgaudit-docker-test)
docker build -t pgaudit-docker-test:latest ./
docker run --rm -it pgaudit-docker-test:latest /bin/bash
if [ $? -eq 0 ]; then
	#echo "$(date): succeeded!" >> log/$(date "+%Y-%m").log
	exit 0 	
else
	#echo "$(date): failed!" >> log/$(date "+%Y-%m").log
	exit 1	
fi

echo "test end."
