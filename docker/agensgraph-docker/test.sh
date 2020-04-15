#!/bin/bash

# none images delete
#docker rmi -f $(docker images -f "dangling=true" -q)
# stolon repo images delete
#docker rmi -f $(docker images -q stolon)
# stolon image build
docker build -t agensgraph:latest ./
# stolon container create
docker run --rm -it agensgraph:latest /bin/bash

echo "test end."
