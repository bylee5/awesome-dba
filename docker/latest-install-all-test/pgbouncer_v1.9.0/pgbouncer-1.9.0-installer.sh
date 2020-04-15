#!/bin/bash

set -e

rev=1.9.0

echo
echo "===================================================="
echo " * Setup pgbouncer (v${rev})"
echo "===================================================="
echo

sleep 2

echo
echo "1. Installation"
echo "==========================================="
echo

# checking for OS
OS=$(cat /etc/*-release | head -n 1 | awk '{print $1}')
OS_VERSION=""
if [ -n "$OS" ]; then
	if [ "$OS" = "CentOS" ]; then
		if [ "6" = $(cat /etc/*-release | head -n 1 | grep -o ' [0-9]' | grep -o '[0-9]') ]; then
			OS_VERSION=$(cat /etc/*-release | head -n 1 | awk '{print $3}')
		else
			OS_VERSION=$(cat /etc/*-release | head -n 1 | awk '{print $4}')	
		fi
		echo "** OS is $OS, OS version is $OS_VERSION."	
		echo "** Pgbouncer was tested on CentOS 6.8 or later."
	else
		echo
		echo "** This is an untested OS."
		exit 1	
	fi
else
	echo
	echo "** OS information can not be checked."
	exit 1
fi 

sleep 2

set +e

# checking for libs

centos_libevent_devel=$(rpm -ql libevent-devel)
if [ $? -ne 0 ]; then
	echo
	echo "** libevent-devel NG. Please install."
	exit 1
fi
centos_libtool=$(rpm -ql libtool)
if [ $? -ne 0 ]; then
	echo
	echo "** libtool NG. Please install."
	exit 1
fi
centos_openssl_devel=$(rpm -ql openssl-devel)
if [ $? -ne 0 ]; then
	echo
	echo "** openssl-devel NG. Please install."
	exit 1
fi
centos_python_docutils=$(rpm -ql python-docutils)
if [ $? -ne 0 ]; then
	echo
	echo "** python-docutils NG. Please install."
	exit 1
fi

set -e

instdir=$HOME/pgbouncer

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

TAR=pgbouncer-1.9.0.tar.gz
TAR_DIR=pgbouncer-1.9.0

# checking for pgbouncer-1.9.0.tar.gz
if [ -f "$work_home/$TAR" ]; then
	tar xf "$work_home/$TAR"
	echo "** $TAR was unzipped."
	sleep 2
fi


# building pgbouncer v1.9.0
if [ -d "$work_home/$TAR_DIR/src" ]; then
	cd $work_home/$TAR_DIR	
	./configure --prefix=$instdir > /dev/null
	make > /dev/null
	make install > /dev/null
	cd $work_home
	rm -rf $work_home/$TAR_DIR
	echo "** Pgbouncer has been built."
	sleep 2
fi

if [ -f ~/.bash_profile ]; then
        . ~/.bash_profile
fi

work_home=$instdir

PGBOUNCER_BIN_FILE=pgbouncer
BIN_HOME=$work_home/bin
LOG_HOME=$work_home/log
CONF_HOME=$work_home/conf

# checking for PGBACKREST_BIN_FILE
path_flag="0"
if [ -f "$BIN_HOME/$PGBOUNCER_BIN_FILE" ]; then
	for dir in ${PATH//:/ }
	do
		if [ -f "${dir}/${PGBOUNCER_BIN_FILE}" ]; then
			path_flag="1"
		fi
	done
	if [ "$path_flag" = "0" ]; then
		echo "export PATH=$BIN_HOME:$PATH" >> ~/.bash_profile
		source ~/.bash_profile
		echo "** Pgbouncer path was added."
	else
		echo "** Pgbouncer path already exists in PATH."
	fi
else 
	echo "** Pgbouncer bin file does not exist."
	exit 1
fi

sleep 2

echo
echo "2. Configuration"
echo "==========================================="
echo

# creating a configuration file
if [ ! -f "$CONF_HOME/pgbouncer.ini" ]; then
	mkdir -p $CONF_HOME
	touch $CONF_HOME/pgbouncer.ini
	chmod 640 $CONF_HOME/pgbouncer.ini
	#echo "** Completed successfully the configuration file."
fi

sleep 2

# creating a log directory
if [ ! -d "$LOG_HOME" ]; then
	mkdir -p -m 770 $LOG_HOME
	#echo "** Completed successfully the log directory."
fi

sleep 2

# configuring a configuration file
if [ ! -s "$CONF_HOME/pgbouncer.ini" ]; then
	echo "* AgensGraph Connection Infomation"
	echo "----------------------------------------------"
	echo
	echo "Enter db name[$(whoami)]."
	echo -n "-> "
	read db_name
	if [ -z $db_name ]; then
		db_name=$(whoami)
	fi
	echo "Enter host name[127.0.0.1]."
	echo -n "-> "
	read host_name
	if [ -z $host_name ]; then
		host_name="127.0.0.1"
	fi
	echo "Enter db port[5432]."
	echo -n "-> "
	read db_port
	if [ -z $db_port ];then
		db_port=5432
	fi
	echo "[databases]" >> $CONF_HOME/pgbouncer.ini
	echo "$db_name = host=$host_name port=$db_port dbname=$db_name" >> $CONF_HOME/pgbouncer.ini

	echo 
	echo "* Pgbouncer Configuration"
	echo "----------------------------------------------"
	echo
	echo "Enter admin_users option[$(whoami)]."
	echo -n "-> "
	read admin_users
	if [ -z $admin_users ]; then
		admin_users=$(whoami)
	fi
	echo "[pgbouncer]" >> $CONF_HOME/pgbouncer.ini
	echo "admin_users=$admin_users" >> $CONF_HOME/pgbouncer.ini

	echo "Enter listen_port option[6543]."
	echo -n "-> "
	read listen_port
	if [ -z $listen_port ]; then
		listen_port=6543
	fi
	echo "listen_port=$listen_port" >> $CONF_HOME/pgbouncer.ini

	echo "Enter listen_addr option[*]."
	echo -n "-> "
	read listen_addr
	if [ -z $listen_addr ]; then
		listen_addr=*
	fi
	echo "listen_addr=$listen_addr" >> $CONF_HOME/pgbouncer.ini

	echo "Enter auth_type option[trust]."
	echo -n "-> "
	read auth_type
	if [ -z $auth_type ]; then
		auth_type=trust
	fi
	echo "auth_type=$auth_type" >> $CONF_HOME/pgbouncer.ini

	echo "Enter auth_file option[$CONF_HOME/users.txt]."
	echo -n "-> "
	read auth_file
	if [ -z $auth_file ]; then
		auth_file=$CONF_HOME/users.txt
	fi
	echo "auth_file=$auth_file" >> $CONF_HOME/pgbouncer.ini

	if [ ! -f "$auth_file" ]; then
		touch $auth_file
		chmod 640 $auth_file
		echo "\"$(whoami)\" \"\"" >> $auth_file
	fi

	echo "Enter logfile option[$LOG_HOME/pgbouncer.log]."
	echo -n "-> "
	read logfile
	if [ -z $logfile ]; then
		logfile=$LOG_HOME/pgbouncer.log
	fi
	echo "logfile=$logfile" >> $CONF_HOME/pgbouncer.ini

	echo "Enter pidfile option[$instdir/pgbouncer.pid]."
	echo -n "-> "
	read pidfile
	if [ -z $pidfile ]; then
		pidfile=$instdir/pgbouncer.pid
	fi
	echo "pidfile=$pidfile" >> $CONF_HOME/pgbouncer.ini

	sleep 1
	echo "** Created pgbackrest.ini file."
fi

sleep 2

# runing pgbouncer
pgbouncer --version > /dev/null
if [ $? -eq 0 ]; then
	echo
	echo "** Completed successfully pgbouncer installation with $(pgbouncer --version | awk '{print $3}')."
fi

pgbouncer -d $CONF_HOME/pgbouncer.ini
if [ $? -eq 0 ]; then
	echo
	echo "** Pgbouncer started."
fi

echo
echo "==========================================="
echo " * Pre-Installation Summary                  "
echo "==========================================="

echo 
echo "Pgbouncer home: $instdir"
echo "Pgbouncer port: $listen_port"
echo "Conf home: $CONF_HOME"
echo "Log home: $LOG_HOME"
echo 
echo "Please command source ~/.bash_profile"
echo 

sleep 3

exit 0

