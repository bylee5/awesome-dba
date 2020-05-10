-- Returns all columns for a apecified table
SELECT c.relname AS table,
       a.attname AS column
FROM pg_class c
JOIN pg_attribute a ON (a.attrelid = c.oid)
WHERE relname = '<table>'
  AND attnum > 0
  AND NOT attisdropped
ORDER BY attnum;