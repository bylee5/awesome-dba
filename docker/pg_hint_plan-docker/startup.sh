#!/bin/bash

#OUTPUT COLOR
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

#AGENSGRAPH START
echo -e "${GREEN}AgensGraph init${NC}"
initdb -D $AGDATA

echo -e "${GREEN}Set shared_preload_libraries option${NC}"
echo "shared_preload_libraries = 'pg_stat_statements,pg_hint_plan'" >> $AGDATA/postgresql.conf

echo -e "${GREEN}Start AgensGraph${NC}"
ag_ctl -D $AGDATA start

echo -e "${GREEN}AgensGraph checks for port 5432${NC}"
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

#PG_HINT_PLAN TEST
#Modify pg_hint_plan Makefile
cd $PHPHOME

echo -e "${GREEN}Modify pg_hint_plan Makefile${NC}"
cat Makefile | sed "s/REGRESS = init base_plan pg_hint_plan ut-init ut-A ut-S ut-J ut-L ut-G ut-R ut-fdw ut-W ut-T ut-fini/REGRESS = init base_plan pg_hint_plan ut-init ut-A ut-S ut-J ut-L ut-G ut-R ut-fdw ut-W ut-T ut-fini cypher/" > Makefile_modified
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify pg_hint_plan Makefile${NC}"
    exit
fi
mv -f Makefile Makefile_bak
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify pg_hint_plan Makefile${NC}"
    exit
fi
mv Makefile_modified Makefile
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify pg_hint_plan Makefile${NC}"
    exit
fi

#make installcheck
echo -e "${GREEN}Make installcheck${NC}"
make installcheck
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Make installcheck${NC}"
    exit
fi

exec "$@"
