#!/bin/bash

# starting the server
rm -f /etc/ssh/*key
ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
ssh-keygen -q -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key

rm -f ~/.ssh/id_dsa
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub > ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

/usr/sbin/sshd -D &

su agens -c "initdb -D $AGDATA"
su agens -c "ag_ctl -D $AGDATA start" 

for i in 22 5432
do
	echo "Connecting to 0.0.0.0 on port $i"
	while :
	do
		nc -z -w10 0.0.0.0 $i
		if [[ $? -eq 0 ]]; then
			break
		else 
			sleep 1
		fi
	done
	echo "Connection to 0.0.0.0 on port $i succeeded"
done


su agens -c "createdb"
su agens -c "agens -c \"CREATE DATABASE metastore\""
su agens -c "schematool -dbType postgres -initSchema"
su agens -c "hdfs namenode -format"
su agens -c "start-yarn.sh"
su agens -c "start-all.sh"
su agens -c "hive -hiveconf hive.root.logger=DEBUG,console --service metastore > $HIVE_HOME/metastore.log 2>&1 &"
su agens -c "hive -hiveconf hive.root.logger=DEBUG,console --service hiveserver2 > $HIVE_HOME/hiveserver.log 2>&1 &"

# check for PORT
for i in 8030 8040 9000 9083 10000
do
	echo -n "Connecting to 0.0.0.0 on port $i"
	while :
	do
		nc -z -w10 0.0.0.0 $i
		if [[ $? -eq 0 ]]; then
			break
		else
			echo -n "." 
			sleep 1
		fi
	done
	echo -e "\nConnection to 0.0.0.0 on port $i succeeded"
done 

su agens -c "hadoop fs -mkdir -p /user/hive/warehouse"
su agens -c "hadoop fs -chmod -R 777 /"

su agens -c "beeline -u 'jdbc:hive2://localhost:10000/default' -n agens -p agens -e 'create table agens_test (id int);insert into agens_test values (1);'"

set -e

su agens -c "agens -c \"CREATE EXTENSION hadoop_fdw\""
su agens -c "agens -c \"CREATE SERVER hadoop_server FOREIGN DATA WRAPPER hadoop_fdw OPTIONS (HOST 'localhost', PORT '10000')\""
su agens -c "agens -c \"CREATE USER MAPPING FOR PUBLIC SERVER hadoop_server OPTIONS (username 'agens', password 'agens')\""
su agens -c "agens -c \"CREATE FOREIGN TABLE test (id int) SERVER hadoop_server OPTIONS (TABLE 'agens_test')\""
su agens -c "agens -c \"SELECT * FROM test\""

exec "$@"
