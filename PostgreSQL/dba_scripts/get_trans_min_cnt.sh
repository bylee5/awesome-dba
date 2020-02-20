#!/bin/bash
# postgresql 서버의 분당 트랜잭션 수를 출력
# 트랜잭션은 actual되는 것이고 potential은 아니다.

PORT=""
USER=""
DBNAME="postgres"

usage() {
  echo "Usage: $0 [-d <dbname> -p <port> -U <user>]"
  exit 1
}

while getopts "d:p:U:u" OPT;
do case "${OPT}" in
      d) DBNAME="$OPTARG"
        ;;
      p) PORT="-p $OPTARG"
        ;;
      U) USER="-U $OPTARG"
        ;;
      u) usage
        ;;
      [?]) usage
  esac;
done

get_procnum() {
PROCNUM=$(psql $PORT -q -t $USER $DBNAME <<_QUERY_
SELECT SUM(xact_commit + xact_rollback)
FROM pg_stat_database;

_QUERY_

)
}

get_procnum
echo "$PROCNUM"
FIRST_CNT=$PROCNUM
sleep 60
get_procnum
LAST_CNT=$PROCNUM
echo "$PROCNUM"
(( TOT_QRY = $LAST_CNT - $FIRST_CNT ))
echo "Total queries = $TOT_QRY"