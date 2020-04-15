#!/bin/bash -f

TIMESTAMP=[`date "+%Y-%m-%d %H:%M:%S"`]

echo "Log started at $TIMESTAMP" >> $HOME/AgensGraph-install.log 2>&1

# check OS version
_check_OS() {
    if [ $(uname -a | awk '{print $1}') != "${1}" ]; then
        echo "you must run this as ${1}"
        exit 0
    else
		echo "$TIMESTAMP OS version is $(uname -a | awk '{print $1, $3}')"
    fi

}
# check for the current os user
_check_user() {
    if [ $(id -un) != "${1}" ]; then
        echo  "you must run this as ${1}"
        exit 0
	else
		echo "$TIMESTAMP User is $(id -un)"
    fi
}

_check_java() {
    version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    if [[ "$version" > "1.8" ]]; then
		echo "$TIMESTAMP Java version is $version"
    else
        echo version is less than 1.8
        exit 0
    fi
}

# install required software
#_install_required_software() {
#    _log "*** installing required software "
#    yum install -y gcc glibc glib-common readline readline-devel zlib zlib-devel
#}

_check_OS Linux >> $HOME/AgensGraph-install.log 2>&1
_check_user `id -un` >> $HOME/AgensGraph-install.log 2>&1
_check_java >> $HOME/AgensGraph-install.log 2>&1
#_install_required_software &> AgensGraph-install.log


# Directory exist check
_check_idir() {
	if [ -d $instdir/AgensGraph ]; then
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

_check_ddir() {
    if [ -d $datadir ]; then
		echo
        echo ""$datadir/data" is already exists. Please specify the another directory."
        echo -n "-> "
            read datadir
                 while true; do
                     if [ -d $datadir ]; then
						echo
                        echo ""$datadir" is already exists. Please specify the another directory."
                        echo -n "-> "
                        read datadir
                     else
                        datadir=$datadir
						echo 
                        echo "** Data Directory is $datadir" 
                        break
                     fi
                done
    else
        datadir=$datadir
		echo
        echo "** Data Directory is $datadir"
    fi
}

# information check
_check_info() {
     read setinfo
    	 state=FALSE
      	       while [ $state == "FALSE" ]; do
              		case $setinfo in
              		[yY]|'')
              		    state=TRUE
              		    echo
              		    echo "Install start!"
						echo
					
              		;;
              		[nN]*)
              		     state=TRUE
              		     echo "Information is not correct!"
              		     echo "Input AGHOME"

              		     read instdir
              		     AGHOME=$instdir
              		     _check_idir
              		     echo "Input AGDATA"

              		     read datadir
              		     AGDATA=$datadir
              		     _check_ddir
              		;;
              		*)
              		     echo "Invalid Option! Please input your choice (y/n)"
              		     read setinfo
              		;;
              		esac
               done
}

# port check
_port_check() {
	nstat=`netstat -ant | grep LISTEN | grep $agport | awk '{print $4}' | sed 's/\:/ /g' | awk '{print $2}'`
	if [ "$nstat" = "" ]; then
		export PGPORT=$agport
	    echo
	    echo "** AgensGraph port $agport"
	else
	    echo "Another process is using $agport"
	    agport=$((agport+1))
			echo
	        echo "AgensGraph $rev will be configured on port $agport"
	        echo "Enter the port, or press [Enter] to accept $agport"
	        echo -n "-> "
	        PGPORT=$agport
	        read enter
			echo $enter
	        	if [ "$enter" = "" ]; then
					export PG_PORT=$enter
	            	continue
	                echo 
	                echo "** AgensGraph port $PGPORT"
	            else
	                PGPORT=$enter
	                echo
	                echo "** AgensGraph port $PGPORT"
					export PGPORT=$PGPORT
	            fi
	fi
}

