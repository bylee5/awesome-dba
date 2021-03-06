-- TABLES with_large_index_size
SELECT c.oid, s.nspname,
       c.relname AS table,
       c.reltuples::int4 AS rows,
       c.relpages AS pages,
       pg_size_pretty(pg_relation_size(c.oid)) AS size,
       (SELECT pg_size_pretty(SUM(pg_relation_size(indexrelid))::INT8)
           FROM pg_index
           WHERE indrelid = c.oid) AS index_size,
       pg_size_pretty(pg_total_relation_size(c.oid))
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace s ON (relnamespace = s.oid)
WHERE nspname = 'public'
  AND relkind = 'r'
GROUP BY 1, 2, 3, 4, 5, 6
HAVING pg_relation_size(c.oid) < (SELECT SUM(pg_relation_size(indexrelid))
                                    FROM pg_index
                                    WHERE indrelid = c.oid)
ORDER BY (SELECT SUM(pg_relation_size(indexrelid))::INT8
            FROM pg_index
            WHERE indrelid = c.oid) DESC
;