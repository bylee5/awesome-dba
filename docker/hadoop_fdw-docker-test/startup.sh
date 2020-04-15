#!/bin/bash

echo "시작"


/usr/sbin/sshd -D &


/opt/hadoop/sbin/start-yarn.sh


/opt/hadoop/sbin/start-all.sh



hadoop fs -mkdir       /tmp
hadoop fs -mkdir -p    /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse



/opt/hive/bin/hiveserver2 &




echo "완료"



