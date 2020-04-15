#!/bin/bash

#OUTPUT COLOR
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

#AGENSGRAPH START
echo -e "${GREEN}AgensGraph initdb${NC}"
initdb -D $AGDATA

echo -e "${GREEN}AgensGraph Start${NC}"
ag_ctl -D $AGDATA start

echo -e "${GREEN}Check for PORT 5432${NC}"
for i in 5432
do
	StartTime=$(date +%s)
	echo -n "Connecting to 0.0.0.0 on port $i"
	while :
	do
		EndTime=$(date +%s)
		(echo > /dev/tcp/0.0.0.0/$i) >/dev/null 2>&1
        	result=$?
		if [ $result -eq 0 ]; then
			break
		else
			if [ $(($EndTime - $StartTime)) -gt 60 ]; then
                		exit 1
            		fi
			echo -n "." 
			sleep 1
		fi
	done
	echo -e "\nConnection to 0.0.0.0 on port $i succeeded."
done

echo -e "${GREEN}Createdb agens${NC}"
createdb agens

#PGAUDIT TEST
cd $PAHOME/test

echo -e "${GREEN}Modify pgAgent Makefile${NC}"
cat Makefile | sed "s/REGRESS = init job/REGRESS = init job cypher/" > Makefile_modified
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify pgAgent Makefile${NC}"
    exit
fi
mv -f Makefile Makefile_bak
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify pgAgent Makefile${NC}"
    exit
fi
mv Makefile_modified Makefile
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify pgAgent Makefile${NC}"
    exit
fi

#make installcheck
cd $PAHOME

echo -e "${GREEN}Make installcheck${NC}"
make PGUSER=agens USE_PGXS=1 -f test/Makefile installcheck
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Make installcheck${NC}"
    exit
fi

exec "$@"
