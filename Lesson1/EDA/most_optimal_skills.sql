/*
What are the most optimal skills for data engineers-balancing both demand and salary?

- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
Focus only on remote Data Engineer Positions with specified annual salaries.

Why?
- This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately, rather thean letting rare, outlier skills distort the results.

*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg)) AS median_salary,
    ROUND(LN(COUNT(jpf.*)), 1) AS Ln_demand_count,
    
    ROUND(LN(COUNT(jpf.*)) * MEDIAN(jpf.salary_year_avg)/1_000_000,2) AS optimal_score
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
    AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 10;

/*

Terraform leads the list with $184K median salary while Python and SQL dominate the data engineering skills $135K and $130K respectively. AWS, Airflow, Spark are the most have skills for Data Engineers with 137K, 150K and 140K median salary. Similarly, Kafka has the high demand with 145K salary, Likewise, tools like Snowflake, Azure and the programming language have the median salaries between 128K to 135.5K.
┌───────────┬───────────────┬─────────────────┬───────────────┐
│  skills   │ median_salary │ Ln_demand_count │ optimal_score │
│  varchar  │    double     │     double      │    double     │
├───────────┼───────────────┼─────────────────┼───────────────┤
│ terraform │      184000.0 │             5.3 │          0.97 │
│ python    │      135000.0 │             7.0 │          0.95 │
│ aws       │      137320.0 │             6.7 │          0.91 │
│ sql       │      130000.0 │             7.0 │          0.91 │
│ airflow   │      150000.0 │             6.0 │          0.89 │
│ spark     │      140000.0 │             6.2 │          0.87 │
│ kafka     │      145000.0 │             5.7 │          0.82 │
│ snowflake │      135500.0 │             6.1 │          0.82 │
│ azure     │      128000.0 │             6.2 │          0.79 │
│ java      │      135000.0 │             5.7 │          0.77 │
└───────────┴───────────────┴─────────────────┴───────────────┘
  10 rows                                           4 columns

*/
