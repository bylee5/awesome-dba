SELECT n.nspname AS schema,
       c.relname AS table
FROM pg_class c
JOIN pg_namespace n ON (n.oid = c.relnamespace)
WHERE relkind = 'r'
  AND relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'sql_%'
  AND relhaspkey = FALSE
ORDER BY n.nspname,
         c.relname;