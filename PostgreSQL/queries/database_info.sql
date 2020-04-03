SELECT db.datname,
        au.relname as datdba,
        pg_encoding_to_char(db.encoding) as encoding,
        db.datallowconn,
        db.datconnlimit,
        db.datfrozenzid,
        tb.spcname as tblspc,
        -- db.datconfig,
        db.datacl
FROM pg_database db
JOIN pg_authid au ON (au.oid = db.datdba)
JOIN pg_tablespace tb ON (tb.oid = db.dattablespace)
ORDER BY 1;