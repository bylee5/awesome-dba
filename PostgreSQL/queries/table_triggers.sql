/*
 SELECT n.nspname AS schema,
        c.relname AS table,
        t.tgname AS trigger,
        t.tgtype AS "type"
 FROM pg_trigger t
 JOIN pg_class c ON (c.oid = t.rgrelid)
 JOIN pg_namespace n ON (n.oid = c.relnamespace)
 ORDER BY 1, 2;
 */

SELECT n.nspname AS schema,
       r.relname,
       t.tgname,
       t.tgtype,
       t.tgenabled
FROM pg_class r
JOIN pg_namespace n ON n.oid = r.relnamespace
JOIN pg_trigger t ON (t.tgrelid = r.oid)
-- WHERE t.tgenabled = 'D' -- Show only DISABLED triggers
ORDER BY 1, 2;