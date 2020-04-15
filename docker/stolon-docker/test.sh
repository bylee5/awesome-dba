#!/bin/bash

# log directory create
if [ ! -d log ]; then
	mkdir log
fi

# none images delete
docker rmi -f $(docker images -f "dangling=true" -q)
# stolon repo images delete
docker rmi -f $(docker images -q stolon)
# stolon image build
docker build -t stolon:latest ./
# stolon container create
docker run --rm stolon:latest
if [ $? -eq 0 ]; then
	echo "$(date): succeeded!" >> log/$(date "+%Y-%m").log
	exit 0 	
else
	echo "$(date): failed!" >> log/$(date "+%Y-%m").log
	exit 1	
fi

echo "test end."
