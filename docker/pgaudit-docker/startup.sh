#!/bin/bash

#OUTPUT COLOR
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

#AGENSGRAPH START
echo -e "${GREEN}AgensGraph init${NC}"
initdb -D $AGDATA

echo -e "${GREEN}Set shared_preload_libraries option${NC}"
echo "shared_preload_libraries='pgaudit'" >> $AGDATA/postgresql.conf

echo -e "${GREEN}Start AgensGraph${NC}"
ag_ctl -D $AGDATA start

echo -e "${GREEN}Checks for port 5432${NC}"
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

echo -e "${GREEN}Create createdb agens${NC}"
createdb agens

#PGAUDIT TEST
cd $PAHOME

echo -e "${GREEN}Modify pgAudit Makefile${NC}"
cat Makefile | sed "s/REGRESS = pgaudit/REGRESS = pgaudit cypher/" > Makefile_modified
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify pgAudit Makefile${NC}"
    exit
fi
mv -f Makefile Makefile_bak
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify pgAudit Makefile${NC}"
    exit
fi
mv Makefile_modified Makefile
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify pgAudit Makefile${NC}"
    exit
fi

make installcheck
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Make installcheck${NC}"
    exit
fi

exec "$@"
