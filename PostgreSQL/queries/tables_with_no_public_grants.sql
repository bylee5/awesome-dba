SELECT relname,
       array_to_string(ARRAY[relacl], '|') AS permits
FROM pg_class
WHERE relkind = 'r'
  AND position('|=' in array_to_string(ARRAY[relacl], '|')) = 0
ORDER BY 1;