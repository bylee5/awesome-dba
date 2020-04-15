#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

set -e

rev=1.3.3

echo
echo "===================================================="
echo " * Setup pg_hint_plan (v${rev})"
echo "===================================================="
echo

sleep 1

# set .bash_profile
if [ -f ~/.bash_profile ]; then
        . ~/.bash_profile
fi

# checking for OS
OS=$(cat /etc/*-release | head -n 1 | awk '{print $1}')
OS_VERSION=""
if [ -n "$OS" ]; then
	if [ "$OS" = "CentOS" ]; then
		OS_VERSION=$(cat /etc/*-release | head -n 1 | grep -o ' [0-9]' | grep -o '[0-9]')
		echo -e "${GREEN}OS=$OS, VERSION=$OS_VERSION${NC}"
	else
		echo -e "${GREEN}This is an unsupported OS${NC}"
		exit 1	
	fi
else
	echo -e "${GREEN}OS information can not be checked${NC}"
	exit 1
fi 

sleep 2

# install pgaudit
TAR=pg_hint_plan-1.3.3.tar.gz
TAR_DIR=pg_hint_plan

tar xf $TAR
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: File Not Found \"$work_home\"${NC}"
    exit
fi

cd $TAR_DIR
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$work_home\"${NC}"
    exit
fi

make USE_PGXS=1 install
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Install pg_hint_plan \"$work_home$TAR_DIR\"${NC}"
    exit
fi

cd ../
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$work_home\"${NC}"
    exit
fi

rm -rf $TAR_DIR
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: rmdir $TAR_DIR \"$work_home\"${NC}"
    exit
fi

# set shared_preload_libraries
shared_preload_libraries_line_count=$(grep "^shared_preload_libraries" $AGDATA/postgresql.conf | wc -l)
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Show shared_preload_libraries ${NC}"
    exit
fi

if [ 0 -eq $shared_preload_libraries_line_count ]; then
	cat $AGDATA/postgresql.conf | sed "s/#shared_preload_libraries = 'pg_stat_statements,pg_statsinfo,pg_hint_plan,hll'/shared_preload_libraries = 'pg_stat_statements,pg_hint_plan'/" > $AGDATA/postgresql.conf_modified
	if [ $? -ne 0 ]; then
    	echo -e "${RED}Failed: Modify postgresql.conf${NC}"
    	exit
	fi
else 
	shared_preload_library_list=$(grep shared_preload_libraries $AGDATA/postgresql.conf | awk '{print $3}' | sed "s/'//g")
	cat $AGDATA/postgresql.conf | sed "s/shared_preload_libraries = '${shared_preload_library_list}'/shared_preload_libraries = '${shared_preload_library_list},pg_hint_plan'/" > $AGDATA/postgresql.conf_modified
	if [ $? -ne 0 ]; then
    	echo -e "${RED}Failed: Modify postgresql.conf${NC}"
    	exit
	fi
fi

mv -f $AGDATA/postgresql.conf $AGDATA/postgresql.conf_bak
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify postgresql.conf${NC}"
    exit
fi

mv $AGDATA/postgresql.conf_modified $AGDATA/postgresql.conf
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify postgresql.conf${NC}"
    exit
fi

echo -e "** Completed successfully pg_hint_plan."

sleep 2

echo -e "** Restart Agens Graph."
ag_ctl -w restart
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Restart Agens Graph${NC}"
    exit
fi

exit 0