# database passwd
_set_passwd() {
echo "Press [Enter] to accept the default.(Default User: agens)"

unset passwd
unset repasswd
prompt="password: "
while IFS= read -p "$prompt" -r -s -n 1 pw; do
    if [[ "$pw" == $'\0' ]]
    then
        break
    fi
    prompt='*'
    passwd+="$pw"
done
echo

prompt="retype password: "
while IFS= read -p "$prompt" -r -s -n 1 repw; do
    if [[ "$repw" == $'\0' ]]
    then
        break
    fi
    prompt='*'
    repasswd+="$repw"
done
echo

passwd=$passwd
repasswd=$repasswd

}

_check_passwd() {
while true; do
    if [[ "$passwd" == "$repasswd" ]]; then
        passwd=$passwd
        repasswd=$repasswd
        break
    else
        echo
        echo "passwords do not match!"
        echo "Please enter your password again."
		echo
        _set_passwd
    fi
done
}

# add agens environment to .bash_profile.agens
#_create_env() {
#    echo "export AGHOME=$AGHOME" >> $HOME/.bash_profile.agens
#    echo "export AGDATA=$AGDATA" >> $HOME/.bash_profile.agens
#    echo "export PATH=$AGHOME/bin:${PATH}" >> $HOME/.bash_profile.agens
#    echo "export LD_LIBRARY_PATH=$AGHOME/lib:${LD_LIBRARY_PATH}" >> $HOME/.bash_profile.agens
#    echo "export PGPORT=$PGPORT"  >> $HOME/.bash_profile.agens
#}

# add agens environment to .bash_profile
_create_env() {
    echo "export AGHOME=$AGHOME" >> $HOME/.bash_profile
    echo "export AGDATA=$AGDATA" >> $HOME/.bash_profile
    echo "export PATH=$AGHOME/bin:${PATH}:$PATH" >> $HOME/.bash_profile
    echo "export LD_LIBRARY_PATH=$AGHOME/lib:${LD_LIBRARY_PATH}" >> $HOME/.bash_profile
    echo "export PGPORT=$PGPORT"  >> $HOME/.bash_profile
}

# env
rev=2.1.1
agport=5432

echo "==========================================="
echo " * Setup AgensGraph (v$rev)                "
echo "==========================================="

# set install location
echo
echo "1. Installation Location"
echo "==========================================="
echo
echo "Please specify the directory where AgensGraph will be installed."
echo
echo "Default Install Path : $HOME"
echo
echo "Enter an absolute path, or Press [Enter] to accept the default."
echo -n "-> "

read instdir
        if [ "$instdir" == "" ]; then
                instdir=$HOME
                _check_idir
        else
                instdir="$instdir"
                _check_idir
        fi

echo
echo "* AgensGraph password                      "
echo "-------------------------------------------"
echo
echo "Please provide a password for the superuser(agens) database user."
_set_passwd
_check_passwd

if [[ "$passwd" == "" && "$repasswd" == "" ]]; then
        passwd=agens
        repasswd=agens
fi

