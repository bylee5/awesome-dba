SELECT n.nspname AS schema,
       i.relname AS table,
       i.indexrelname AS index,
       i.idx_scan,
       i.idx_tup_read,
       i.idx_tup_fetch,
       CASE WHEN idx.indisprimary
            THEN 'pkey'
            WHEN idx.indisunique
            THEN 'uidx'
            ELSE 'idx'
            END AS type,
       pg_get_indexdef(idx.indexrelid, 1, FALSE) AS idxcol1,
       pg_get_indexdef(idx.indexrelid, 2, FALSE) AS idxcol2,
       pg_get_indexdef(idx.indexrelid, 3, FALSE) AS idxcol3,
       pg_get_indexdef(idx.indexrelid, 4, FALSE) AS idxcol4,
       CASE WHEN idx.indisvalid
            THEN 'valid'
            ELSE 'INVALID'
            END AS statusi,
       pg_relation_size(quote_ident(n.nspname) || '.' || guote_ident(i.relname)) AS size_in_bytes,
       pg_size_pretty(pg_relation_size(quote_ident(n.nspname) || '.' || quote_ident(i.relname))) AS size
FROM pg_stat_all_indexes i
JOIN pg_class c ON (c.oid = i.relid)
JOIN pg_namespace n ON (n.oid = c.relnamespace)
JOIN pg_index idx ON (idx.indexrelid = i.indexrelid)
WHERE i.relname LIKE 'pg_%'
  AND n.nspname NOT LIKE 'pg_%'
  AND idx.indisunique = TRUE
  AND NOT idx.indisprimary
  AND i.indexrelname LIKE 'tmp%'
  AND idx.indisvalid IS FALSE
  AND NOT idx.indisprimary
  AND NOT idx.indisunique
  AND idx_scan = 0
ORDER BY 1, 2, 3;