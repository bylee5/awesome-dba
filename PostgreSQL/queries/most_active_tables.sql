SELECT schemaname,
       relname,
       idx_tup_fetch + seq_tup_read AS TotalReads
FROM pg_stat_all_tables
WHERE idx_tup_fetch + seq_tup_read != 0
AND schemaname NOT IN ('pg_catalog', 'pg_toast')
ORDER BY TotalReads desc
LIMIT 10;