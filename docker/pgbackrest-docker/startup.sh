#!/bin/bash

# AgensGraph
ag_ctl -D $PBHOME_MASTER_AGDATA start
ag_ctl -D $PBHOME_2_07_AGDATA start
ag_ctl -D $PBHOME_2_05_AGDATA start
ag_ctl -D $PBHOME_1_29_AGDATA start


for i in 5432 5433 5434 5435
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
createdb -p 5432 agens
agens -p 5432 -c "create graph pb;set graph_path to pb; create (:v{id:1})-[:rel]->(:v{id:2})"

# pgbackrest master
/home/agens/pgbackrest_master/pgbackrest --config=/home/agens/pgbackrest_master/pgbackrest.conf --stanza=agens --log-level-console=info stanza-create

/home/agens/pgbackrest_master/pgbackrest --config=/home/agens/pgbackrest_master/pgbackrest.conf --stanza=agens --log-level-console=info backup

ag_ctl -D $PBHOME_MASTER_AGDATA stop

rm -rf $PBHOME_MASTER_AGDATA/*

/home/agens/pgbackrest_master/pgbackrest --config=/home/agens/pgbackrest_master/pgbackrest.conf --stanza=agens --log-level-console=info restore

ag_ctl -D $PBHOME_MASTER_AGDATA start

if [ 2 -eq $(agens -p 5432 -c "set graph_path to pb; match (n) return count(n)" | head -n3 | tail -n1 | grep -o '[0-9]') ]; then
	echo "master succeeded"
else
	echo "master failed"
	exit 1
fi

#create agens database
createdb -p 5435 agens
agens -p 5435 -c "create graph pb;set graph_path to pb; create (:v{id:1})-[:rel]->(:v{id:2})"

# pgbackrest v2.07
/home/agens/pgbackrest_2_07/pgbackrest --config=/home/agens/pgbackrest_2_07/pgbackrest.conf --stanza=agens_2_07 --log-level-console=info stanza-create

/home/agens/pgbackrest_2_07/pgbackrest --config=/home/agens/pgbackrest_2_07/pgbackrest.conf --stanza=agens_2_07 --log-level-console=info backup

ag_ctl -D $PBHOME_2_07_AGDATA stop

rm -rf $PBHOME_2_07_AGDATA/*

/home/agens/pgbackrest_2_07/pgbackrest --config=/home/agens/pgbackrest_2_07/pgbackrest.conf --stanza=agens_2_07 --log-level-console=info restore

ag_ctl -D $PBHOME_2_07_AGDATA start

if [ 2 -eq $(agens -p 5435 -c "set graph_path to pb; match (n) return count(n)" | head -n3 | tail -n1 | grep -o '[0-9]') ]; then
	echo "v2.07 succeeded"
else
	echo "v2.07 failed"
	exit 1
fi

#create agens database
createdb -p 5433 agens
agens -p 5433 -c "create graph pb;set graph_path to pb; create (:v{id:1})-[:rel]->(:v{id:2})"

# pgbackrest v2.05
/home/agens/pgbackrest_2_05/pgbackrest --config=/home/agens/pgbackrest_2_05/pgbackrest.conf --stanza=agens_2_05 --log-level-console=info stanza-create

/home/agens/pgbackrest_2_05/pgbackrest --config=/home/agens/pgbackrest_2_05/pgbackrest.conf --stanza=agens_2_05 --log-level-console=info backup

ag_ctl -D $PBHOME_2_05_AGDATA stop

rm -rf $PBHOME_2_05_AGDATA/*

/home/agens/pgbackrest_2_05/pgbackrest --config=/home/agens/pgbackrest_2_05/pgbackrest.conf --stanza=agens_2_05 --log-level-console=info restore

ag_ctl -D $PBHOME_2_05_AGDATA start

if [ 2 -eq $(agens -p 5433 -c "set graph_path to pb; match (n) return count(n)" | head -n3 | tail -n1 | grep -o '[0-9]') ]; then
	echo "v2.05 succeeded"
else
	echo "v2.05 failed"
	exit 1
fi

#create agens database
createdb -p 5434 agens
agens -p 5434 -c "create graph pb;set graph_path to pb; create (:v{id:1})-[:rel]->(:v{id:2})"

# pgbackrest v1.29
$PBHOME_1_29/bin/pgbackrest --config=/home/agens/pgbackrest_1_29/pgbackrest.conf --stanza=agens_1_29 --log-level-console=info stanza-create

$PBHOME_1_29/bin/pgbackrest --config=/home/agens/pgbackrest_1_29/pgbackrest.conf --stanza=agens_1_29 --log-level-console=info backup

ag_ctl -D $PBHOME_1_29_AGDATA stop

rm -rf $PBHOME_1_29_AGDATA/*

$PBHOME_1_29/bin/pgbackrest --config=/home/agens/pgbackrest_1_29/pgbackrest.conf --stanza=agens_1_29 --log-level-console=info restore

ag_ctl -D $PBHOME_1_29_AGDATA start

if [ 2 -eq $(agens -p 5434 -c "set graph_path to pb; match (n) return count(n)" | head -n3 | tail -n1 | grep -o '[0-9]') ]; then
	echo "v1.29 succeeded"
else
	echo "v1.29 failed"
	exit 1
fi

exec "$@"
