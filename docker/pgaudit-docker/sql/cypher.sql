DROP database IF EXISTS pgaudit;
CREATE database pgaudit;
\c pgaudit;
\set VERBOSITY terse
-- Create pgaudit extension
CREATE EXTENSION IF NOT EXISTS pgaudit;
-- Make sure events don't get logged twice when session logging
SET pgaudit.log = 'all';
SET pgaudit.log_client = ON;
SET pgaudit.log_level = 'notice';
--
-- Cypher Query Language - DDL
--
-- setup
CREATE ROLE graph_role_0 SUPERUSER;
SET ROLE graph_role_0;
--
-- CREATE GRAPH
--
CREATE GRAPH IF NOT EXISTS graph_0;
SET graph_path TO graph_0;
SHOW graph_path;
--
-- ALTER GRAPH
--
CREATE ROLE temp;
ALTER GRAPH graph_0 RENAME TO graph_00;
--
-- CREATE label
--
CREATE VLABEL v0;
CREATE VLABEL v00 INHERITS (v0);
CREATE ELABEL e0;
CREATE ELABEL e01 INHERITS (e0);
-- CREATE UNLOGGED
CREATE UNLOGGED VLABEL unlog;
-- WITH
CREATE VLABEL stor
WITH (fillfactor=90, autovacuum_enabled, autovacuum_vacuum_threshold=100);
-- TABLESPACE
CREATE VLABEL tblspc TABLESPACE pg_default;
-- DISABLE INDEX
CREATE VLABEL vdi DISABLE INDEX;
-- REINDEX
REINDEX VLABEL vdi;
--
-- COMMENT and \dG commands
--
COMMENT ON GRAPH graph_00 IS 'a graph for regression tests';
COMMENT ON VLABEL v0 IS 'multiple inheritance test';
--
-- ALTER LABEL
--
ALTER VLABEL v0 SET STORAGE external;
ALTER VLABEL v0 RENAME TO vv;
-- IF EXISTS
ALTER VLABEL IF EXISTS vv SET LOGGED;
--
-- DROP LABEL
--
-- drop all
DROP VLABEL vv CASCADE;
DROP ELABEL e0 CASCADE;
--
-- CONSTRAINT
--
-- simple unique constraint
CREATE VLABEL regv1;
CREATE CONSTRAINT ON regv1 ASSERT a.b IS UNIQUE;
--
-- DROP GRAPH
--
DROP GRAPH graph_00 CASCADE;
DROP ROLE temp;
DROP ROLE graph_role_0;
--
-- Cypher Query Language - DML
--
-- prepare
CREATE TABLE history (year, event) AS VALUES
(1996, 'PostgreSQL'),
(2016, 'Graph');
CREATE GRAPH agens;
--
-- RETURN
--
RETURN 3 + 4, 'hello' + ' agens';
RETURN (SELECT event FROM history WHERE year = 2016);
SELECT * FROM (RETURN 3 + 4, 'hello' + ' agens') AS _(lucky, greeting);
--
-- MATCH
--
CREATE (:vl1 {id:1});
MATCH (A:vl1) RETURN A;
OPTIONAL MATCH (A:vl1) RETURN A;
MATCH (A:vl1) DETACH DELETE A;
-- Variable Length Relationship
CREATE (:time {sec: 1})-[:goes]->(:time {sec: 2})-[:goes]->(:time {sec: 3})-[:goes]->(:time {sec: 4})-[:goes]->(:time {sec: 5});
MATCH (a:time)-[x:goes*3]->(b:time) RETURN a.sec AS a, length(x) AS x, b.sec AS b ORDER BY a;
--
-- DISTINCT
--
MATCH (a:time)-[]-() RETURN DISTINCT a.sec AS a ORDER BY a;
--
-- SKIP and LIMIT
--
MATCH (a:time) RETURN a.sec AS a ORDER BY a SKIP 1 LIMIT 1;
--
-- UNION
--
MATCH (a) RETURN a UNION MATCH (b) RETURN *;
--
-- aggregates
--
MATCH (a) RETURN count(a);
--
-- EXISTS
--
MATCH (a) WHERE exists((a)-[]->()) RETURN a.sec AS a;
--
-- MERGE
--
MERGE (a);
--
-- Cypher Query Language - User Defined Function
--
-- setup
CREATE (:v {id: 1, refs: [2, 3, 4]}), (:v {id: 2});
-- CREATE FUNCTION
CREATE FUNCTION udf_var(id jsonb) RETURNS jsonb AS $$
DECLARE
  i jsonb;
  p jsonb;
BEGIN
  i := id;
  MATCH (n:v) WHERE n.id = i RETURN properties(n) INTO p;
  RETURN p;
END;
$$ LANGUAGE plpgsql;
-- CALL FUNCTION
RETURN udf_var(2);
-- DROP FUNCTION
DROP FUNCTION udf_var(jsonb);
--
-- Cypher Query Language - Shortestpath
--
MATCH shortestpath((p)-[:goes]->(f)) RETURN *;
--
-- DROP
--
DROP GRAPH agens CASCADE;
DROP TABLE history;