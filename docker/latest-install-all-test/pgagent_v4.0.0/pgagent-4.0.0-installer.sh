#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

set -e

rev=4.0.0

echo
echo "===================================================="
echo " * Setup pgaudit (v${rev})"
echo "===================================================="
echo

sleep 2

echo "1. Installation"
echo "==========================================="
echo

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

set +e

# checking for libs
centos_cmake3=$(rpm -ql cmake3)
if [ $? -ne 0 ]; then
	echo
	echo "** cmake3 NG. Please install."
	exit 1
fi
centos_boost_devel=$(rpm -ql boost-devel)
if [ $? -ne 0 ]; then
	echo
	echo "** boost-devel NG. Please install."
	exit 1
fi

set -e 

instdir=$HOME/pgagent

_check_idir() {
        if [ -d $instdir ]; then
                echo
                echo ""$instdir" is already exists. Please specify the another directory."
        	echo -n "-> "
            	read instdir
                        while true; do
                    if [ -d $instdir ]; then
                        echo
                        echo ""$instdir" is already exists. Please specify the another directory."
                        echo -n "-> "
                        read instdir
                    else
                        mkdir -p $instdir
                        instdir=$instdir
                        echo
                        echo "** Install Directory is $instdir"
                        break
                    fi
                done
        else
        mkdir -p $instdir
        instdir=$instdir
                echo
        echo "** Install Directory is $instdir"
    fi
}

# creating install directory
_check_idir

work_home=$(pwd)
if [ "$work_home" = "/" ]; then
	work_home=""
fi

# set .bash_profile
if [ -f ~/.bash_profile ]; then
        . ~/.bash_profile
fi

# install pgaudit
TAR=pgagent-REL-4_0_0.tar.gz
TAR_DIR=pgagent-REL-4_0_0

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

cmake3  -D BOOST_ROOT:PATH=/usr/lib64 \
        -D BOOST_STATIC_BUILD:BOOL=OFF \
        -D CMAKE_INSTALL_PREFIX:PATH=$instdir \
	    -D PG_CONFIG_PATH:FILEPATH=$AGHOME/bin/pg_config \
	    -D STATIC_BUILD:BOOL=OFF . > /dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: cmake3 \"$work_home$TAR_DIR\"${NC}"
    exit
fi

make USE_PGXS=1 install
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: make install \"$work_home$TAR_DIR\"${NC}"
    exit
fi

# checking for PGAGENT_BIN_FILE
work_home=$instdir
PGAGENT_BIN_FILE=pgagent
BIN_HOME=$work_home/bin

path_flag="0"
if [ -f "$BIN_HOME/$PGAGENT_BIN_FILE" ]; then
	for dir in ${PATH//:/ }
	do
		if [ -f "${dir}/${PGAGENT_BIN_FILE}" ]; then
			path_flag="1"
		fi
	done
	if [ "$path_flag" = "0" ]; then
		echo "export PATH=$BIN_HOME:$PATH" >> ~/.bash_profile
		source ~/.bash_profile
		echo "** Pgagent path was added."
	else
		echo "** Pgagent path already exists in PATH."
	fi
else 
	echo "** Pgagent bin file does not exist."
	exit 1
fi

sleep 2


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

sleep 2

echo
echo "2. Configuration"
echo "==========================================="
echo

echo "Enter log level[ERROR=0, WARNING=1, DEBUG=2, default=0]."
echo -n "-> "
read log_level
if [ -z $log_level ]; then
	log_level=0
fi

LOG_HOME=$work_home/log

# creating a log directory
if [ ! -d "$LOG_HOME" ]; then
	mkdir -p -m 770 $LOG_HOME
	#echo "** Completed successfully the log directory."
fi

echo "Enter logfile option[$LOG_HOME/pgagent.log]."
echo -n "-> "
read logfile
if [ -z $logfile ]; then
	logfile=$LOG_HOME/pgagent.log
fi

echo "Enter user name[$(whoami)]."
echo -n "-> "
read user_name
if [ -z $user_name ]; then
	user_name=$(whoami)
fi

echo "Enter db name[$(whoami)]."
echo -n "-> "
read db_name
if [ -z $db_name ]; then
	db_name=$(whoami)
fi

IP_ADDR=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
echo "Enter host name[$IP_ADDR]."
echo -n "-> "
read host_name
if [ -z $host_name ]; then
	host_name=$IP_ADDR
fi
echo "Enter db port[5432]."
echo -n "-> "
read db_port
if [ -z $db_port ];then
	db_port=5432
fi

sleep 2
echo "** Created pgagent configuration."

# runing pgagent
pgagent -v > /dev/null
if [ $? -ne 0 ]; then
	echo -e "${RED}Failed: Check pgagent version${NC}"
    exit
fi

agens -c "CREATE EXTENSION pgagent" > /dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: CREATE EXTENSION pgagent${NC}"
    exit
fi

pgagent -f -l $log_level -s $logfile "user=$user_name dbname=$db_name" &
if [ $? -ne 0 ]; then
	echo -e "${RED}Failed: Runing pgagent${NC}"
    exit
fi

sleep 2
echo "** Completed successfully pgagent installation with $(pgagent -v | tail -n 1 | awk '{print $2}')."

sleep 2
echo
echo "==========================================="
echo " * Pre-Installation Summary                "
echo "==========================================="

echo 
echo "Pgagent home: $instdir"
echo "Log home: $LOG_HOME"
echo 
echo "Please command source ~/.bash_profile"
echo 

sleep 1

exit 0

