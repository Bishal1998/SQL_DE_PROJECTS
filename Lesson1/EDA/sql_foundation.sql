/*
Sort Job Postings by Location

Problem Statement
Retrieve the following columns from the job_postings_fact table:
job_id
job_title_short
job_location
job_via

Then, sort the results in ascending order by job_location.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via
FROM
    job_postings_fact
ORDER BY
    job_location;


/*
Sort Job Postings by Title 

Problem Statement
Retrieve the following columns from the job_postings_fact table:
job_id
job_title_short
job_location
job_via

Then, sort the results in descending order by job_title_short.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via
FROM
    job_postings_fact
ORDER BY
    job_title_short DESC;

/*
Last 10 Postings by ID 

Problem Statement
Retrieve the following columns from the job_postings_fact table:
job_id
job_title_short
job_location
job_via

Then, retrieve the last 10 postings based on job_id.

Hint
To only get the 10 entries use LIMIT.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via
FROM
    job_postings_fact
ORDER BY
    job_id DESC
LIMIT 10;

/*

List Unique Countries

Problem Statement
Retrieve the list of unique countries from the job_postings_fact table and present them in alphabetical order.

Output Column: job_country
Hint
To get unique countries use the keyword: DISTINCT

*/

SELECT DISTINCT
    job_country
FROM
    job_postings_fact
ORDER BY
    job_country;

/*
Data Engineer Postings with Salary 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings that have a job_title_short of Data Engineer:
job_id
job_title_short
job_location
job_via
salary_year_avg

Then, sort the results by job_id in ascending order.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Engineer'
ORDER BY
    job_id;

/*
Top 10 Paying Jobs w/ Missing Location

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings where the job location is missing (job_location IS NULL):

job_id
job_title_short
job_location
job_via
salary_year_avg
Then:

Show only the top 10 highest salaries.

Include an inline SQL comment next to the filter in the WHERE clause explaining that this selects rows with missing locations.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_location IS NULL
-- This will filter the data with missing job_location
ORDER BY
    salary_year_avg DESC
LIMIT 10;

/*
Jobs in Tampa Florida 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings located in Tampa, FL:

job_id
job_title_short
job_location
job_via
salary_year_avg

Then, sort the results by salary_year_avg in descending order.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_location = 'Tampa, FL'
ORDER BY
    salary_year_avg DESC;

/*
Full-time Roles 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings with a schedule type of Full-time:

job_id
job_title_short
job_location
job_via
salary_year_avg
job_schedule_type

Then, sort the results by salary_year_avg in descending order.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg,
    job_schedule_type
FROM
    job_postings_fact
WHERE
    job_schedule_type = 'Full-time'
ORDER BY
    salary_year_avg DESC;

-- check the distinct job_schedule_type
SELECT DISTINCT
	job_schedule_type
FROM
	job_postings_fact;

/*
Non-Part-time Jobs by Salary 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings where the schedule type is not Part-time:

job_id
job_title_short
job_location
job_via
salary_year_avg
job_schedule_type

Then, sort the results by salary_year_avg in ascending order.
*/
SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg,
    job_schedule_type
FROM
    job_postings_fact
WHERE
    job_schedule_type != 'Part-time'
ORDER BY
    salary_year_avg;

/*
Non-LinkedIn Jobs by Salary 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings that are not listed via LinkedIn:

job_id
job_title_short
job_location
job_via
salary_year_avg

Then, sort the results by salary_year_avg in descending order.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_via != 'via LinkedIn'
ORDER BY
    salary_year_avg DESC;

/*
Jobs with Salary >= 65K 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings with an annual salary greater than or equal to 65,000:

job_id
job_title_short
job_location
job_via
salary_year_avg

Then, sort the results by job_id in ascending order.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    salary_year_avg >= 65_000
ORDER BY
    job_id;

/*
Data Engineer Jobs by Salary 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings where the job title is Data Engineer and the country is United States:

job_id
job_title_short
job_country
job_via
salary_year_avg

Then, sort the results by salary_year_avg in ascending order.
*/

SELECT
    job_id,
    job_title_short,
    job_country,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Engineer' AND job_country = 'United States'
ORDER BY
    salary_year_avg;

