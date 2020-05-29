SELECT c.table_schema AS schema,
       c.table_name AS table,
       c.column_name AS column,
       c.data_type AS type,
       CASE WHEN c.data_type LIKE '%char%'
            THEN COALESCE(character_maximum_length::text, 'N/A')
            WHEN c.data_type LIKE '%numeric%'
            THEN '(' || c.numeric_precision::text || ', ' || c.numeric_scale::text || ')'
            WHEN c.data_type LIKE '%int%'
            THEN c.numeric_precision::text
        ELSE COALESCE(character_maximum_length::text, 'N/A')
        END AS size
FROM information_schema.columns c
WHERE c.table_schema NOT LIKE 'pg_%'
  AND c.table_schema NOT LIKE 'information%'
  AND c.table_name NOT LIKE 'sql_%'
  AND c.is_updatable = 'YES'
  AND c.column_name LIKE '%<COLUMN_NAME>%'
ORDER BY c.table_name,
         c.column_name;