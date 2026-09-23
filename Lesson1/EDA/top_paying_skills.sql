/*
What are the highest-paying skills for data engineers?

- calculate median salary for each skill required in data engineer postions.
- focus on remote positions with specified salaries
- include skill frequency to identify both salary and demand

Why?
- helps identify which skills command the highest compensation while also showing how common those skills are,
providing a more complete picture for skill development priorities.
- The median is used instead of the avg to reduce the impact of outlier salaries.
*/

SELECT
    sd.skills,
    COUNT(jpf.job_id) AS skills_count,
    ROUND(MEDIAN(salary_year_avg), 0) AS median_salary
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
    jpf.job_title_short = 'Data Engineer'
    AND
    jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING
    skills_count > 100
ORDER BY
    median_salary DESC
LIMIT 10;


/*
In the Data engineering domain, having the Rust knowledge can earn highest salary of 210K, followed by the terraform and golang with 18.4K for each of them. One strong evidence is terraform is one of the must have skill in data domain. Similarly, spring and neo4j are in the 4th and 5th list of the highest paying skills. The gdpr, zoom, graphql, mongo are in the same 16K salary range, and the modern ultra fast python backend framwork fastapi interestingly listed in top 10.
┌───────────┬──────────────┬───────────────┐
│  skills   │ skills_count │ median_salary │
│  varchar  │    int64     │    double     │
├───────────┼──────────────┼───────────────┤
│ rust      │          232 │      210000.0 │
│ terraform │         3248 │      184000.0 │
│ golang    │          912 │      184000.0 │
│ spring    │          364 │      175500.0 │
│ neo4j     │          277 │      170000.0 │
│ gdpr      │          582 │      169616.0 │
│ zoom      │          127 │      168438.0 │
│ graphql   │          445 │      167500.0 │
│ mongo     │          265 │      162250.0 │
│ fastapi   │          204 │      157500.0 │
└───────────┴──────────────┴───────────────┘
  10 rows                        3 columns
*/