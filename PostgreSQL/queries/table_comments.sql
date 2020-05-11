SELECT DISTINCT ON (c.relname)
    n.nspname AS schema,
    c.relname,
    a.rolname AS owner,
    0 AS col_seq,
    '' AS column,
    d.descriptionn AS comment
FROM pg_class c
LEFT JOIN pg_attribute col ON (col.attrelid = c.oid)
LEFT JOIN pg_description d ON (d.objoid = col.attrelid AND d.objsubid = 0)
     JOIN pg_namespace n ON (n.oid = c.relnamespace)
     JOIN pg_authid a ON (a.OID = c.relowner)
WHERE n.nspname NOT LIKE 'information%'
  AND relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
-- AND relname LIKE '<TABLE>'
  AND relkind = 'r'
-- AND d.description IS NOT NULL
UNION
SELECT n.nspname AS schema,
       c.relname,
       '' AS owner,
       col.attnum AS col_seq,
       col.attname AS column,
       d.description
FROM pg_class c
JOIN pg_attribute col ON (col.attrelid = c.oid)
LEFT JOIN pg_description d ON (d.objoid = col.attrelid AND d.objsubid = col.attnum)
JOIN pg_namespace n ON (noid = c.relnamespace)
JOIN pg_authid a ON (a.OID = c.relowner)
WHERE n.nspname NOT LIKE 'information%'
  AND relname NOT LIKE 'pg_%'
  AND relname NOT LIKE 'information%'
  AND relname NOT LIKE 'sql_%'
-- AND relname LIKE '<TABLE>'
  AND relkind = 'r'
-- AND d.description IS NOT NULL
  AND col.attnum >= 0
ORDER BY 1, 2, 4;