#!/bin/bash

# 테이블을 보이고, 모든 테이블의 크기를 보인다.
# 슈퍼유저로 실행해야 한다.

HOST=""
PORT=""
USER=""

usage() {
  echo "Usage: $0 -d <dbname> [-h <host> -p <port> -U <user>]"
  exit 1
}

while getopts "d:h:p:U:u" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
        ;;
      p) PORT="-p $OPTARG"
        ;;
      h) HOST="-h $OPTARG"
        ;;
      U) USER="-U $OPTARG"
        ;;
      u) usage
        ;;
      [?]) usage
  esac
done

if [ "$DBNAME" = "" ]
  then
    usage
fi

psql $HOST $PORT $USER $DBNAME <<_CODE_

SELECT d.oid as directory,
        c.relfilenode as filename,
        n.nspname as schema,
        c.relname as table,
        a.rolname as owner,
        pg_size_pretty(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(c.relname))) as size
FROM pg_class c
JOIN pg_namespace n ON (n.oid = c.relnamespace)
JOIN pg_authid a ON (a.oid = c.relowner),
      pg_database d
WHERE d.datname = current_database()
  AND relanme NOT LIKE 'pg_%'
  AND relanme NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
  AND relkind = 'r'
ORDER BY relfilenode;

_CODE_
