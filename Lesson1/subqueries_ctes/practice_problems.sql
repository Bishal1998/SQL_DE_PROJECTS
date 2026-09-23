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

WHEN MATCHED THEN 
UPDATE SET
    skill_name = src.skill_name,
    priority_lvl = src.priority_lvl;

SELECT * FROM job_skill_priorities;

/*
ynchronizing Skill Priority Updates (1.24.5) - Problem
1.24 DDL & DML - Pt. 3
Problem Statement
Maintaining data integrity and synchronization between staging and production tables is a critical skill for data engineers. In this exercise, you need to update priority rankings for specific technical skills in a staging environment and then synchronize those changes into the main production table while tracking the update status.

Task

Create a SQL file in the Lesson folder named 1.24.5.sql.
Use the company_jobs database.
Update the staging.priority_skills table to set the priority_lvl to 1 for the skill where the skill_id is 0 (SQL).
Update the staging.priority_skills table to set the priority_lvl to 2 for the skill where the skill_id is 1 (Python).
Use a MERGE statement to synchronize the main.job_skill_priorities table (the target) with the staging.priority_skills table (the source) based on matching skill_id values.
Implement logic within the MERGE to only update records where the priority_lvl has changed or is currently NULL in the target table.
When a match is found and an update is required, update the priority_lvl and set the status column to 'PRIORITY_CHANGE'.
Hint
When using the MERGE statement, remember that WHEN MATCHED can take additional AND conditions to prevent unnecessary updates on identical rows.
Consider how NULL values behave in comparisons; a simple <> operator might not be enough to catch changes if the original value is NULL.
*/

UPDATE staging.priority_skills
SET priority_lvl = 1
WHERE skill_id = 0;

UPDATE staging.priority_skills
SET priority_lvl = 2
WHERE skill_id = 1;

MERGE INTO main.job_skill_priorities AS tgt
USING staging.priority_skills AS src
ON tgt.skill_id = src.skill_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
UPDATE SET
    priority_lvl = src.priority_lvl,
    status = 'PRIORITY_CHANGE';

SELECT * FROM job_skill_priorities;

/*
Synchronizing Source Deletions via Merge (1.24.6) - Problem
1.24 DDL & DML - Pt. 3
Problem Statement
Maintain the integrity of the job skills priority list by ensuring that deletions in the staging environment are reflected in your production data. You need to simulate a record removal and then perform a synchronization that updates the job_skill_priorities table, marking missing source records as inactive rather than deleting them permanently.

Task

Create a SQL file in the Lesson folder named 1.24.6.sql.
Use the company_jobs database.
Write a statement to DELETE the record from staging.priority_skills where the skill_id is 183.
Perform a MERGE into the job_skill_priorities table using staging.priority_skills as the source.
Join the tables on the skill_id column.
Add a clause to handle the scenario where a record is NOT MATCHED BY SOURCE.
In that scenario, UPDATE the status column in the target table to the value 'INACTIVE'.
Hint
Standard JOIN logic in a MERGE usually focuses on what is in the source; however, specialized clauses allow you to take action on target records that no longer have a corresponding match in your source data.
Remember that a Soft Delete updates a status flag (like 'INACTIVE') instead of using the DELETE command on the target table, which helps maintain historical audit trails.
*/

DELETE FROM staging.priority_skills
WHERE skill_id = 183;

MERGE INTO job_skill_priorities AS tgt
USING staging.priority_skills AS src
ON tgt.skill_id = src.skill_id

WHEN NOT MATCHED BY SOURCE THEN
UPDATE SET
    status = 'INACTIVE';

SELECT * FROM staging.priority_skills;

/*
Delete Staging Discrepancies (1.24.7) - Problem
1.24 DDL & DML - Pt. 3
Problem Statement
After marking skills as INACTIVE in previous steps, you've been tasked to perform a physical cleanup of the database. To maintain a lean and accurate system, you must perform a hard delete of any records in the job_skill_priorities production table that no longer have a corresponding entry in the staging.priority_skills table. This ensures the environment only contains currently valid priority skills.

Task

Create a SQL file in the Lesson folder named 1.24.7.sql.
Use the company_jobs database.
Write a DELETE statement to remove rows from the job_skill_priorities table (aliased as tgt).
Use a NOT EXISTS subquery to target records where the skill_id does not exist in the staging.priority_skills table (aliased as src).
Include a final SELECT statement to validate that skill_id 183 has been physically removed.
Hint
The NOT EXISTS operator is highly efficient for "anti-joins." It checks for the absence of a relationship between the target table and the subquery source.
When using DELETE with aliases, ensure your syntax matches the specific SQL dialect requirements (e.g., DELETE FROM table AS alias or DELETE alias FROM table AS alias).
Always verify your WHERE clause logic before executing a delete to avoid removing valid production data.

*/

DELETE FROM job_skill_priorities AS tgt
WHERE NOT EXISTS(
    SELECT 1
    FROM staging.priority_skills AS src
    WHERE tgt.skill_id = src.skill_id
);

SELECT * FROM job_skill_priorities WHERE skill_id = 183;