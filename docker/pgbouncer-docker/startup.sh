#!/bin/bash

# AgensGraph
initdb -D $AGDATA
ag_ctl -D $AGDATA start

# pgbouncer
cd $PBHOME_1_5
$PBHOME_1_5/bin/pgbouncer -d pgbouncer.ini

cd $PBHOME_1_6
$PBHOME_1_6/bin/pgbouncer -d pgbouncer.ini

cd $PBHOME_1_7
$PBHOME_1_7/bin/pgbouncer -d pgbouncer.ini

cd $PBHOME_1_8
$PBHOME_1_8/bin/pgbouncer -d pgbouncer.ini

cd $PBHOME_1_9
$PBHOME_1_9/bin/pgbouncer -d pgbouncer.ini

cd $PBHOME_MASTER
$PBHOME_MASTER/bin/pgbouncer -d pgbouncer.ini

for i in 5432 1234 2345 3456 4567 5678 6789
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

#create agens database
createdb agens

#
for i in 1234 2345 3456 4567 5678 6789
do
	agens -p $i -c 'DROP GRAPH IF EXISTS pb CASCADE;'	
	agens -p $i -c 'CREATE GRAPH pb;'
	agens -p $i -c 'SET graph_path TO pb; CREATE (:v{id:1})-[:rel]->(:v{id:2});'
	if [ 2 -eq $(agens -p $i -c 'SET graph_path TO pb; MATCH (n) RETURN count(n);' | head -n3 | tail -n1 | grep -o '[0-9]') ]; then
		echo "$i succeeded... (1234=v1.5 | 2345=v1.6 | 3456=v1.7 | 4567=v1.8 | 5678=v1.9 6789=master)"
	else 
		echo "$i failed... (1234=v1.5 | 2345=v1.6 | 3456=v1.7 | 4567=v1.8 | 5678=v1.9 6789=master)"
		exit $i
	fi
done

exec "$@"
