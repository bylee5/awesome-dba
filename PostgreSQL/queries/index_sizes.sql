SELECT n.nspname AS schema,
        c.relname AS index,
       a.relname AS owner,
       c.relfilenode AS filename,
       CASE WHEN indisprimary
            THEN 'pkey'
            WHEN indisunique
            THEN 'uidx'
            ELSE 'idx'
        END AS type,
       pg_size_pretty(pg_total_relation_size(n.nspname || '.' || c.relname)) AS total_size,
       pg_total_relation_size(n.nspname || '.' || c.relname) AS total_size_bytes
FROM pg_index i
JOIN pg_class c ON (c.oid = i.indexrelid)
JOIN pg_namespace n ON (n.oid = c.relnamespace)
JOIN pg_authid a ON (a.oid = c.relowner)
WHERE relname NOT LIKE 'pg_%'
AND relname NOT LIKE 'information%'
AND relname NOT LIKE 'sql_%'
AND relkind IN ('i')
ORDER BY 7 DESC, 1, 2;