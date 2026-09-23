/*
Archiving United Kingdom Job Postings (1.22.1) - Problem
1.22 DDL & DML - Pt. 2
Problem Statement
You will create a new, targeted archive table containing only job postings located in the United Kingdom. Segmenting massive fact tables into smaller, regional datasets drastically improves query performance and makes the data much easier to manage.

Task

Create a SQL file in the Lesson folder named 1.22.1.sql.
Use the company_jobs database.
Write a query that creates a new table named uk_jobs_archive.
Populate this new table with all columns from the data_jobs.job_postings_fact table.
Apply a filter to ensure only records where the job_country is exactly 'United Kingdom' are included in the archive.
Query the new table to verify it was created properly.
Hint
Recall the CTAS (Create Table As Select) pattern, which allows you to define a table's structure and insert data simultaneously using a subquery.
Make sure to use the fully qualified name for the source table (database.table) to ensure the query references the correct data source.
*/
USE company_jobs;

CREATE TABLE IF NOT EXISTS uk_jobs_archive 
AS 
SELECT 
    * 
FROM 
    data_jobs.job_postings_fact
WHERE
    job_country = 'United Kingdom';

SELECT
    *
FROM
    uk_jobs_archive;

/*
Summarizing Company Salary and Volume (1.22.2) - Problem
1.22 DDL & DML - Pt. 2
Problem Statement
You will create a new summary table that aggregates average salaries and job posting volumes at the company level. This is important because pre-calculating these metrics allows analysts to quickly identify competitive employers without repeatedly running expensive aggregations on the raw fact table.

Task

Create a SQL file in the Lesson folder named 1.22.2.sql.
Use the company_jobs database.
Write a query that creates a new permanent table called company_salary_stats.
Filter the source records from data_jobs.job_postings_fact to include only those where salary_year_avg is not empty (NOT NULL).
Group the data by the company_id column to aggregate metrics for each specific organization.
Select the company_id and calculate two specific metrics:
The average of the salary_year_avg column, aliased as avg_yearly_salary.
The count of job_id entries, aliased as job_count.
Query the table to verify that it was created it properly.
Hint
Remember that when using the CTAS (Create Table As Select) pattern, the CREATE TABLE statement must come before the SELECT block.

*/

CREATE TABLE company_salary_stats
AS SELECT 
    company_id,
    AVG(salary_year_avg) AS avg_yearly_salary,
    COUNT(job_id) AS job_count
FROM data_jobs.job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
GROUP BY 
    company_id;


SELECT
    *
FROM
    company_salary_stats;

/*
Ranking Companies by Remote Volume (1.22.3) - Problem
1.22 DDL & DML - Pt. 2
Problem Statement
You will create a view that consolidates remote job postings and their respective companies. This creates a reusable virtual table, making it easier to query flexible work opportunities without writing complex joins every time.

Task

Create a SQL file in the Lesson folder named 1.22.3.sql.
Use the company_jobs database.
Create a view named remote_jobs_view that joins data_jobs.job_postings_fact and data_jobs.company_dim.
Filter the view to only include records where job_work_from_home is TRUE.
The view should include the columns job_id, job_title_short, and the company name (aliased as company_name).
Write a secondary query against remote_jobs_view to count the number of jobs per company_name and thus verify it was created properly.
Order the final results by the job count in descending order.
Hint
Remember that a VIEW acts like a virtual table; once created, you can query it just like you would a standard physical table.
When counting jobs per company, ensure you use a GROUP BY clause on the non-aggregated column to avoid syntax errors.

*/

CREATE VIEW remote_jobs_view AS 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name
FROM
    data_jobs.job_postings_fact AS jpf
INNER JOIN
    data_jobs.company_dim AS cd
ON
    jpf.company_id = cd.company_id
WHERE
    jpf.job_work_from_home = 'True';


SELECT
    company_name,
    COUNT(job_id) AS job_count
FROM 
    remote_jobs_view
GROUP BY
    company_name
ORDER BY
    job_count DESC;

/*
Cloud-Skilled Data Engineer Role View (1.22.4) - Problem
1.22 DDL & DML - Pt. 2
Problem Statement
You will create a view that filters job postings specifically for Data Engineer roles requiring AWS or GCP expertise. Encapsulating this logic into a virtual table provides a reusable dataset, making it easier for analysts to quickly query these specific cloud opportunities.

Task

Create a SQL file in the Lesson folder named 1.22.4.sql.
Use the company_jobs database.
Write a statement to CREATE VIEW named cloud_engineering_roles_view.
Inside the view, select the job_title, the company name (aliased as company_name), and the skills (aliased as skill_name).
Perform an INNER JOIN between job_postings_fact and company_dim.
Link the skills data by joining skills_job_dim and skills_dim to the job postings.
Filter the results to only include roles where the job_title_short is 'Data Engineer'.
Add a condition to only include records where the skills are either 'aws' or 'gcp'.
Verify that the view was created properly.
Hint
When combining an AND operator with an OR operator in a WHERE clause, use parentheses to group the OR conditions. This ensures the filter for the job title is applied correctly alongside the choice of cloud providers.
*/

