SELECT s.nspname,
       c.relname AS table,
       c.reltuples::int4 AS rows
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace s ON (c.relnamespace = s.oid)
WHERE relkind = 'r'
  AND c.reltuples::int4 > 0
ORDER BY reow DESC;