#!/bin/bash
#IP
IP_ADDR=$(hostname -i)
echo "IP_ADDR: $IP_ADDR"

$ETCD_HOME_3_3_9/etcdctl -v
$STOLON_HOME_0_12_0/stolonctl version

$ETCD_HOME_3_3_9/etcd --name=agens-etcd-143 > $HOME/etcd.log 2>&1 &

$STOLON_HOME_0_12_0/stolonctl --cluster-name=agens-stolon-cluster-143 --store-backend=etcdv3 init '{ "initMode": "new", "pgHBA": ["local all all trust", "host all all all trust"]}' --yes

$STOLON_HOME_0_12_0/stolon-sentinel --cluster-name=agens-stolon-cluster-143 --store-backend=etcdv3 > $STOLON_HOME_0_12_0/sentinel.log 2>&1 &

$STOLON_HOME_0_12_0/stolon-keeper --cluster-name=agens-stolon-cluster-143 --store-backend=etcdv3 --uid=agens0 --data-dir=$STOLON_HOME_0_12_0/agens0 --pg-su-password='1234' --pg-repl-username=repl --pg-repl-password='1234' --pg-bin-path=$HOME/agensgraph/bin --pg-port=5532 --pg-listen-address=$IP_ADDR > $STOLON_HOME_0_12_0/keeper1.log 2>&1 &

$STOLON_HOME_0_12_0/stolon-keeper --cluster-name=agens-stolon-cluster-143 --store-backend=etcdv3 --uid=agens1 --data-dir=$STOLON_HOME_0_12_0/agens1 --pg-su-password='1234' --pg-repl-username=repl --pg-repl-password='1234' --pg-bin-path=$HOME/agensgraph/bin --pg-port=5533 --pg-listen-address=$IP_ADDR > $STOLON_HOME_0_12_0/keeper2.log 2>&1 &

$STOLON_HOME_0_12_0/stolon-proxy --cluster-name=agens-stolon-cluster-143 --store-backend=etcdv3 --port=5432 --listen-address=$IP_ADDR > $STOLON_HOME_0_12_0/proxy.log 2>&1 &

echo -n "Starting stolon."
while :
do
	result=$(agens -h $IP_ADDR -p 5432 -U agens -d postgres -c 'select 1' 2>/dev/null | head -n3 | tail -n1 | grep -o '[0-9]')
	if [ "1" = "$result" ]; then
		break
	else
		echo -n "."
		sleep 3
	fi

done
echo -e "\n"

$STOLON_HOME_0_12_0/stolonctl --cluster-name=agens-stolon-cluster-143 --store-backend=etcdv3 status

agens -h $IP_ADDR -p 5432 -d postgres -c 'DROP GRAPH IF EXISTS pb CASCADE;'
agens -h $IP_ADDR -p 5432 -d postgres -c 'CREATE GRAPH pb;'
agens -h $IP_ADDR -p 5432 -d postgres -c 'SET graph_path TO pb; CREATE (:v{id:1})-[:rel]->(:v{id:2});'
if [ 2 -eq $(agens -h $IP_ADDR -p 5432 -d postgres -c 'SET graph_path TO pb; MATCH (n) RETURN count(n);' | head -n3 | tail -n1 | grep -o '[0-9]') ]; then
	echo "stolon v0.12.0 succeeded..."
else
	echo "stolon v0.12.0 failed..."
	exit 1
fi

agens -h $IP_ADDR -p 5432 -d postgres -c 'create extension IF not EXISTS pgagent;'
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: CREATE EXTENSION IF NOT EXISTS pgagent ${NC}"
    echo -e "${RED}Please create pgagent extension ${NC}"
fi

exec "$@"
