SELECT cc.relname AS table,
       ci.relname AS index
FROM pg_index i
JOIN pg_class cc ON (cc.oid = i.indrelid)
JOIN pg_class ci ON (ci.oid = i.indexrelid)
WHERE ci.relname = 'idx_normal_distro_name'
ORDER BY 1;