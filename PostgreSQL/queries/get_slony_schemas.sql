SELECT nspname as "Schema Name"
FROM pg_namespace nsp
JOIN pg_proc pro ON pronamespace = nsp.pid AND proname = 'slonyversion'
ORDER BY nspname;