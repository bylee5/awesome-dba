#!/bin/bash

# 모든/선택 트리거에 대한 트리거 함수를 보인다.


PORT=""
USER=""
TBL="%"
CONSTR=""

usage() {
  echo "Usage: $0 -d <dbname> [-U <user> -p <port> -t <trigger> -s ]"
  echo "dbname REQUIRED"
  echo "-s will show constraints"
  exit 1
}

getver()
{
VER=$(psql -t $PORT $USER $DBNAME <<_QRYVER_
SELECT version();
_QRYVER_

)
}

set_qry_noconstraints() {
QRY="SELECT c.relname as table,
            t.tgname,
            p.proname as function_called,
            -- t.tgisconstraint as is_constraint,
            cn.conname as constraint_nm,
            CASE WHEN t.rgconstrrelid > 0
                  THEN (SELECT relname
                        FROM pg_class
                        WHERE oid = t.tgconstrrelid)
                  ELSE ''
            END as constr_tbl
      FROM pg_trigger t
      INNER JOIN pg_proc p ON (p.oid = t.tgfoid)
      INNER JOIN pg_class c ON (c.oid = t.tgrelid)
      LEFT JOIN pg_constraint cn ON (cn.oid = t.tgconstraint)
      WHERE tgname NOT LIKE 'pg_%'
        AND tgname NOT LIKE 'RI_%' -- < comment out to see constraints
        AND tgname LIKE '%$TRG%'
      ORDER BY 1;"
}

set_qry_constraints() {
QRY="SELECT c.relname as table,
            t.tgname,
            p.proname as function_called,
            -- t.tgisconstraint as is_constraint,
            cn.conname as constraint_nm,
            CASE WHEN t.tgconstrrelid > 0
                  THEN (SELECT relname
                        FROM pg_class
                        WHERE oid = t.tgconstrrelid)
                  ELSE ''
            END as constr_tbl
      FROM pg_trigger t
      INNER JOIN pg_proc p ON (p.oid = t.tgfoid)
      INNER JOIN pg_class c ON (c.oid = t.tgrelid)
      LEFT JOIN pg_constraint cn ON (cn.oid = t.tgconstraint)
      WHERE tgname NOT LIKE 'pg_%'
        AND tgname LIKE '%$TRG%'
      ORDER BY 1;"
}

list_triggers() {
LIST=$(psql -q $PORT $USER $DBNAME <<_QUERY_

$QRY

_QUERY_

)
}

while getopts "d:p:st:uU:" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
        ;;
      p) PORT="-p $OPTARG"
        ;;
      s) CONSTR="TRUE"
        ;;
      t) TRG="$OPTARG"
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

getver
VER=$(echo $VER | cut -c -16)
echo "Version is $VER"

if [ "$CONSTR" = "TRUE" ]
  then
    set_qry_constraints
  else
    set_qry_noconstraints
fi

list_triggers
echo "${LIST}"

exit 0
