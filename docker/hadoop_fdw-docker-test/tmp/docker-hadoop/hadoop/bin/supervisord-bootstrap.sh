#!/bin/bash

rm /tmp/*.pid 2> /dev/null

rm -f /etc/ssh/*key
ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
ssh-keygen -q -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key

/opt/hadoop/bin/create-ssh-keys.sh

wait-for-it.sh zookeeper:2181 -t 120
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n--------------------------------------------"
    echo -e "      Zookeeper not ready! Exiting..."
    echo -e "--------------------------------------------"
    exit $rc
fi

supervisorctl start sshd

wait-for-it.sh localhost:22 -t 60
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n--------------------------------------------"
    echo -e "       SSH not ready! Exiting..."
    echo -e "--------------------------------------------"
    exit $rc
fi

supervisorctl start hdfs
supervisorctl start yarn

wait-for-it.sh localhost:8088 -t 60
rc=$?
if [ $rc -ne 0 ]; then
    echo -e "\n--------------------------------------------"
    echo -e "YARN Resource Manager not ready! Exiting..."
    echo -e "--------------------------------------------"
    exit $rc
fi

supervisorctl start timelineserver
supervisorctl start historyserver

hdfs dfs -chown hdfs:supergroup /
hdfs dfs -chmod 777 /
hdfs dfs -mkdir -p /tmp
hdfs dfs -chmod 777 /tmp


echo -e "\n\n--------------------------------------------------------------------------------"
echo -e "You can now access to the following Hadoop Web UIs:"
echo -e ""
echo -e "Hadoop - NameNode:                     http://localhost:9870"
echo -e "Hadoop - DataNode:                     http://localhost:9864"
echo -e "Hadoop - YARN Node Manager:            http://localhost:8042"
echo -e "Hadoop - YARN Resource Manager:        http://localhost:8088"
echo -e "Hadoop - YARN Application History:     http://localhost:8188"
echo -e "Hadoop - MapReduce Job History:        http://localhost:19888/jobhistory"
echo -e "\nMantainer:   Matteo Capitanio <matteo.capitanio@gmail.com>"
echo -e "--------------------------------------------------------------------------------\n\n"
