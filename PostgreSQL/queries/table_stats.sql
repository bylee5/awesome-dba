SELECT n.nspname,
       c.relname,
       pg_stat_get_last_vacuum_time(c.oid) AS last_vacuum,
       pg_stat_get_tuples_inserted(c.oid) AS inserted,
       pg_stat_get_tuples_updated(c.oid) AS updated,
       pg_stat_get_tuples_deleted(c.oid) AS deleted
FROM pg_class c
JOIN pg_namespace n ON (n.oid = c.relnamespace)
WHERE nspname NOT IN ('information_schema', 'pg_toast', 'pg_catalog')
ORDER BY 1, 2;