/*
Full-time or Contractor Jobs (1.3.10) - Problem
1.3 Comparison & Logical Operators
Problem Statement
From the job_postings_fact table, retrieve the following columns for postings where the schedule type is either Full-time or Contractor:

job_id
job_title_short
job_location
job_via
salary_year_avg
job_schedule_type
Then, sort the results by salary_year_avg in ascending order.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg,
    job_schedule_type
FROM
    job_postings_fact
WHERE
    job_schedule_type = 'Full-time' OR job_schedule_type = 'Contractor'
ORDER BY
    salary_year_avg;

/*
Jobs with Salaries 50K to 70K 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings with an annual salary between 50,000 and 70,000 (inclusive):

job_id
job_title_short
job_location
job_via
salary_year_avg

Then, sort the results by job_id in ascending order.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    salary_year_avg BETWEEN 50_000 AND 70_000
ORDER BY
    job_id;

/*
Data Scientist or Business Analyst Jobs 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings where the job title is either Data Scientist or Business Analyst:

job_id
job_title_short
job_location
job_via
salary_year_avg

Then, sort the results by salary_year_avg in ascending order.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg,
FROM
    job_postings_fact
WHERE
    job_title_short IN ('Data Scientist', 'Business Analyst')
ORDER BY
    salary_year_avg;

/*
Filtered Analytical Roles 

Problem Statement
Write a query to list specific analytics job postings with valid yearly salary data.

Task

Use the job_postings_fact table.
Return only the following columns:
job_id
job_title_short
job_location
job_via
salary_year_avg
Include only rows where job_title_short is:
'Data Analyst'
'Data Scientist'
'Business Analyst'
Exclude rows where salary_year_avg is NULL.
Order the results by job_id in ascending order.

*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_title_short IN ('Data Analyst', 'Data Scientist', 'Business Analyst')
    AND
    salary_year_avg IS NOT NULL
ORDER BY
    job_id;

/*
Data Engineer Jobs 50K to 75K 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings where the job title is Data Engineer and the annual salary is between 50,000 and 75,000 (inclusive):

job_id
job_title_short
job_location
salary_year_avg

Then, sort the results by job_id in ascending order.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Engineer'
    AND
    salary_year_avg BETWEEN 50_000 AND 75_000
ORDER BY
    job_id;

/*
Engineer Jobs Above 75K 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings where the job title is either Data Engineer or Software Engineer and the annual salary is greater than 75,000:

job_id
job_title_short
job_location
salary_year_avg
job_schedule_type

Then, sort the results by job_id in ascending order.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    salary_year_avg,
    job_schedule_type
FROM
    job_postings_fact
WHERE
    job_title_short IN ('Data Engineer', 'Software Engineer')
    AND
    salary_year_avg > 75_000
ORDER BY
    job_id;


-- Wildcards and Aliases

/*

Companies with “Tech”

Problem Statement
From the company_dim table, return company names where the text Tech is immediately followed by exactly one character (e.g., Lego Techs, Mario SuperTech.).

Output Column: name
Then, sort the results by name in ascending order.

*/

SELECT
    name
FROM
    company_dim
WHERE
    name LIKE ('%Tech_')
ORDER BY
    name;

/*

Jobs with “Engineer” + One Character 

Problem Statement
From the job_postings_fact table, retrieve the following columns for postings where the job_title ends with the word Engineer immediately followed by exactly one character:

job_id
job_title
job_posted_date
Then, sort the results by job_id in ascending order.

*/

SELECT
    job_id,
    job_title,
    job_posted_date
FROM
    job_postings_fact
WHERE
    job_title LIKE ('%Engineer_')
ORDER BY
    job_id;

/*

Column Aliases

Problem Statement
From the job_postings_fact table, return the following columns, applying aliases as specified:

job_id
job_title_short
job_location
job_via as job_posted_site
job_posted_date
salary_year_avg as avg_yearly_salary

Then, sort the results by salary_year_avg in ascending order (using the alias in the ORDER BY clause).
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_via AS job_posted_site,
    job_posted_date,
    salary_year_avg AS avg_yearly_salary
FROM
    job_postings_fact
ORDER BY
    avg_yearly_salary;

/*
Jobs Containing “a_a” 

Problem Statement
From the job_postings_fact table, identify job postings where the job_title contains the pattern a_a anywhere in the title. Return the following columns:

job_id
job_title

Then, sort the results by job_id in ascending order.

Note
"a_a" is an example pattern in this case and can be changed to any pattern you wish.

*/

SELECT
    job_id,
    job_title
FROM
    job_postings_fact
WHERE
    job_title LIKE ('%a_a%')
ORDER BY
    job_id;