CREATE VIEW cloud_engineering_roles_view AS
SELECT
    jpf.job_title,
    cd.name AS company_name,
    sd.skills AS skill_name
FROM
    data_jobs.job_postings_fact AS jpf
INNER JOIN
    data_jobs.company_dim AS cd
ON
    jpf.company_id = cd.company_id
INNER JOIN
    data_jobs.skills_job_dim AS sjd
ON
    sjd.job_id = jpf.job_id
INNER JOIN
    data_jobs.skills_dim AS sd
ON
    sd.skill_id = sjd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND 
        sd.skills IN ('aws', 'gcp');

SELECT
    *
FROM
    cloud_engineering_roles_view;

/*
Counting Data Scientist Skill Frequency (1.22.5) - Problem
1.22 DDL & DML - Pt. 2
Problem Statement
You will create a temporary table that counts the most frequently requested skills for Data Science roles. Storing this intermediate data in a temporary table allows you to quickly analyze technical requirements without modifying your permanent schema.

Task

Create a SQL file in the Lesson folder named 1.22.5.sql.
Use the company_jobs database.
Write a query to create a TEMPORARY TABLE named ds_skills_count_temp.
Join the data_jobs.skills_dim table with data_jobs.skills_job_dim and data_jobs.job_postings_fact to associate skill names with specific job postings.
Filter the dataset to include only records where the job_title_short is 'Data Scientist'.
Group the results by the skills column to aggregate the data by individual skill names.
Select the skills column and the COUNT of job_id, assigning the alias skill_count to the result.
Verify the table was created properly by querying it.
Hint
Recall that a TEMPORARY TABLE exists only for the duration of your current database session and is useful for storing intermediate results without modifying the permanent schema.
Make sure to use INNER JOIN logic so that you only include skills that are associated with a job posting and vice-versa.
*/

CREATE TEMPORARY TABLE da_skills_count_temp AS
SELECT
    sd.skills,
    COUNT(jpf.job_id) AS skill_count
FROM
    data_jobs.skills_dim AS sd
INNER JOIN
    data_jobs.skills_job_dim AS sjd
ON
    sd.skill_id = sjd.skill_id
INNER JOIN
    data_jobs.job_postings_fact AS jpf
ON
    sjd.job_id = jpf.job_id
WHERE
    jpf.job_title_short = 'Data Scientist'
GROUP BY
    sd.skills;

SELECT
    *
FROM
    da_skills_count_temp;

/*
Staging High Volume Hiring Companies (1.22.6) - Problem
1.22 DDL & DML - Pt. 2
Problem Statement
You will create a temporary table to identify high-volume hiring partners with more than 10 job postings. Isolating these companies into a temporary staging area allows you to prioritize their data pipelines for updates without altering the permanent database schema.

Task

Create a SQL file in the Lesson folder named 1.22.6.sql.
Use the company_jobs database.
Write a statement to create a temporary table named top_hiring_companies_temp based on the results of a query.
Perform an INNER JOIN between data_jobs.company_dim and data_jobs.job_postings_fact using the company_id column.
Select the company_id, the company name (aliased as company_name), and the count of job_id (aliased as posting_count).
Group the results by both the company ID and the company name.
Filter the aggregated results to include only those companies that have more than 10 job postings.
Query the temporary table to verify it was created properly.
Hint
Remember that temporary tables are only available during your current DuckDB session; if you close the terminal, the table will need to be recreated.
When filtering on an aggregate result like a COUNT(), you must use a specific clause that is processed after the GROUP BY.
*/

CREATE TEMPORARY TABLE top_hiring_companies_temp AS
SELECT
    cd.company_id,
    cd.name AS company_name,
    COUNT(jpf.job_id) AS posting_count
FROM
    data_jobs.company_dim AS cd
INNER JOIN
    data_jobs.job_postings_fact AS jpf
ON
    cd.company_id = jpf.company_id
GROUP BY
    cd.company_id,
    cd.name
HAVING COUNT(jpf.job_id) > 10;

SELECT
    *
