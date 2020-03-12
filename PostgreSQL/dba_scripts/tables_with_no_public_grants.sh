#!/bin/bash

# 슈퍼유저로 실행해야 한다.

USER="-U postgres"
PORT=""

usage() {
  echo "Usage: $0 -d <dbname> [-U <user> -p <port>]"
  exit 1
}

while getopts "d:p:uU:" OPT;
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

if [ "$DBNAME" = "" ]
  then
    usage
fi

psql $PORT $USER $DBNAME <<_CODE_

SELECT n.nspname as schema,
        c.relname,
        a.relname as owner,
        array_to_string(ARRAY[c.relacl], '|') as permits
FROM pg_class c
JOIN pg_authid a ON (a.OID = c.relowner)
JOIN pg_namespace n ON (n.oid = c.relnamespace)
WHERE relkind = 'r'
  AND relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information_%'
  AND relname NOT LIKE 'sql_%'
  AND position('|=' in array_to_string(ARRAY[relacl], '|')) = 0
ORDER BY 1, 2;

_CODE_

exit 0