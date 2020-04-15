#!/bin/bash

#docker rmi -f $(docker images -q install-all-test)
docker build -t install-all-test:latest ./
docker run --rm -it install-all-test:latest /bin/bash
