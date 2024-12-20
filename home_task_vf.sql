-- 1
CREATE TABLE table_1 (
   id INTEGER PRIMARY KEY,
   site TEXT,
   type TEXT
);

INSERT INTO table_1 (id, site, type)
VALUES
    (1230, 'REC', 'CROOFT'),
    (4560, 'CHP', 'CGREENF'),
    (7890, 'CHN', 'HHH'),
    (1010, 'BU2', 'CGREENF'),
    (1144, 'MOS', NULL),
    (5599, 'MER', 'CGREEN');

--2. Вивести із таблиці Table_1 лише поле "Site" у кого в значеннях поля Type текст містить слово GREEN;
SELECT site
FROM table_1
WHERE table_1.type ILIKE '%GREEN%' ;

--3.
ALTER TABLE table_1
ADD COLUMN month INTEGER;

UPDATE table_1
   SET month = CASE
                 WHEN type ILIKE '%GREEN%' THEN 240
                 ELSE 120
               END
WHERE 1=1;

-- 4.
CREATE TABLE table_2 (
   id INTEGER,
   start_date DATE,
   end_date DATE,
   amount INTEGER
);

INSERT INTO Table_2 (id, start_date, end_date, amount)
VALUES
    (1230, '2021-03-01', '2021-03-31', 100),
    (4560, '2021-03-02', '2021-03-31', 200),
    (1212, '2021-05-01', '2021-05-31', 400),
    (7890, '2021-04-01', '2021-04-30', 300),
    (1010, '2021-04-01', '2021-04-30', 400),
    (1230, '2021-05-01', '2021-05-25', 100),
    (1212, '2021-03-01', '2021-03-31', 400),
    (13131, '2021-03-01', '2021-05-31', 100);

SELECT t2.id, t1.site
    FROM table_2 t2
    LEFT JOIN table_1 t1 ON t1.id = t2.id
WHERE EXTRACT(MONTH FROM t2.start_date) = 3 ;

-- 5.
SELECT t2.id,
       SUM(t2.amount) AS total
    FROM table_2 t2
    LEFT JOIN table_1 t1 ON t1.id = t2.id
GROUP BY t2.id
ORDER BY total DESC
LIMIT 3
;

-- 6.
SELECT *
FROM table_2
WHERE EXTRACT(month FROM start_date ) <> EXTRACT(month FROM end_date ) ;

-- 7.
--ALTER TABLE table_2
--ADD COLUMN days INTEGER GENERATED ALWAYS AS ((end_date - start_date)+1) STORED ;
--ALTER TABLE table_2 DROP COLUMN days ;

ALTER TABLE table_2 ADD COLUMN days INTEGER ;
UPDATE table_2
SET days = (End_date - Start_date) + 1
WHERE 1 = 1;

-- 8.
ALTER TABLE table_2
ADD COLUMN  calculation BIGINT GENERATED ALWAYS AS (
    POWER(amount * days, 2)
) STORED;

--9.
SELECT t2.*,
       EXTRACT(DAY FROM LAST_DAY(t2.start_date::DATE)) AS days_in_month
FROM table_2 t2
WHERE EXTRACT(DAY FROM LAST_DAY(t2.start_date::DATE)) - days > 0 ;

--10.
SELECT
    t2.id,
    MAX(t2.end_date) AS max_end_date,
    SUM(t2.amount) AS total,
    t1.month,
    SUM(t2.amount) - t1.month AS result
FROM table_2 t2
LEFT JOIN table_1 t1 on t1.id = t2.id
GROUP BY t2.id, t1.month
;
