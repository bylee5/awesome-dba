SELECT COUNT(*)
FROM pg_stat_activity;

SELECT usename,
        COUNT(*)
FROM pg_stat_activity
GROUP BY 1
ORDER BY 1;

SELECT datname,
        usename,
        COUNT(*)
FROM pg_stat_activity
GROUP BY 1, 2
ORDER BY 1, 2;

SELECT usename,
        datname,
        COUNT(*)
FROM pg_stat_activity
GROUP BY 1, 2
ORDER BY 1, 2;