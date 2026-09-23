-- Subqueries
-- Query inside a big query

SELECT 
    *
FROM (
    SELECT
    *
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Engineer'
) AS data_engineer_jobs
LIMIT 10;


-- CTEs

WITH data_engineer_jobs AS
(
    SELECT
    *
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Engineer'
)

SELECT 
    *
FROM
    data_engineer_jobs;

SELECT * 
FROM range(3) AS src(key);

SELECT *
FROM range(2) as tgt(key);

SELECT *
FROM range(3) AS src(key)
WHERE NOT EXISTS (
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE src.key = tgt.key
);

SELECT *
FROM job_postings_fact AS tgt
WHERE NOT EXISTS(
    SELECT 1
    FROM skills_job_dim AS src
    WHERE tgt.job_id = src.job_id
)
ORDER BY job_id;


/*
Filtering Remote Jobs via Subquery (1.23.1) - Problem
1.23 Subqueries and CTEs
Problem Statement
Identify jobs that offer remote work options by constructing a query that pulls data from a filtered subquery.

Task

Create a SQL file in the Lesson folder (e.g., 1.23.1.sql).
Construct a subquery that selects job_id, job_title_short, and salary_year_avg from the job_postings_fact table.
Filter the subquery to only include rows where job_work_from_home is TRUE.
In the outer query, select all columns (*) from the result of the subquery.
Hint
Start by writing the inner query first to ensure it returns the correct remote jobs, then wrap it in parentheses for the FROM clause.
*/

SELECT *
FROM (
    SELECT 
    job_id,
    job_title_short,
    salary_year_avg
FROM 
    job_postings_fact
WHERE
    job_work_from_home = TRUE
);

/*
Identify Missing Salary Records (1.23.2) - Problem
1.23 Subqueries and CTEs
Problem Statement
Identify data gaps by finding job postings that lack both yearly and hourly salary information using a CTE. This allows you to isolate records that may require data cleaning or manual updates.

Task

Create a SQL file in the Lesson folder named 1.23.2.sql.
Create a Common Table Expression (CTE) named invalid_salaries.
Inside the CTE, select job_id, job_title_short, job_location columns from the job_postings_fact table.
Filter the results to include only rows where both salary_year_avg and salary_hour_avg are NULL.
Finally, select all columns from the invalid_salaries CTE and output the results.
Hint
Use the IS NULL operator to check for missing values.
Remember to use the AND operator to ensure the row is only selected if both salary fields are empty.
*/

WITH invalid_salaries AS(
    SELECT
        job_id,
        job_title_short,
        job_location
    FROM job_postings_fact
    WHERE
        salary_year_avg IS NULL
        AND salary_hour_avg IS NULL
)

SELECT *
FROM invalid_salaries;

/*
Finding Google Jobs via Subquery (1.23.3) - Problem
1.23 Subqueries and CTEs
Problem Statement
Identify high-paying job postings (>$100K) from Google by using a subquery to retrieve the company's identifier based on its name.

Task

Create a SQL file in the Lesson folder named 1.23.3.sql.
Write a query to select the job_id, job_title_short, and job_location from the job_postings_fact table.
Filter the results to include only those records where the company_id matches the result of a subquery.
The subquery should select the company_id from the company_dim table where the company name is 'Google'.
Add a second condition to the filter to ensure the salary_year_avg is greater than 100000.
Hint
Use the AND operator in your WHERE clause to combine the subquery filter with the salary condition.

*/


SELECT
    job_id,
    job_title_short,
    job_location
FROM
    job_postings_fact
WHERE
    company_id = (
        SELECT
            company_id
        FROM
            company_dim
        WHERE
            name = 'Google'
    )
    AND salary_year_avg > 100000;

/*
Company Average Salary Comparison (1.23.4) - Problem
1.23 Subqueries and CTEs
Problem Statement
You will use a Common Table Expression (CTE) to identify job postings that pay more than their specific company's average salary. Calculating company-level aggregations in a CTE first allows you to cleanly join and compare those baselines against individual records in your main query.

Task

 

Create a SQL file named 1.23.4.sql in the Lesson folder.

Use the company_jobs database.

Create a Common Table Expression (CTE) named company_averages.

Inside the CTE, query data_jobs.job_postings_fact to select company_id and the average of salary_year_avg (aliased as avg_company_salary), grouped by company_id.

In your main query, perform an INNER JOIN between data_jobs.job_postings_fact and your company_averages CTE using company_id.

Select job_id, job_title_short, company_id, salary_year_avg, and avg_company_salary.

Filter the results to only include jobs where salary_year_avg is greater than avg_company_salary.

 

Hint
Start your CTE with the WITH keyword, wrap the internal query in parentheses, and treat the CTE name just like a physical table in your JOIN clause.

*/

