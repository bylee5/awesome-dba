#!/bin/bash

set -e

rev=0.12.0

echo
echo "===================================================="
echo " * Setup Stolon (v${rev})"
echo "===================================================="
echo

sleep 2

instdir=$HOME/Stolon

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

# checking OS
echo "Please check linux-amd64. To continue, press Enter."
echo -n "-> "
read tmp_os

# creating install directory
_check_idir

work_home=$(pwd)
if [ "$work_home" = "/" ]; then
	work_home=""
fi

ETCD_TAR=etcd-v3.3.9-linux-amd64.tar.gz
ETCD_TAR_DIR=etcd-v3.3.9-linux-amd64
ETCD_FILE=etcd
ETCDCTL_FILE=etcdctl
ETCD_HOME=$instdir/etcd

# checking etcd-v3.3.9-linux-amd64.tar.gz
if [ -f "$work_home/$ETCD_TAR" ]; then
	tar xf "$work_home/$ETCD_TAR"
	echo "** $ETCD_TAR was unzipped."
	sleep 2
fi

sleep 2

#checking ETCD_HOME
if [ ! -d "$ETCD_HOME" ]; then
	mkdir -p $ETCD_HOME
	echo "** Created Etcd directory."
	mv $work_home/$ETCD_TAR_DIR/* $ETCD_HOME
fi

#checking ETCD DATA
if [ ! -d "$ETCD_HOME/data" ]; then
	mkdir $ETCD_HOME/data
	echo "** Created Etcd data directory."
fi

#checking ETCD LOG
if [ ! -d "$ETCD_HOME/log" ]; then
	mkdir $ETCD_HOME/log
	echo "** Created Etcd log directory."
fi

if [ -f ~/.bash_profile ]; then
        . ~/.bash_profile
fi

# checking PATH
path_flag="0"
for dir in ${PATH//:/ }
do
	if [ -f "${dir}/${ETCD_FILE}" \
	-a -f "${dir}/${ETCDCTL_FILE}" ]; then
		path_flag="1"
	fi
done
if [ "$path_flag" = "0" ]; then
	echo "export PATH=$ETCD_HOME:$PATH" >> ~/.bash_profile
	source ~/.bash_profile
	echo "Etcd path was added."
else
	echo "Etcd path already exist in PATH."
fi

sleep 2

STOLON_TAR=stolon-v0.12.0-linux-amd64.tar.gz
STOLON_TAR_DIR=stolon-v0.12.0-linux-amd64
STOLONCTL_FILE=stolonctl
STOLON_KEEPER_FILE=stolon-keeper
STOLON_PROXY_FILE=stolon-proxy
STOLON_SENTINEL_FILE=stolon-sentinel
STOLON_HOME=$instdir

# checking stolon-v0.12.0-linux-amd64.tar.gz
if [ -f "$work_home/$STOLON_TAR" ]; then
	tar xf "$work_home/$STOLON_TAR"
	echo "$STOLON_TAR was unzipped."
	sleep 2
fi

sleep 2

#checking STOLON_HOME
if [ -d "$STOLON_HOME" ]; then
	mv $work_home/$STOLON_TAR_DIR/* $STOLON_HOME
fi

#checking ETCD DATA
if [ ! -d "$STOLON_HOME/data" ]; then
	mkdir $STOLON_HOME/data
	echo "** Created Stolon data directory."
fi

#checking ETCD LOG
if [ ! -d "$STOLON_HOME/log" ]; then
	mkdir $STOLON_HOME/log
	echo "** Created Stolon log directory."
fi

# checking PATH
path_flag="0"
for dir in ${PATH//:/ }
do
	if [ -f "${dir}/${STOLONCTL_FILE}" \
	-a -f "${dir}/${STOLON_KEEPER_FILE}" \
	-a -f "${dir}/${STOLON_PROXY_FILE}" \
	-a -f "${dir}/${STOLON_SENTINEL_FILE}" ]; then
		path_flag="1"
	fi
done
if [ "$path_flag" = "0" ]; then
	echo "export PATH=${STOLON_HOME}/bin:$PATH" >> ~/.bash_profile
	source ~/.bash_profile
	echo "** Stolon path was added."
else
	echo "** Stolon path already exist in PATH."
fi

sleep 2

# checking etcdctl install
etcdctl -v > /dev/null
if [ $? -eq 0 ]; then
	echo
	echo "** Completed successfully Etcd install with $(etcdctl -v | awk '/etcdctl/{print $3}')"
fi

# checking stolonctl install
stolonctl --version > /dev/null
if [ $? -eq 0 ]; then
	echo
	echo "** Completed successfully Stolon install with $(stolonctl --version | awk '{print $3}')"
fi


echo
echo "==========================================="
echo " Pre-Installation Summary                  "
echo "==========================================="

echo 
echo "Etcd install home: $ETCD_HOME"
echo "Etcd data home: $ETCD_HOME/data"
echo "Etcd log home: $ETCD_HOME/log"
echo
echo "Stolon install home: $STOLON_HOME"
echo "Stolon data home: $STOLON_HOME/data"
echo "Stolon log home: $STOLON_HOME/log"
echo
echo "Please command source ~/.bash_profile"
echo 

sleep 3

exit 0

