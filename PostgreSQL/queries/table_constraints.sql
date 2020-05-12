SELECT rel.relname,
       con.conname,
       con.contype,
       con.constr
FROM pg_class rel
JOIN pg_constraint con ON (con.conrelid = rel.oid)
-- WHERE contype = 'f'
ORDER BY relname,
         contype,
         conname;