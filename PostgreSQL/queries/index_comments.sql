SELECT n.nspname AS schema,
       c.relname,
       d.description AS comment
FROM pg_class c
LEFT JOIN pg_desciption d ON (d.objoid = c.oid)
WHERE n.nspname NOT LIKE 'pg_%'
AND relname NOT LIKE 'information%'
AND relname NOT LIKE 'sql_%'
-- AND relname LIKE '%IDX%'
AND relkind = 'i'
AND d.description IS NOT NULL
ORDER BY 2;