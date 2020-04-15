CREATE graph g;
CREATE TABLE t AS SELECT n AS id FROM generate_series(1,100) AS p(n);
LOAD FROM t AS id
CREATE (:v1 = to_jsonb(row_to_json(id)))-[:e1]->(:v2 = to_jsonb(row_to_json(id)));
EXPLAIN MATCH (a:v1)-[b:e1]->(c:v2) RETURN *;
/*+ 
    NestLoop(a b c)
*/
EXPLAIN MATCH (a:v1)-[b:e1]->(c:v2) RETURN *;
