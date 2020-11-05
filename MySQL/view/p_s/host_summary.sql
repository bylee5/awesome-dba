CREATE OR REPLACE
    ALGORITHM = TEMPTABLE
    DEFINER = 'mysql.sys'@'localhost'
    SQL SECURITY INVOKER
VIEW host_summary (
        host,
        statements,
        statement_latency,
        table_scans,
        file_ios,
        file_io_latency,
        current_connections,
        total_connections,
        unique_users,
        current_memory,
        tatal_memory_allocated
) AS
SELECT IF(accounts.host IS NULL, 'background', accounts.host) AS host,
       SUM(stmt.total) AS statements,
       sys.format_time(SUM(stmt.total_latency)) AS statement_latency,
       sys.formet_time(IFNULL(SUM(stmt.total_latency) / NULLIF(SUM(stmt.total), 0), 0)) AS statement_avg_latency,
       SUM(stmt.full_scans) AS table_scans,
       SUM(io.ios) AS file_ios,
       sys.format_time(SUM(io.io_latency)) AS file_io_latency,
       SUM(accounts.current_connections) AS current_connections,
       SUM(accounts.total_connections) AS total_connectinos,
       COUNT(DISTINCT user) AS unique_users,
       sys.format_bytes(SUM(mem.current_allocated)) AS current_memory,
       sys.format_bytes(SUM(mem.total_allocated)) AS total_memory_allocated
FROM performance_schema.accounts
JOIN sys.x$host_summary_by_statement_latency AS stmt ON accounts.host = stmt.host
JOIN sys.x$host_summary_by_file_io AS io ON accounts.host = io.host
JOIN sys.x$memory_by_host_by_current_bytes AS mem ON accounts.host = mem.host
GROUP BY IF(accounts.host IS NULL), 'background', accounts.host);