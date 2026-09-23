-- Data Types

SELECT
    table_name,
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'job_postings_fact';


SELECT
    CAST(job_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR) AS id,
    CAST(job_work_from_home AS INT) AS job_work_from_home,
    CAST(job_posted_date AS DATE) AS job_posted_date,
    CAST(salary_year_avg AS DECIMAL(10, 0)) AS salary_year_avg
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
LIMIT 10;


SELECT
    job_id :: VARCHAR || '-' || company_id :: VARCHAR AS id,
    job_work_from_home :: INT AS job_work_from_home,
    job_posted_date :: DATE AS job_posted_date,
    salary_year_avg :: DECIMAL(10, 0) AS salary_year_avg
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
LIMIT 10;

/*
New Year's Eve Job Postings 

1.20 Data Types
Problem Statement
Calculate the total number of job postings for New Year's Eve in 2024. You will need to filter the data to include only postings from December 31, 2024, ensuring that the time component of the timestamp does not interfere with your selection.

Task

Create a SQL file in the Lesson folder (e.g., 1.20.1.sql).
Select the job_posted_date, convert it to a date type, and alias it as dt.

Count the job_id column and alias it as job_postings.

Filter the results to show only records where the date is '2024-12-31'.
Group the results by the dt column.
*/

SELECT
    CAST(job_posted_date AS DATE) AS dt,
    COUNT(job_id) AS job_postings
FROM
    job_postings_fact
WHERE
    CAST(job_posted_date AS DATE) = '2024-12-31'
GROUP BY
    CAST(job_posted_date AS DATE);

/*
Degree Mention Boolean to Integer 

1.20 Data Types
Problem Statement
Count the total number of job postings from December 2024, grouped by job title and whether a degree is mentioned. You will analyze these requirements by converting the Boolean degree flag into an Integer (0 or 1) to segment the data.

Task

Create a SQL file in the Lesson folder (e.g., 1.20.2.sql).

Select job_title_short and job_no_degree_mention.

Cast the job_no_degree_mention column to an Integer.

Count the total job_id and alias it as job_postings.

Filter for job postings where the job_posted_date (cast to a Date) is BETWEEN '2024-12-01' AND '2024-12-31'.

Group by job_title_short and the converted job_no_degree_mention column.

Order by job_title_short and job_no_degree_mention.
*/

SELECT
    job_title_short,
    job_no_degree_mention::INT,
    COUNT(job_id) AS job_postings
FROM
    job_postings_fact
WHERE
    job_posted_date::DATE BETWEEN '2024-12-01' AND '2024-12-31'
GROUP BY
    job_title_short,
    job_no_degree_mention::INT
ORDER BY
    job_title_short,
    job_no_degree_mention::INT;

/*
Annualizing US Hourly Salaries 

1.20 Data Types
Problem Statement
Identify average annualized salaries for US jobs, grouped by job_title_short, and format them in two ways: precise currency and rounded whole numbers.

Task

Create a SQL file in the Lesson folder (e.g., 1.20.3.sql).

Select the job_title_short.

Calculate the annualized salary by multiplying the average salary_hour_avg by 40 (hours per week) and 52 (weeks per year).

Column 1 (Currency Precision): Cast this calculated average to a data type that allows for specific precision, ensuring exactly 2 decimal places. Alias this as salary_hour_annual.

Column 2 (Whole Number): Cast the same calculated average to a data type that has 0 decimal places. Alias this as salary_hour_annual_zero_decimals.

Filter the data to include only records from the 'United States' where the salary_hour_avg is not empty (NOT NULL).

Group the results by job_title_short and order them by the currency precision column in descending order.
*/

SELECT
    job_title_short,
    CAST(AVG(salary_hour_avg * 40 * 52) AS DECIMAL(10, 2)) AS salary_hour_annual,
    CAST(AVG(salary_hour_avg * 40 * 52) AS INT) AS salary_hour_annual_zero_decimals
FROM
    job_postings_fact
WHERE
    job_country = 'United States' 
    AND salary_hour_avg IS NOT NULL
GROUP BY
    job_title_short
ORDER BY
    CAST(AVG(salary_hour_avg * 40 * 52) AS DECIMAL(10, 2)) DESC;

