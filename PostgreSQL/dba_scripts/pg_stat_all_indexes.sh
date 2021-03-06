#!/bin/bash
# 모든 선택된 테이블의 모든 인덱스에 대한 통계정보를 보인다.

PORT=""
USER=""
TBL="%"
COLS=""

usage() {
  echo "Usage: $0 -d <dbname> [-U <user> -p <port> -t <table> -s ]"
  echo "dbname REQUIRED"
  echo "-s will show columns used in index"
  exit 1
}

getver()
{
VER=$(psql -t $PORT $USER $DBNAME <<_QRYVER_
SELECT version();
_QRYVER_

)
}

set_qry_cols() {
QRY="SELECT n.nspname as schema,
            i.relname as table,
            i.indexrelname as index,
            i.idx_scan,
            i.idx_tup_read,
            i.idx_tup_fetch,
            CASE WHEN idx.indisprimary
                 THEN 'pkey'
                 WHEN idx.indisunique
                 THEN 'uidx'
                 ELSE 'idx'
                 END AS type,
            pg_get_indexdef(idx.indexrelid, 1, FALSE) as idxcol1,
            pg_get_indexdef(idx.indexrelid, 2, FALSE) as idxcol2,
            pg_get_indexdef(idx.indexrelid, 3, FALSE) as idxcol3,
            pg_get_indexdef(idx.indexrelid, 4, FALSE) as idxcol4,
            CASE WHEN idx.indisvalid
                 THEN 'valid'
                 ELSE 'INVALID'
                 END as status,
            pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(i.relname)) as size_in_bytes,
            pg_size_pretty(pg_relation_size(quote_ident(n.nspname)|| '.' || quote_ident(i.relname) )) as size_in_bytes
    FROM pg_stat_all_indexes i
    JOIN pg_class c ON (c.oid = i.relid)
    JOIN pg_namespace n ON (n.oid = c.relnamespace)
    JOIN pg_index idx ON (idx.indexrelid = i.indexrelid)
    WHERE i.relname LIKE '%$TBL%'
    AND n.nspname NOT LIKE 'pg_%'
    ORDER BY 1, 2, 3, 4;"
}

set_qry_nocols() {
QRY="SELECT n.nspname as schema,
            i.relname as table,
            i.indexrelname as index,
            i.idx_scan,
            i.idx_tup_read,
            i.idx_tup_fetch,
            CASE WHEN idx.indisprimary
                 THEN 'pkey'
                 WHEN idx.indisunique
                 THEN 'uidx'
                 ELSE 'idx'
                 END as type,
            CASE WHEN idx.indisvalid
                 THEN 'valid'
                 ELSE 'INVALID'
                 END as status,
            pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(i.relname)) as size_in_bytes
    FROM pg_stat_all_indexes i
    JOIN pg_class c ON (c.oid = i.relid)
    JOIN pg_namespace n ON (n.oid = c.relnamespace)
    JOIN pg_index idx ON (idx.indexrelid = i.indexrelid)
    WHERE i.relname LIKE '%$TBL%'
    AND n.nspname NOT LIKE 'pg_%'
    ORDER BY 1, 2, 3;"

}

cuurent_stats() {
STATLIST=$(psql -q -U postgres $DBNAME <<_QUERY_

$ORY

_QUERY_

)
}

while getopts "d:p:st:uU:" OPT;
do case "${OPT}" in
      d) DBNAME=$OPTARG
        ;;
      p) PORT="-p $OPTARG"
        ;;
      s) COLS="TRUE"
        ;;
      t) TBL="$OPTARG"
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

if [ "$COLS" = "TRUE" ]
  then
      set_qry_cols
  else
      set_qry_nocols
fi

current_stats
echo "${STATLIST}"

exit 0