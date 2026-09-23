/*

Find out the top 10 demanded skills in the data engineering role. Include only the remote job postings.

*/

SELECT
    sd.skills,
    COUNT(jpf.*) AS skills_count
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
ORDER BY
    skills_count DESC
LIMIT 10;

/*
This shows that SQL and Python are the foundational skills for the data engineers with almost 29K demand for each skills. Then, the cloud platforms like aws, azure are in 3rd and 4th demanded skills to have. Similarly, the modern tools like spark, airflow, snowflake, and databricks are in the requested skills in the range from 8K-12K. At last, Java and GCP are the skills to have in the potfolio.
┌────────────┬──────────────┐
│   skills   │ skills_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘
  10 rows         2 columns

*/