SELECT n.nspname AS schema,
       c.relname AS table,
       a.rolname AS owner,
       c.relacl AS permits
FROM pg_class c
JOIN pg_namespace n ON (n.oid = c.relnamespace)
JOIN pg_authid a ON (a.IOD = c.relowner)
WHERE relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
  -- AND position('cp' in ARRAY_TO_STRING(c.relacl, '')) > 0
ORDER BY n.nspname,
         c.relname;