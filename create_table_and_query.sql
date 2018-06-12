SELECT subquery.rank, string_agg(subquery.DO_date_creator, '') AS DO_date_creator,
string_agg(subquery.unDO_date_creator, '') AS unDO_date_creator
FROM
(SELECT *, (rank() over (order by DO_created asc)+1)/2 as rank,
CASE WHEN status = 'DO' THEN to_char(DO_created, 'DD-MM-YYYY') || ',' || DO_creator::text END AS DO_date_creator,
CASE WHEN status = 'UNDO' THEN to_char(DO_created, 'DD-MM-YYYY') || ',' || DO_creator::text END AS unDO_date_creator
FROM tbl
ORDER BY DO_created) AS subquery
GROUP BY subquery.rank

CREATE TABLE tbl (
  agreement_id bigint,
  DO_created timestamp without time zone NOT NULL,
  DO_creator VARCHAR(255) NOT NULL,
  status VARCHAR(255) NOT NULL
);

INSERT INTO tbl
    (agreement_id, DO_created, DO_creator, status)
VALUES 
    (3, '2018-06-22 16:09:13.025', 'NAME', 'DO'),
    (3, '2018-06-22 16:31:57.025', 'NAME', 'UNDO'),
    (3, '2018-07-24 16:09:13.025', 'NAME', 'DO'),
    (3, '2018-07-25 16:09:13.025', 'NAME', 'UNDO');