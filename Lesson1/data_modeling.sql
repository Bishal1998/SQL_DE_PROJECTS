SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
FROM
    job_postings_fact
LIMIT 10;

SELECT
    *
FROM
    company_dim
LIMIT 10;

SELECT 
    *
FROM
    information_schema.tables;

SELECT 
    table_name
FROM
    information_schema.tables
WHERE
    table_catalog = 'data_jobs';

SELECT
    table_name, column_name, data_type
FROM
    information_schema.columns;

-- Left Join

SELECT
    jpf.job_id,
    cd.name AS company_name,
    jpf.job_title_short
FROM
    job_postings_fact AS jpf
LEFT JOIN
    company_dim AS cd
ON
    jpf.company_id = cd.company_id;

-- Right Join

SELECT
    jpf.job_id,
    cd.name AS company_name,
    jpf.job_title_short
FROM
    job_postings_fact AS jpf
RIGHT JOIN
    company_dim AS cd
ON
    jpf.company_id = cd.company_id;


-- Top 10 companies for posting jobs > 3000, Limit to only US jobs

EXPLAIN ANALYZE
SELECT
    cd.name,
    COUNT(jpf.job_id) AS job_posting
FROM
    job_postings_fact AS jpf
LEFT JOIN
    company_dim AS cd
ON
    jpf.company_id = cd.company_id
WHERE
    jpf.job_country = 'United States'
GROUP BY
    cd.name
HAVING
    job_posting > 3000
ORDER BY
    job_posting DESC
LIMIT 10;
