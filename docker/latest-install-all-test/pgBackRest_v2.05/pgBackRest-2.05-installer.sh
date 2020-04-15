#!/bin/bash

set -e

rev=2.05

echo
echo "===================================================="
echo " * Setup pgBackRest (v${rev})"
echo "===================================================="
echo

sleep 2

echo
echo "1. Installation"
echo "==========================================="
echo

# checking OS
OS=$(cat /etc/*-release | head -n 1 | awk '{print $1}')
OS_VERSION=""
if [ -n "$OS" ]; then
	if [ "$OS" = "CentOS" ]; then
		OS_VERSION=$(cat /etc/*-release | head -n 1 | grep -o ' [0-9]' | grep -o '[0-9]')

		echo "** OS is $OS, OS version is $OS_VERSION."	
		echo "** PgBackRest was tested on CentOS 6.8 or later."
	else
		echo 
		echo "** This is an untested OS."
		exit 1	
	fi
else
	echo "** OS information can not be checked."
	exit 1
fi 

sleep 2

set +e

# checking libs
# CENTOS 6.x 
if [ "$OS_VERSION" = "6" ]; then
	centos6_openssl=$(rpm -ql openssl)
	if [ $? -ne 0 ]; then
		echo "** openssl NG. Please install."
		exit 1
	fi
	centos6_perl_extutils_embed=$(rpm -ql perl-ExtUtils-Embed)
	if [ $? -ne 0 ]; then
		echo "** perl-ExtUtils-Embed NG. Please install."
		exit 1
	fi
	centos6_perl_libs=$(rpm -ql perl-libs)
	if [ $? -ne 0 ]; then
		echo "** perl-libs NG. Please install."
		exit 1
	fi
	centos6_perl_dbd_pg=$(rpm -ql perl-DBD-Pg)
	if [ $? -ne 0 ]; then
		echo "** perl-DBD-Pg NG. Please install."
		exit 1
	fi
	centos6_perl_digest_sha=$(rpm -ql perl-Digest-SHA)
	if [ $? -ne 0 ]; then
		echo "** perl-Digest-SHA NG. Please install."
		exit 1
	fi
	centos6_perl_io_socket_ssl=$(rpm -ql perl-IO-Socket-SSL)
	if [ $? -ne 0 ]; then
		echo "** perl-IO-Socket-SSL NG. Please install."
		exit 1
	fi
	centos6_perl_json=$(rpm -ql perl-JSON)
	if [ $? -ne 0 ]; then
		echo "perl-JSON NG. Please install."
		exit 1
	fi
	centos6_perl_time_hires=$(rpm -ql perl-Time-HiRes)
	if [ $? -ne 0 ]; then
		echo "** perl-Time-HiRes NG. Please install."
		exit 1
	fi
	centos6_perl_xml_libxml=$(rpm -ql perl-XML-LibXML)
	if [ $? -ne 0 ]; then
		echo "** perl-XML-LibXML NG. Please install."
		exit 1
	fi
	centos6_perl_parent=$(rpm -ql perl-parent)
	if [ $? -ne 0 ]; then
		echo "** perl-parent NG. Please install."
		exit 1
	fi
# CENTOS 7.x
elif [ "$OS_VERSION" = "7" ]; then
	centos7_openssl=$(rpm -ql openssl)
	if [ $? -ne 0 ]; then
		echo "** openssl NG. Please install."
		exit 1
	fi
	centos7_perl_extutils_embed=$(rpm -ql perl-ExtUtils-Embed)
	if [ $? -ne 0 ]; then
		echo "** perl-ExtUtils-Embed NG. Please install."
		exit 1
	fi
	centos7_perl_libs=$(rpm -ql perl-libs)
	if [ $? -ne 0 ]; then
		echo "** perl-libs NG. Please install."
		exit 1
	fi
	centos7_perl_dbd_pg=$(rpm -ql perl-DBD-Pg)
	if [ $? -ne 0 ]; then
		echo "** perl-DBD-Pg NG. Please install."
		exit 1
	fi
	centos7_perl_digest_sha=$(rpm -ql perl-Digest-SHA)
	if [ $? -ne 0 ]; then
		echo "** perl-Digest-SHA NG. Please install."
		exit 1
	fi
	centos7_perl_io_socket_ssl=$(rpm -ql perl-IO-Socket-SSL) 
	if [ $? -ne 0 ]; then
		echo "** perl-IO-Socket-SSL NG. Please install."
		exit 1
	fi
	centos7_perl_json_pp=$(rpm -ql perl-JSON-PP)
	if [ $? -ne 0 ]; then
		echo "** perl-JSON-PP NG. Please install."
		exit 1
	fi
	centos7_perl_time_hires=$(rpm -ql perl-Time-HiRes)
	if [ $? -ne 0 ]; then
		echo "** perl-Time-HiRes NG. Please install."
		exit 1
	fi
	centos7_perl_xml_libxml=$(rpm -ql perl-XML-LibXML)
	if [ $? -ne 0 ]; then
		echo "** perl-XML-LibXML NG. Please install."
		exit 1
	fi
fi

set -e

instdir=$HOME/pgBackRest

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

TAR=2.05.tar.gz
TAR_DIR=pgbackrest-release-2.05

# checking 2.05.tar.gz
if [ -f "$work_home/$TAR" ]; then
	tar xf "$work_home/$TAR"
	echo "** $TAR was unzipped."
	sleep 2
fi


# building pgBackRest v2.05
if [ -d "$work_home/$TAR_DIR/src" ]; then
	mv $work_home/$TAR_DIR/* $instdir
	rm -r $work_home/$TAR_DIR
	make -s -C "$instdir/src"
	echo "** pgBackRest has been built."
	sleep 2
fi

if [ -f ~/.bash_profile ]; then
        . ~/.bash_profile
fi

work_home=$instdir

PGBACKREST_BIN_FILE=pgbackrest
BIN_HOME=$work_home/bin
LOG_HOME=$work_home/log
CONF_HOME=$work_home/conf
BACKUP_HOME=$work_home/backup

# checking PGBACKREST_BIN_FILE
path_flag="0"
if [ -f "$work_home/src/$PGBACKREST_BIN_FILE" ]; then
	if [ ! -d $BIN_HOME ]; then
		mkdir -p $BIN_HOME
	fi
	cp "$work_home/src/$PGBACKREST_BIN_FILE" $BIN_HOME
	echo "Move $PGBACKREST_BIN_FILE to $BIN_HOME"
	chmod 755 "$BIN_HOME/$PGBACKREST_BIN_FILE"

	for dir in ${PATH//:/ }
	do
		if [ -f "${dir}/${PGBACKREST_BIN_FILE}" ]; then
			path_flag="1"
		fi
	done
	if [ "$path_flag" = "0" ]; then
		echo "export PATH=$BIN_HOME:$PATH" >> ~/.bash_profile
		source ~/.bash_profile
		echo "** PgBackRest path was added."
	else
		echo "** PgBackRest path already exist in PATH."
	fi
else 
	echo "** Pgbackrest bin file does not exist."
	exit 1
fi

sleep 2

echo
echo "2. Configuration"
echo "==========================================="
echo

# creating a configuration file
if [ ! -f "$CONF_HOME/pgbackrest.conf" ]; then
	mkdir -p $CONF_HOME
	touch $CONF_HOME/pgbackrest.conf
	chmod 640 $CONF_HOME/pgbackrest.conf 
	echo "** Created the configuration file."
fi

sleep 2

# creating a log directory
if [ ! -d "$LOG_HOME" ]; then
	mkdir -p -m 770 $LOG_HOME
	echo "** Created the log directory."
fi

sleep 2

# configuring a configuration file
if [ ! -s "$CONF_HOME/pgbackrest.conf" ]; then
	echo "Enter stanza name[$USER]."
	echo -n "-> "
	read stanza_name
	if [ -z $stanza_name ]; then
		stanza_name=$USER
	fi
	echo "[$stanza_name]" >> $CONF_HOME/pgbackrest.conf

	ag_data_dir_tmp=$(which agens)
	if [ $? -eq 0 ]; then
		ag_data_dir_tmp=$(agens -c "show data_directory" -d postgres | awk '/home/ {print $1}')
	fi
	if [ -z $ag_data_dir_tmp ]; then
		echo "Enter AgensGraph data directory path[$HOME/AgensGraph/data]."
		echo -n "-> "
		read ag_data_dir
		if [ -z $ag_data_dir ]; then
			ag_data_dir=$HOME/AgensGraph/data
		fi
	else
		echo "Enter AgensGraph data directory path[$ag_data_dir_tmp]."
		echo -n "-> "
		read ag_data_dir
		if [ -z $ag_data_dir ]; then
			ag_data_dir=$ag_data_dir_tmp
		fi
	fi
	echo "pg1-path=$ag_data_dir" >> $CONF_HOME/pgbackrest.conf

	echo "Enter backup directory path[$BACKUP_HOME]."
	echo -n "-> "
	read ag_backup_dir
	if [ -z $ag_backup_dir ]; then
		ag_backup_dir=$BACKUP_HOME
	fi
	if [ ! -d $ag_backup_dir ]; then
		mkdir -p $ag_backup_dir
		echo "Created successfully the backup directory."
	fi
	echo "[global]" >> $CONF_HOME/pgbackrest.conf
	echo "repo1-path=$ag_backup_dir" >> $CONF_HOME/pgbackrest.conf

	echo "log-path=$LOG_HOME" >> $CONF_HOME/pgbackrest.conf
fi

sleep 2

# checking pgbackret install
pgbackrest version > /dev/null
if [ $? -eq 0 ]; then
	echo
	echo "** Completed successfully pgBackRest install with $(pgbackrest version | awk '{print $2}')"
fi



echo
echo "==========================================="
echo " Pre-Installation Summary                  "
echo "==========================================="

echo 
echo "Install home: $BIN_HOME"
echo "Conf home: $CONF_HOME"
echo "Log home: $LOG_HOME"
echo "Backup home: $ag_backup_dir"
echo "Stanza name: $stanza_name"

echo 
echo "Please command source ~/.bash_profile and modify $ag_data_dir/postgresql.conf"
echo "	archive_mode = on"
echo "	archive_command = \"pgbackrest --config=${CONF_HOME}/pgbackrest.conf --stanza=$stanza_name  archive-push %p\""
echo "	max_wal_senders = 10"
echo "	wal_level = hot_standby"
echo 

sleep 3

exit 0

