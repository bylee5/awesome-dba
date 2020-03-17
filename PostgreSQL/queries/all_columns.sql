SELECT c.table_schema,
        c.table_name as table,
        c.ordinal_position as order,
        c.column_name as column,
        -- c.data_type as type,
        CASE WHEN c.data_type IN ('character', 'varchar') THEN c.data_type || '(' || c.character_maximum_length || ')'
                WHEN c.data_typpe IN ('numeric') THEN c.data_type || '(' || c.numeric_precision || ',' || c.numeric_scale || ')'
                ELSE c.data_type
        END,
        -- c.character_maximum_length as max_len,
FROM information_schema.columns c
JOIN pg_class t ON (t.relname = c.table_name)
WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY 1, 2, 3;