/*
Bonus and Total Compensation 

Problem Statement
From the job_postings_fact table, return the following columns and calculate two new ones for bonus and total compensation:

job_id
job_title_short
salary_year_avg
salary_year_bonus → 15% of salary_year_avg
salary_year_total → salary_year_avg plus salary_year_bonus

Include only rows where salary_year_avg is not null, and sort the results by salary_year_avg in ascending order.
*/

SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    0.15 * salary_year_avg AS salary_year_bonus,
    salary_year_avg + salary_year_bonus AS salary_year_total
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg;

/*
Hourly Rate from Salary 

Problem Statement
From the job_postings_fact table, return the following columns and calculate an hourly salary estimate based on annual pay:

job_id
job_title_short
salary_year_avg
salary_year_hourly → (calculated using annual salary and total hours worked per year)

Include only rows where salary_year_avg is not null, and sort the results by salary_year_avg in descending order.
*/

SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    salary_year_avg / 2080 AS salary_year_hourly
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC;

/*
Data Engineer Jobs with Even Hourly 

Problem Statement
Write a query to return hourly Data Engineer roles where the hourly salary is an even number.

Task

Use the job_postings_fact table.
Return these columns:
job_id
job_title_short
job_location
salary_hour_avg
job_schedule_type
Include only rows where:
job_title_short = 'Data Engineer'
salary_hour_avg is an even number.

Order the results by job_id in ascending order.
*/

SELECT
    job_id,
    job_title_short,
    job_location,
    salary_hour_avg,
    job_schedule_type
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Engineer'
    AND salary_hour_avg % 2 = 0
ORDER BY
    job_id;

/*
Annual and Overtime Pay from Hourly Rate 

Problem Statement
Studies show that Data Nerds typically work around 5 hours of overtime each week. If overtime is paid at 1.5× the regular hourly rate, let’s estimate their annual total pay by calculating each step along the way.

From the job_postings_fact table, return the following columns and compute the following values using aliases:

job_id
job_title_short
job_location
job_schedule_type
salary_hour_avg
annual_salary_hour_avg → base pay for 2,080 regular hours per year
overtime_hour_avg → hourly pay with the 1.5× overtime rate applied
annual_overtime_hour_avg → overtime pay for 5 hours per week 
annual_total → combined total of base pay and overtime pay

Include only rows where salary_hour_avg is not null, and sort the results by job_id in ascending order.

Notes
Assume 40 regular hours per week and 5 overtime hours per week.
Assume 52 working weeks in a year.
Use aliases to name each calculated column clearly in your results.

*/

SELECT
    job_id,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_hour_avg,
    salary_hour_avg * 2080 AS annual_salary_hour_avg,
    salary_hour_avg * 1.5 AS overtime_hour_avg,
    (5 * (salary_hour_avg * 1.5)) * 52 AS annual_overtime_hour_avg,
    salary_hour_avg * 2080 + ((5 * (salary_hour_avg * 1.5)) * 52) AS annual_total
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    job_id;

/*
Jobs with Health Insurance 

Problem Statement
From the job_postings_fact table, count how many job postings offer health insurance.

Output Column: jobs_with_health_insurance (the total count)
*/

SELECT
    COUNT(job_id) AS jobs_with_health_insurance
FROM
    job_postings_fact
WHERE
    job_health_insurance = True;

/*
Job Count by Country 

Problem Statement
From the job_postings_fact table, compute the number of job postings for each country.

Output Columns:
job_country
job_count (the total postings per country)

Group by job_country and sort the results by job_country in ascending order.
*/

SELECT
    job_country,
    COUNT(job_id) AS job_count
FROM
    job_postings_fact
GROUP BY
    job_country
ORDER BY
    job_country;

/*
Average Salary for WFH Jobs 

Problem Statement
From the job_postings_fact table, compute the average yearly salary for fully remote jobs by dividing the sum of salary_year_avg by the count of salary_year_avg. Return the result as:

total_yearly_salary_remote

Include only rows where job_work_from_home = TRUE and salary_year_avg is specified (i.e., not NULL).
*/

SELECT
    SUM(salary_year_avg) / COUNT(salary_year_avg) AS total_yearly_salary_remote
FROM
    job_postings_fact
WHERE
    job_work_from_home = True
-- AND salary_year_avg IS NOT NULL; is not necessary since aggregation function already filter the null values in this case.

/*
Min/Max Salary for San Francisco Jobs 

Problem Statement
From the job_postings_fact table, find the minimum and maximum yearly salaries for postings whose location includes San Francisco, in the job_location column.

Output Columns:
min_yearly_salary 
max_yearly_salary 
*/