# set install type
echo
echo "2. Select Installation Type"
echo "==========================================="
echo
echo "Please select the Installation Type to install."
echo
echo "1) Typical <default>"
echo "2) Custom"
echo
echo "Enter the number for the install set,or press [Enter] to accept the default."
echo -n "-> "
	itype=FALSE
		while [ $itype == "FALSE" ]; do
            read tt
            case $tt in
            1|'')
            itype=TRUE
           
            echo
            echo "==========================================="
            echo " Pre-Installation Summary                  "
            echo "==========================================="
            echo "Please Review the Following Information Before Continuing."
            echo
            echo "Installation Directory : $instdir"
            echo
            echo "AgensGraph will be configured on port : $agport"
            echo 
            echo "A new database cluster will be created at $instdir/AgensGraph/data"
            echo
            echo "Username : agens"
            echo -n "Password : " 
			echo $passwd | sed "s/[$passwd]/*/g"
            echo
            echo "Is this information correct? (y/n)"
            echo -n "-> "

            _check_info

			echo 
			echo "* AgensGraph port                          "
			echo "-------------------------------------------"
			while true; do
            _port_check
			break
			done
			echo
            
			export AGHOME=$instdir/AgensGraph
            export AGDATA=$instdir/AgensGraph/data

            ;;

            2)
            itype=TRUE
            echo
            echo "# Data Directory"
            echo "-------------------------------------------"
            echo
            echo "Please specify the data directory."
            echo
            echo "Default data directory : "$instdir/AgensGraph/data""
            echo "Enter an absolute path, or Press [Enter] to accept the default."
            echo -n "-> "

            read datadir
            if [ "$datadir" == "" ]; then
                datadir="$instdir/AgensGraph/data"
                _check_ddir
            else
                datadir="$datadir"
                _check_ddir
            fi

            echo
            echo "# AgensGraph Port"
            echo "-------------------------------------------"
            echo
            echo "Please specify the AgensGraph Port."
			echo
            echo "Default agensgraph port : $agport"
			echo
            echo "Enter an port, or Press [Enter] to accept the default."
            echo -n "-> " 

            read newport
            if [ "$newport" = "" ]; then
                agport="$agport"
                echo "* Port is $agport"
            else
                agport="$newport"
                echo "* Port is $agport"
            fi

            echo
            echo "==========================================="
            echo " Pre-Installation Summary                  "
            echo "==========================================="
            echo "Please Review the Following Information Before Continuing."
            echo
            echo "Installation Directory : $instdir"
            echo
            echo "AgensGraph will be configured on port : $agport"
            echo
            echo "A new database cluster will be created at $datadir"
            echo
            echo "Username : agens"
            echo -n "Password :" 
			echo $passwd | sed "s/[$passwd]/*/g" 
            echo
            echo "Is this information correct? (y/n)"
            echo -n "-> "

            export AGHOME=$instdir/AgensGraph
            export AGDATA=$datadir

            _check_info

			echo 
			echo "* AgensGraph port                          "
			echo "-------------------------------------------"
			while true; do
			_port_check
			break
			done
			echo

            ;;

            *)
            echo "Invalid Number! please input your choice 1 or 2"
            ;;

            esac
	done

# set env
_create_env

#binary mv
tar xzf AgensGraph_v2.1.2_linux_CE.tar.gz
mv AgensGraph $instdir
#rm AgensGraph_v2.1.2_linux_CE.tar.gz

# set env
cd $HOME
#. .bash_profile.agens
. .bash_profile

# initdb
#$AGHOME/bin/initdb -D $AGDATA -U agens 2>> $HOME/AgensGraph-install.log
$AGHOME/bin/initdb -D $AGDATA 2>> $HOME/AgensGraph-install.log
sleep 2

# agens start
$AGHOME/bin/ag_ctl start 2>> $HOME/AgensGraph-install.log
sleep 2

# create database
#$AGHOME/bin/createdb agens -U agens -w $passwd 2>> $HOME/AgensGraph-install.log
$AGHOME/bin/createdb 2>> $HOME/AgensGraph-install.log
sleep 2

username=`whoami`
#echo $username

# set user password
echo
echo "* SET DBUSER PASSWORD                         "
echo "----------------------------------------------"
#agens -U agens -t -c "alter user agens password '$passwd'"
agens -t -c "alter user "\"$username"\" password '$passwd'"

# create graph
echo 
echo "* Create Graph                                "
echo "----------------------------------------------"
echo
echo "Please enter the graph_path, or press [Enter] to accept the default (agens_graph)."
echo -n "-> "

read graphpath
	if [ "$graphpath" == "" ]; then
		#agens -U agens -c "create graph agens_graph" 
		agens -c "create graph agens_graph" 
	else
		graphpath="$graphpath"
		#agens -U agens "create graph $graphpath" 
		agens "create graph $graphpath" 
	fi

mkdir -p $AGHOME/log
mv $HOME/AgensGraph-install.log $AGHOME/log

echo
echo "AgensGraph Installatiotn Success!"
echo
echo "1) set env (. ~/.bash_profile)"
#echo "2) connect database (agens -U agens)"
echo "2) connect database (agens)"
echo

exit 0
