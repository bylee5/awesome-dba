#!/bin/bash
# PG 서버의 시작 및 런타임시간을 보인다.

DBNAME="postgres"
PORT=""
USER=""

usage() {
  echo "Usage: $0 [-d <dbname> -p <port> -U <user>]"
  exit 1
}

while getopts "d:p:U:u" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
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

getver()
{
VER=$(psql -t $PORT $USER $DBNAME <<_QRYVER_
SELECT version();
_QRYVER_
)
}

getver
VER=$(echo $VER | cut -c -16)
echo "Version is $VER"

show_runtime() {
RUNTIME=$(psql -q $PORT $USER $DBNAME <<_QUERY_
SELECT pg_postmaster_start_time() AS pg_start,
        cirremt_timestamp - pg_postmaster_start_time() AS runtime;
_QUERY_

)
}

show_runtime
echo "${RUNTIME}"

exit 0