USE company_jobs;

WITH company_averages AS(
    SELECT
        company_id,
        AVG(salary_year_avg) AS avg_company_salary
    FROM
        data_jobs.job_postings_fact
    GROUP BY company_id
)

SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.company_id,
    jpf.salary_year_avg,
    ca.avg_company_salary
FROM company_averages AS ca
INNER JOIN
    data_jobs.job_postings_fact AS jpf
ON
    ca.company_id = jpf.company_id
WHERE
    jpf.salary_year_avg > ca.avg_company_salary;

/*
Jobs in Above Average Countries (1.23.5) - Problem
1.23 Subqueries and CTEs
Problem Statement
Identify job postings located in countries that have high market activity. Specifically, you need to find jobs in countries where the total number of job postings exceeds the average number of postings per country.

Task

Create a SQL file in the Lesson folder named 1.23.5.sql.
Write a query to select the job_id, job_title_short, and job_location columns from the job_postings_fact table.
Filter the results to include only those rows where the job_country belongs to a group of countries with high job volume.
To define "high job volume," use a subquery structure that:
Groups the data by job_country.
Filters these groups using a HAVING clause to keep only those where the count of jobs is greater than the global average job count per country.
Note: You will likely need a nested subquery to first calculate the counts per country, and then take the AVG of those counts to use as your comparison benchmark.
Order the final output by job_country and then job_id in ascending order.
Hint
Start by writing the innermost query to find the COUNT of jobs per country, then wrap that in a query to find the AVG count.
Use the result of that average calculation inside the HAVING clause of your subquery that filters for specific countries.
The main query should use the IN operator to filter the job_country against the list returned by your subquery.
*/

USE data_jobs;
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_location
FROM
    job_postings_fact AS jpf
WHERE
    jpf.job_country IN (
        SELECT
            job_country
        FROM
            job_postings_fact
        GROUP BY
            job_country
        HAVING
            COUNT(job_id) > (
                SELECT AVG(country_count)
                FROM (
                    SELECT COUNT(job_id) AS country_count
                    FROM job_postings_fact
                    GROUP BY job_country
                )
            )
    )
ORDER BY
    jpf.job_country,
    jpf.job_id;

SELECT
    job_id,
    job_title_short,
    job_location
FROM job_postings_fact
WHERE
    job_country IN (
        SELECT
            job_country
        FROM
            job_postings_fact
        GROUP BY
            job_country
        HAVING 
            COUNT (job_id) > (
            SELECT AVG(country_count)
            FROM (
                SELECT COUNT(job_id) AS country_count
                FROM    job_postings_fact
                GROUP BY job_country
            ) AS country_counts
            )
    )
    ORDER BY 
    job_country,
    job_id;

/*
Programming vs. Database Job Volume (1.23.6) - Problem
1.23 Subqueries and CTEs
Problem Statement
Analyze the market demand for core technical competencies by comparing the number of unique job postings that require programming skills versus database skills using a CTE.

Task

Create a SQL file in the Lesson folder named 1.23.6.sql.
Create a Common Table Expression (CTE) named core_skills to filter the skills_dim table.
Inside the CTE, select skill_id and type (aliased as skill_type), keeping only rows where the type is 'programming' or 'databases'.
In the main query, perform an INNER JOIN between skills_job_dim and your core_skills CTE on the skill_id column.
Select the skill_type and calculate the total number of unique jobs (using job_id) associated with each type.
Group the results by skill_type and order them by the job count in descending order.
Hint
Use the IN operator within your CTE to efficiently filter for multiple skill types.
Remember to use DISTINCT when counting jobs, as a single job posting might list multiple skills within the same category (e.g., Python and Java).
*/

WITH core_skills AS(
    SELECT
        skill_id,
        type AS skill_type
    FROM
        skills_dim
    WHERE
        type IN ('programming', 'databases')
)

SELECT
    cs.skill_type,
    COUNT(DISTINCT sjd.job_id)
