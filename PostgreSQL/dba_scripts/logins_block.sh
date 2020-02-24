#!/bin/bash

DBNAME="postgres"
USER="-U postgres"
PORT="-p 5432"

usage() {
  echo "Usage: $0 [-d <dbname> -U <user> -p <port>]"
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

lockout()
{
CNT=$(psql $PORT $USER $DBNAME <<_QUERY_

DROP TABLE IF EXISTS pg_lockout;
CREATE TABLE pg_lockout
AS SELECT rolname,
          rolsuper,
          rolcanlogin
    FROM pg_authid
    WHERE rolsuper IS FALSE;

ALTER TABLE pg_lockout
ADD CONSTRAINT pg_lockout_pkey PRIMARY KEY (rolname);

UPDATE pg_authid au
SET rolcanlogin = FALSE
FROM pg_lockout lo
WHERE lo.rolcanlogin = TRUE
AND au.rolname = lo.rolname;

_QUERY_

)
}

current_user()
{
CUSER=$(psql -t $PORT $USER $DBNAME <<_QUERY_

SELECT TRIM(BOTH FROM current_user);

_QUERY_

)
}