FROM
    top_hiring_companies_temp;

/*
Clearing Archive for Fresh Loads (1.22.7) - Problem
1.22 DDL & DML - Pt. 2
Problem Statement
You will clear all historical records from the uk_jobs_archive table (Question 1.22.1). Emptying a table while preserving its schema is essential for efficiently preparing the pipeline for a fresh data load.

Task

Create a SQL file in the Lesson folder named 1.22.7.sql.
Use the company_jobs database.
Write a SQL statement that removes all rows from the uk_jobs_archive table (Question 1.22.1).
Ensure the command used is the most efficient way to empty a table without deleting the table definition itself.
Verify the table was properly cleared.
Hint
While a DELETE statement without a WHERE clause works, there is a specific DDL command designed to "empty" a table more efficiently by deallocating the data pages.
*/

TRUNCATE TABLE uk_jobs_archive;

SELECT *
FROM uk_jobs_archive;

/*
Clearing Company Salary Stats Table (1.22.8) - Problem
1.22 DDL & DML - Pt. 2
Problem Statement
You will clear all existing records from the company_salary_stats table. Emptying this table prepares the pipeline for a fresh data run, ensuring new salary metrics are calculated from a clean slate without data duplication.

Task

Create a SQL file in the Lesson folder named 1.22.8.sql.
Use the company_jobs database.
Write a statement that removes all data from the company_salary_stats table (Question 1.22.2).
Ensure the operation is performed efficiently without dropping the table structure itself.
Query the table to ensure the data was properly removed.
Hint
Think about the difference between DELETE and TRUNCATE; one is row-based and slower, while the other is a high-performance DDL operation designed for clearing tables.
Remember that this operation is permanent and cannot be undone once the table is emptied.
*/

TRUNCATE TABLE company_salary_stats;

SELECT
    *
FROM
    company_salary_stats;

/*
Staging and Deleting 2023 Postings (1.22.9) - Problem
1.22 DDL & DML - Pt. 2
Problem Statement
For demonstration purposes, you will copy a table and then use the DELETE keyword to remove pre-2023 records. While you would normally filter this data during the initial creation, we are doing it in two steps here specifically so you can practice deleting records from an existing table.

Task

Create a SQL file in the Lesson folder named 1.22.9.sql.
Use the company_jobs database.
Create a new table named jan_2023_cleanup_copy by selecting all columns and records from the job_postings_fact table in the data_jobs database.
Delete all records from your new jan_2023_cleanup_copy table where the job_posted_date occurs before '2023-01-01'.
Verify that the contents of the table were deleted properly.
Hint
Remember that CTAS (Create Table As Select) is the most efficient way to duplicate an existing table structure and its data in one step.
When using the DELETE statement, ensure your WHERE clause uses a comparison operator (like <) to target dates prior to your cutoff point.

*/

CREATE TABLE jan_2023_cleanup_copy AS
SELECT * FROM
    data_jobs.job_postings_fact;

DELETE FROM jan_2023_cleanup_copy WHERE job_posted_date < '2023-01-01';

SELECT 
    job_id,
    job_posted_date
FROM 
    jan_2023_cleanup_copy
ORDER BY job_posted_date DESC;

/*
Creating Cleaned Yearly Salary Table (1.22.10) - Problem
1.22 DDL & DML - Pt. 2
Problem Statement
Prepare a clean dataset for specialized salary analysis by creating a new table containing specific job posting details and removing any records that lack geographic information.

Task

Create a SQL file in the Lesson folder named 1.22.10.sql.
Use the company_jobs database.
Create a new table named job_postings_fact_year_salary by selecting data from the existing data_jobs.job_postings_fact table.
Select the following columns for the new table: job_id, job_title_short, job_posted_date, job_location, and salary_year_avg.
Filter the initial table creation so that only records with a non-null salary_year_avg are included.
Write a subsequent statement to DELETE any rows from your new job_postings_fact_year_salary table where the job_location is NULL.
Hint
Using CREATE TABLE ... AS (CTAS) is a powerful way to snapshot a subset of data into a new table for faster local processing.
When using DELETE, ensure your WHERE clause correctly identifies the NULL values to avoid removing the wrong data.
*/

CREATE TABLE job_postings_fact_year_salary AS
SELECT
    job_id,
    job_title_short,
    job_posted_date,
    job_location,
    salary_year_avg
FROM
    data_jobs.job_postings_fact
WHERE
    salary_year_avg IS NOT NULL;

DELETE FROM job_postings_fact_year_salary WHERE job_location IS NULL;

SELECT *
FROM job_postings_fact_year_salary;