SELECT
    MIN(salary_year_avg) AS min_yearly_salary,
    MAX(salary_year_avg) AS max_yearly_salary
FROM
    job_postings_fact
WHERE
    job_location LIKE '%San Francisco%';

/*
Average Salary for Data Engineer Postings 

Problem Statement
From the job_postings_fact table, compute the average yearly salary for Data Engineer postings and return it as a single column:

Output Column: avg_yearly_salary
*/

SELECT
    AVG(salary_year_avg) AS avg_yearly_salary
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Engineer';

/*
Salary Stats for Jobs w/ > 100K Postings 

Problem Statement
From the job_postings_fact table, compute the average, minimum, and maximum yearly salary for each job_title_short, considering only rows with a specified salary.

Output Columns:
job_title_short
avg_salary
lowest_avg_salary_offered
highest_avg_salary_offered
Include only job titles with more than 100,000 postings, and sort results by job_title_short in ascending order.
*/

SELECT
    job_title_short,
    AVG(salary_year_avg) AS avg_salary,
    MIN(salary_year_avg) AS lowest_avg_salary_offered,
    MAX(salary_year_avg) AS highest_avg_salary_offered
FROM
    job_postings_fact
GROUP BY
    job_title_short
HAVING
    COUNT(job_title_short) > 10000
ORDER BY
    job_title_short;

/*
Countries with Median Salary > 100K 

Problem Statement
From the job_postings_fact table, list each country and its median yearly salary for job postings, returning only countries whose median exceeds $100,000.

Output Columns:
job_country
median_salary
*/

SELECT
    job_country,
    MEDIAN(salary_year_avg) AS median_salary
FROM
    job_postings_fact
GROUP BY
    job_country
HAVING
    MEDIAN(salary_year_avg) > 100_000;

/*
Non-Remote Jobs w/ Salary > 70K (1.6.8) 

Problem Statement
From the job_postings_fact table, list each job_location and the number of postings that are not remote. Return only locations where the median salary of these non-remote postings is above $70,000, and order results by the non-remote count in descending order.

Output Columns:
job_location
not_remote_job_count
*/

SELECT
    job_location,
    COUNT(job_id) AS not_remote_job_count
FROM
    job_postings_fact
WHERE
    job_work_from_home = False
GROUP BY
    job_location
HAVING
    MEDIAN(salary_year_avg) > 70_000
ORDER BY
    COUNT(job_id) DESC;

/*
Data Engineering Companies 

1.11 Joins

Problem Statement
Return recent Data Engineer postings from the data_jobs database and include the company name, making sure only postings with a valid company are shown.

Task

Create a SQL file in the Lesson folder (e.g., 1.11.1.sql)
Write a query that returns, in order
job_id
job_title
name (aliased as company_name)
job_location
job_posted_date

Join job_postings_fact to company_dim

Join the tables to combine job postings with their corresponding company names

Ensure that only jobs with matching companies are included in the results

Filter the results using job_title_short for 'Data Engineer'

Order the final result set from newest to oldest based on job_posted_date
*/

SELECT
    jpf.job_id,
    jpf.job_title,
    cd.name AS company_name,
    jpf.job_location,
    jpf.job_posted_date
FROM
    job_postings_fact AS jpf
INNER JOIN
    company_dim AS cd
ON
    jpf.company_id = cd.company_id
WHERE
    jpf.job_title_short = 'Data Engineer'
ORDER BY
    jpf.job_posted_date DESC;

/*

Data Engineer Skills in US 

1.11 Joins
Problem Statement
List all Data Engineer job postings in the United States that offer health insurance from the data_jobs database, and include all available associated skills for each job, even if a job has no skills listed.

Task

Create a SQL file in the Lesson folder (e.g., 1.11.2.sql)
Write a query that connects job_postings_fact to skills_job_dim and skills_dim to associate each job with its skills

Select, in order:
job_id (from job_postings_fact)
job_title (from job_postings_fact)
skills (from skills_dim)
job_country (from job_postings_fact)
Filter the results for:
Data Engineer jobs (use job_title_short)
Country of United States
Include health insurance benefits
Order the final result set from highest to lowest based on job_id
*/

SELECT
    jpf.job_id,
    jpf.job_title,
    sd.skills,
    jpf.job_country
FROM
    job_postings_fact AS jpf
LEFT JOIN
    skills_job_dim AS sjd
ON
    jpf.job_id = sjd.job_id
LEFT JOIN
    skills_dim AS sd
ON
    sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_country = 'United States'
    AND jpf.job_health_insurance = True
