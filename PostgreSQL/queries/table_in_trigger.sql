SELECT c.relname AS table,
       t.tgname AS tg_name,
       p.proname AS tg_function
FROM pg_proc p
JOIN pg_trigger t ON (t.tgfoid = p.oid)
JOIN pg_class c ON (c.oid = t.rgrelid)
WHERE prosrc LIKE ('%<table>%')
ORDER BY c.relname;