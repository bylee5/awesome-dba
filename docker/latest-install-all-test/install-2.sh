#!/bin/bash 

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

cd ./AgensGraph_v2.1.2
./AgensGraph-2.1.2-linux-installer.sh
if [ $? -ne 0 ]; then
	echo -e "${RED}Failed: Install AgensGraph \"$(pwd)\"${NC}"
	exit
fi

sleep 5
cd ../AgensBrowser_v1.1
./AgensBrowser-1.1-installer.sh

if [ $? -ne 0 ]; then
	echo "AgensBrowser install failed!" 
fi

sleep 5
cd ../pgBackRest_v2.05
./pgBackRest-2.05-installer.sh

if [ $? -ne 0 ]; then
	echo "pgBackRest install failed!" 
fi

sleep 5
cd ../stolon_v0.12.0
./stolon-0.12.0-installer.sh

if [ $? -ne 0 ]; then
	echo "Stolon install failed!" 
fi

sleep 5
cd ../pgbouncer_v1.9.0
./pgbouncer-1.9.0-installer.sh

if [ $? -ne 0 ]; then
	echo "pgbouncer install failed!" 
fi

sleep 5
cd ../pgaudit_v1.2.1
./pgaudit-1.2.1-installer.sh
if [ $? -ne 0 ]; then
	echo "pgaudit install failed!" 
fi

sleep 5
cd ../pgagent_v4.0.0
./pgagent-4.0.0-installer.sh
if [ $? -ne 0 ]; then
	echo "pgagent install failed!" 
fi

sleep 5
cd ../pg_hint_plan_v1.3.3
./pg_hint_plan-1.3.3-installer.sh
if [ $? -ne 0 ]; then
	echo "pg_hint_plan install failed!" 
fi

exit 0