FROM core_skills AS cs
INNER JOIN
    skills_job_dim AS sjd
ON
    cs.skill_id = sjd.skill_id
GROUP BY
    cs.skill_type
ORDER BY
    COUNT(sjd.job_id) DESC;

/*
Identifying Companies with Active Postings (1.23.7) - Problem
1.23 Subqueries and CTEs
Problem Statement
Identify active hiring companies by retrieving the names of all companies that currently have at least one job posting recorded in the database. This helps differentiate between all registered companies and those with active market presence.

Task

Create a SQL file in the Lesson folder named 1.23.7.sql.
Write a query to select the name column from the company_dim table.
Use an EXISTS clause to filter for companies that have a matching company_id within the job_postings_fact table.
Ensure the subquery specifically links the company_id from the fact table to the company_id in the dimension table.
Hint
Recall that the EXISTS operator evaluates to TRUE if the subquery returns at least one row, making it an efficient way to check for related records without duplicates.
When using a correlated subquery, remember to alias your tables to clearly define the relationship between the outer query and the inner filter.
*/

SELECT
    cd.name
FROM
    company_dim AS cd
WHERE EXISTS (
    SELECT 1
    FROM job_postings_fact AS jpf
    WHERE jpf.company_id = cd.company_id
);


/*
Identifying Python-Required Data Engineer Roles (1.23.8) - Problem
1.23 Subqueries and CTEs
Problem Statement
Identify specific job opportunities in the data engineering field that require proficiency in Python. This analysis helps focus job search efforts on roles that match a specific technical skill set by filtering the primary job listings based on the presence of associated skill records.

Task

Create a SQL file in the Lesson folder named 1.23.7.sql.
Write a query that retrieves the job_id and job_title_short columns from the job_postings_fact table.
Filter the results to include only those records where the job_title_short is exactly 'Data Engineer'.
Use an EXISTS clause to further filter for job postings that have a corresponding entry in the skills tables.
Within the subquery, join skills_job_dim with skills_dim to verify that the skills column contains the value 'python'.
Hint
Recall that the EXISTS operator is used to check for the existence of any record in a subquery; it returns TRUE as soon as a single match is found.
Make sure to correlate the subquery to the outer query by matching the job_id from both tables to ensure you are checking skills for the correct job posting.

*/

SELECT
    jpf.job_id,
    jpf.job_title_short
FROM
    job_postings_fact jpf
WHERE
    jpf.job_title_short = 'Data Engineer'
AND EXISTS(
    SELECT 1
    FROM skills_job_dim AS sjd
    INNER JOIN  skills_dim AS sd
    ON  sjd.skill_id = sd.skill_id
    WHERE jpf.job_id = sjd.job_id
    AND sd.skills = 'python'
);

/*
Skills Missing from Senior Data Engineer (1.23.9) - Problem
1.23 Subqueries and CTEs
Problem Statement
Identify and extract a list of specific skills that have zero association with 'Senior Data Engineer' job postings. This analysis helps determine which technical skills in the database are currently not being utilized or required for this specific high-level role.

Task

Create a SQL file in the Lesson folder named 1.23.9.sql.
Write a query to retrieve the skills column from the data_jobs.skills_dim table.
Filter the results using a NOT EXISTS subquery to exclude any skills that appear in job postings for a specific role.
Within the subquery, JOIN the skills_job_dim table with the job_postings_fact table.
Apply a filter within the subquery to only look for the job_title_short value of 'Senior Data Engineer'.
Ensure the subquery is correlated to the outer query by matching the skill_id from both tables.
Hint
Recall that a NOT EXISTS operator returns TRUE only if the subquery returns no rows for that specific record.
When using NOT EXISTS, you do not need to select specific columns in the subquery; using SELECT 1 is a common and efficient practice.
Check your table aliases to ensure the correlation in the WHERE clause correctly links the skill being evaluated in the outer query to the job postings in the inner query.
*/

SELECT
    sd.skills
FROM
    skills_dim AS sd
WHERE NOT EXISTS (
    SELECT 1
    FROM skills_job_dim AS sjd
    INNER JOIN job_postings_fact jpf
    ON sjd.job_id = jpf.job_id
    WHERE sd.skill_id = sjd.skill_id 
    AND jpf.job_title_short = 'Senior Data Engineer'
);