ORDER BY
    jpf.job_id DESC;

/*
Jobs vs. Skills (1.11.3) 

1.11 Joins
Problem Statement
Explore the relationship between job postings and skill mappings for roles in the United States by combining all records from both the job postings table and the skills bridge table, regardless of whether they have a match.

Task

Create a SQL file in the Lesson folder (e.g., 1.11.3.sql)
Write a query that combines job_postings_fact and skills_job_dim to show all records from both tables

Select, in order
job_id
job_title_short
job_title
job_location
skill_id

Filter the results to only include rows where the country is United States

Order the final result set by job_id and then skill_id
*/

SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    sjd.skill_id
FROM
    job_postings_fact AS jpf
FULL OUTER JOIN
    skills_job_dim AS sjd
ON
    jpf.job_id = sjd.job_id
WHERE
    jpf.job_location = 'United States'
ORDER BY
    jpf.job_id,
    sjd.skill_id;

/*
"Data" Jobs Skill Count (1.11.4) 

1.11 Joins
Problem Statement
Determine the frequency of each skill mentioned across all job postings where the job title contains the word "Data" in the data_jobs database.

Task

Create a SQL file in the Lesson folder (e.g., 1.11.4.sql)
Write a query that connects job_postings_fact to skills_job_dim and then to skills_dim to associate job postings with their skills

Select, in order
job_title_short
skill_id
skills
a count of job postings (aliased as job_count)

Filter the results so that the job_title_short contains the word 'Data'
Group the results by the short job title, skill ID, and skill name so the count summarizes each unique skill combination
Order the final result set by the job count from highest to lowest
*/

SELECT
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills,
    COUNT(jpf.job_id) AS job_count
FROM
    job_postings_fact AS jpf
LEFT JOIN
    skills_job_dim AS sjd
ON
    sjd.job_id = jpf.job_id
LEFT JOIN
    skills_dim AS sd
ON
    sd.skill_id = sjd.skill_id
WHERE
    jpf.job_title_short LIKE '%Data%'
GROUP BY
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
ORDER BY
    COUNT(jpf.job_id) DESC;

/*
In Demand Skills for >$100K Jobs (1.11.5)

1.11 Joins
Problem Statement
Identify the most frequently required skills for job postings in the data_jobs database that offer a yearly salary greater than $100,000.

Task

Create a SQL file in the Lesson folder (e.g., 1.11.5.sql)
Write a query that combines job_postings_fact with skills_job_dim and skills_dim to associate high-paying jobs with their specific skills

Select, in order:
job_title_short
skills
a count of job postings (aliased as job_count)

Filter the results so that the yearly salary (salary_year_avg) is greater than 100000

Group the results by job_title_short and skills so the count summarizes each unique skill combination

Order the final result set by the job_count from highest to lowest
*/

SELECT
    jpf.job_title_short,
    sd.skills,
    COUNT(jpf.job_id) AS job_count
FROM
    job_postings_fact AS jpf
INNER JOIN
    skills_job_dim AS sjd
ON
    jpf.job_id = sjd.job_id
INNER JOIN
    skills_dim AS sd
ON
    sjd.skill_id = sd.skill_id
WHERE
    jpf.salary_year_avg > 100_000
GROUP BY
    jpf.job_title_short,
    sd.skills
ORDER BY
    COUNT(jpf.job_id) DESC;

/*
Skill Count for "Data" Roles

1.11 Joins
Problem Statement
Measure how frequently each skill appears in “Data” roles in the data_jobs database, starting from the skills lookup table

Task

Create a SQL file in the Lesson folder (e.g., 1.11.6.sql)
Write a query that starts from skills_dim and connects skills to job postings through the appropriate mapping table so each job can contribute one or more skills

Select, in order
skill_id
skills
a count of job postings as job_count

Filter the results so that only rows where job_title_short contains the word 'Data' are included

Group the results so that each skill appears once with its total job count

Order the final result set by job_count from highest to lowest
*/

SELECT
    sd.skill_id,
    sd.skills,
    COUNT(jpf.job_id) AS job_count
FROM
    skills_dim AS sd
RIGHT JOIN
    skills_job_dim AS sjd
ON
    sd.skill_id = sjd.skill_id
RIGHT JOIN
    job_postings_fact AS jpf
ON
    jpf.job_id = sjd.job_id
WHERE
    jpf.job_title_short LIKE '%Data%'
GROUP BY
    sd.skill_id,
    sd.skills
ORDER BY
    job_count DESC;