/*
Generating Compound Date Keys 

1.20 Data Types
Problem Statement
Create a unique identifier for each job posting by combining multiple columns into a single "compound key." You will need to convert different data types (Dates and Integers) into a common format (String/Text) to successfully join them together.

Task

Create a SQL file in the Lesson folder (e.g., 1.20.4.sql).

Select the following columns from job_postings_fact:
job_posted_date, company_id, and job_title_short.

Create a new column aliased as dt that converts the job_posted_date into a Date type.

Create a new column aliased as compound_key by concatenating:
The company_id
A hyphen '-'
The date (from the dt calculation)

Limit the output to the first 10 rows.
*/

SELECT
    job_posted_date,
    company_id,
    job_title_short,
    job_posted_date::DATE AS dt,
    company_id::VARCHAR || '-' || dt::VARCHAR AS compound_key,
FROM
    job_postings_fact
LIMIT 10;

/*
Calculating WFH Adjusted Salary 

1.20 Data Types
Problem Statement
Compare salary and theoretical commute savings for US-based "Data" jobs. You will group the analysis by Job Title and Work-From-Home (WFH) status to see how these factors impact the average annual salary and a calculated "adjusted" salary.

Task

Create a SQL file in the Lesson folder (e.g., 1.20.5.sql).

Select job_title_short and job_work_from_home.

Calculate the standard average annual salary (AVG(salary_year_avg)) cast to an Integer.
Alias this as annual_salary_avg.

Calculate a custom column aliased as annual_commute_cost_savings:
Assume a theoretical "commute saving" of 260 hours multiplied by the hourly rate (derived by dividing annual salary by 2080).

Challenge: Ensure this calculation is only applied to jobs where job_work_from_home is True (returning 0 for non-WFH jobs). Use the boolean column directly in your math to achieve this.

Cast the final average of this calculation to an Integer for readability.

Calculate an adjusted_annual_salary_avg by adding the standard average salary and the commute savings together.
Cast the final value of this calculation to an Integer for readability.

Filter for jobs in the 'United States' where the title contains the text 'Data' (case-sensitive).

Group by job_title_short and job_work_from_home.

Order by job_title_short Descending and job_work_from_home Ascending.
*/

SELECT
    job_title_short,
    job_work_from_home,
    AVG(salary_year_avg)::INT AS annual_salary_avg,
    ((AVG(salary_year_avg)::INT * 260) * job_work_from_home::INT)::INT AS annual_commute_cost_savings,
    (annual_salary_avg + annual_commute_cost_savings)::INT AS adjusted_annual_salary_avg
FROM
    job_postings_fact
WHERE
    job_country = 'United States'
    AND job_title_short LIKE '%Data%'
GROUP BY
    job_title_short,
    job_work_from_home
ORDER BY
    job_title_short DESC,
    job_work_from_home;

-- CREATE & DROP DATABASE

CREATE DATABASE IF NOT EXISTS job_mart;
DROP DATABASE IF EXISTS job_mart;


-- CREATE & DROP Schema

CREATE SCHEMA IF NOT EXISTS job_mart.staging;

SELECT
    *
FROM
    information_schema.schemata;

DROP SCHEMA IF EXISTS job_mart.staging;

-- instead of repeatedly using job_mart.schema_name to create and drop schema, we can use USE keywords.

USE job_mart;

CREATE SCHEMA IF NOT EXISTS staging;
DROP SCHEMA IF EXISTS staging;

-- CREATE & DROP Table

CREATE TABLE IF NOT EXISTS staging.preferred_roles(
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

DROP TABLE IF EXISTS staging.preferred_roles;

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'job_mart';

INSERT INTO staging.preferred_roles(role_id, role_name)
VALUES (1, 'Bishal'),
       (2, 'Chetana');

SELECT
    *
FROM
    staging.preferred_roles;

ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;

ALTER TABLE staging.preferred_roles
DROP COLUMN preferred_role;

UPDATE staging.preferred_roles
SET preferred_role = True
WHERE role_id = 1 OR role_id = 2;

UPDATE staging.preferred_roles
SET role_name = 'Data Engineer'
WHERE role_id = 1;

UPDATE staging.preferred_roles
SET role_name = 'Senior Data Engineer'
WHERE role_id = 2;

INSERT INTO staging.preferred_roles(role_id, role_name, preferred_role)
VALUES (3, 'Software Engineer', False);

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

SELECT
    *
FROM
    staging.priority_roles;

ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;