#!/bin/bash

# 슈퍼유저로 실행해야 한다.

USER=""
PORT=""

usage() {
  echo "Usage: $0 -d <dbname> -a <user2check> [-U <user> -p <port>]"
  exit 1
}

while getopts "d:a:p:uU:" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
        ;;
      a) CKUSER=$OPTARG
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
    DBNAME="enf"
fi

if [ "$CKUSER" = "" ]
  then
    usage
    exit 1
fi

psql $USER $PORT $DBNAME <<_CODE_
SELECT n.nspname,
        c.relname,
        CASE WHEN has_table_privilege('$CKUSER', quote_ident(n.nspname) || '.' || quote_ident(c.relname), 'SELECT')
              THEN 'YES'
              ELSE 'no'
        END as "SEL",
        CASE WHEN has_table_privilege('$CKUSER', quote_ident(n.nspname) || '.' || quote_ident(c.relname), 'INSERT')
              THEN 'YES'
              ELSE 'no'
        END as "INS",
        CASE WHEN has_table_privilege('$CKUSER', quote_ident(n.nspname) || '.' || quote_ident(c.relname), 'UPDATE')
              THEN 'YES'
              ELSE 'no'
        END as "UPD",
        CASE WHEN has_table_privilege('$CKUSER', quote_ident(n.nspname) || '.' || quote_ident(c.relname), 'DELETE')
              THEN 'YES'
              ELSE 'no'
        END as "DEL",
        array_to_string(ARRAY[c.relacl], '|') as permits
FROM pg_class c
JOIN pg_namespace n ON (n.oid = c.relnamespace)
WHERE n.nspname NOT LIKE 'pg_%'
  AND n.nspname NOT LIKE 'inform_%'
  AND relkind = 'r'
  /*
  AND (position('$CKUSER' in array_to_string(ARRAY[relacl], '|')) > 0
  OR position((SELECT g.rolname
                FROM pg_auth_members r
                JOIN pg_authid g ON (r.roleid = g.oid)
                JOIN pg_authid u ON (r.member = u.oid)
                AND u.rolname LIKE '$CKUSER%') in array_to_string(ARRAY[relacl], '|')) > 0 )
  */
ORDER BY 1, 2;

_CODE_

exit 0