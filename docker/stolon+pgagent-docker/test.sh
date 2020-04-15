#!/bin/bash

#docker rmi -f $(docker images -f "dangling=true" -q)
# stolon repo images delete
#docker rmi -f $(docker images -q stolon)
# stolon image build
docker build -t stolon_pgagent-test:latest ./
# stolon container create
docker run --rm -it -p 15435:5432 stolon_pgagent-test:latest /bin/bash


echo "test end."
