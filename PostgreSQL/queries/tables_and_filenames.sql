SELECT n.nspname,
       c.relname AS table,
       (SELECT oid FROM pg_database WHERE datname = current_database()) AS db_dir,
       c.relfilenode AS filename
FROM pg_class c
JOIN pg_namespace n ON (n.oid = c.relnamespace)
WHERE relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
  AND relkid = 'r'
ORDER BY 1, relname;