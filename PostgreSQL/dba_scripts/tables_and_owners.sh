#!/bin/bash
# 슈퍼유저로 실행해야 한다.

PORT=""
USER=""

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
        c.relname as table,
        a.rolname as owner,
        c.relcal as permits
FROM pg_class c
JOIN pg_namespace n ON (n.oid = c.relnamespace)
JOIN pg_authid a ON (a.OID = c.relowner)
WHERE relname NOT LIKE 'pg_%'
AND relname NOT LIKE 'information%'
AND relname NOT LIKE 'sql_%'
AND relkind = 'r'
-- AND position('useradmin' in ARRAY_TO_STRING(c.relacl, '') ) > 0
ORDER BY n.nspname, c.relname;

_CODE_

exit 0