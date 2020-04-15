#!/bin/bash -f

rev=1.1

echo
echo "==========================================="
echo " * Setup AgensBrowser (v$rev)                "
echo "==========================================="
echo

. ~/.bash_profile

instdir=$HOME/AgensBrowser

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

echo -ne 'AgensBrowser Installation..\r'
sleep 1
echo -ne 'AgensBrowser Installation....\r'
sleep 1
echo -ne 'AgensBrowser Installation.......\r'
echo

# CREATE DIRECTORY & UNZIP FILE
_check_idir

abhome=$instdir
cp ./agens-browser-web-1.1.zip $abhome
cd $abhome
unzip -q -n agens-browser-web-1.1.zip
rm agens-browser-web-1.1.zip

# select AgensGraph connect info
## AGPORT
agport="$PGPORT"

## DBNAME
dbname=`agens -U agens -t -o dbinfo.txt << EOF
SELECT current_database();
EOF` 

dbname2=`cat dbinfo.txt | tr -d ' \t\r'`

## GRAPHPATH
graphpath=`agens -U agens -t << EOF
select graphname from ag_graph; 
EOF`

## DB_USER & PASSWORD
dbuser=`agens -U agens -t << EOF
select usename from pg_shadow; 
EOF`

dbpasswd=`agens -U agens -t << EOF
select passwd from pg_shadow;
EOF`


# Modified AgensBrowser config file

sed -i "s/AGPORT/$agport/g" agens-browser.config.yml
sed -i "s/DBNAME/$dbname2/g" agens-browser.config.yml
sed -i "s/GRPAHPATH/$graphpath/g" agens-browser.config.yml
sed -i "s/UNAME/$dbuser/g" agens-browser.config.yml
sed -i "s/UPASS/$dbpasswd/g" agens-browser.config.yml

sleep 2

# Start AgensBrowser

nohup java -jar agens-browser-web-1.1.jar --spring.config.name=agens-browser.config 1>agbrowser.log 2>&1 &

sleep 3

echo
echo "AgensBrowser Installatiotn Success!"
echo

sleep 2

echo To connect to AgensBrowser, type this URL in the address bar of your web browser.
echo 
echo http://DB_SERVER_IP_ADDRESS:WEB_SERVER_PORT/index.html
echo 

exit 0
