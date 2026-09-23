/*
Defining Skill Priority Lookup Table (1.24.1) - Problem
1.24 DDL & DML - Pt. 3
Problem Statement
You will create a lookup table that assigns a priority level to essential technical skills like Python, SQL, and Power BI. By joining this reference table to other tables (as we'll do later), you can instantly filter and rank based on whether they possess these specific qualifications.

Task

Create a SQL file in the Lesson folder named 1.24.1.sql.
Use the company_jobs database.
Create a new schema called staging idempotently.
Define a new table within the staging schema named priority_skills.
Ensure the table includes three columns: skill_id (as an integer and the primary key), skill_name (a string up to 50 characters), and priority_lvl (an integer).
Write an INSERT statement to populate the table with three specific records:
Skill ID 1 for 'python' with a priority level of 1.
Skill ID 0 for 'sql' with a priority level of 1.
Skill ID 183 for 'tableau' with a priority level of 2.
As good practice, verify that the schema and tables are created properly as you go through this.
Hint
Remember that a PRIMARY KEY constraint automatically ensures that the skill_id is both unique and not null.
When inserting multiple rows in a single INSERT INTO statement, separate each set of values within parentheses using a comma.
*/

CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE staging.priority_skills(
    skill_id INTEGER PRIMARY KEY,
    skill_name VARCHAR,
    priority_lvl INTEGER
);

INSERT INTO staging.priority_skills (skill_id, skill_name, priority_lvl)
VALUES
    (1, 'python', 1),
    (0, 'sql', 1),
    (183, 'tableau', 2);

SELECT * FROM staging.priority_skills;

/*
Populating Active Job Skill Priorities (1.24.2) - Problem
1.24 DDL & DML - Pt. 3
📝 Problem
You have access to the shared company_jobs MotherDuck catalog, which includes a staging.priority_skills table listing skill IDs your company has flagged as high priority.

Your task is to build a curated table in the main schema that pairs job postings with their associated skills — but only for skills that appear on the priority list.

Specifically, you need to:

Connect to the company_jobs database from your terminal
Create a table called job_skill_priorities with the appropriate columns
Populate it with job and skill pairs from data_jobs.skills_job_dim, filtered to only priority skills
Mark every inserted row with a status of 'ACTIVE'
Verify the table was created and populated correctly
Hint
Use CREATE TABLE IF NOT EXISTS to define your destination table structure before inserting any data
Use an INSERT INTO ... SELECT pattern to populate the table from existing sources
Think about which join type will filter results down to only skills that exist in both tables
A hardcoded string value can be included directly in your SELECT to assign the same value to every row
*/

DROP TABLE IF EXISTS main.job_skill_priorities;

CREATE TABLE IF NOT EXISTS main.job_skill_priorities(
    job_id       INTEGER,
    skill_id     INTEGER,
    skill_name   VARCHAR,
    priority_lvl INTEGER,
    status       VARCHAR,
);

INSERT INTO main.job_skill_priorities (
    job_id,
    skill_id,
    status
)
SELECT
    sjd.job_id,
    sjd.skill_id,
    'ACTIVE' AS status
FROM data_jobs.skills_job_dim AS sjd
INNER JOIN
    staging.priority_skills AS ps
ON
    ps.skill_id = sjd.skill_id;

UPDATE main.job_skill_priorities
SET status = 'URGENT'
WHERE status = 'ACTIVE';

SELECT * FROM main.job_skill_priorities;

/*
Syncing Skill Priorities from Staging (1.24.4) - Problem
1.24 DDL & DML - Pt. 3
Problem Statement
When you initially populated the job_skill_priorities table, the skill_name and priority_lvl columns were left blank (NULL). You've been tasked to fill in these missing values by pulling them directly from your priority_skills staging table. A MERGE statement is the perfect tool to match the records and update the empty columns in one step.

Task

Create a SQL file in the Lesson folder named 1.24.4.sql.
Use the company_jobs database.
Write a MERGE statement that targets the job_skill_priorities table.
Use the staging.priority_skills table as the source of the data.
Match the records between the two tables using the skill_id column.
When a match is found between the source and the target, update the skill_name and priority_lvl in the target table with the values from the source table.
Verify the table was updated correctly.
Hint
Using table aliases like tgt and src makes it much easier to reference columns in the ON and SET clauses.
The WHEN MATCHED clause only triggers for rows where the join condition evaluates to TRUE.
*/

MERGE INTO job_skill_priorities AS tgt
USING staging.priority_skills AS src
ON tgt.skill_id = src.skill_id
