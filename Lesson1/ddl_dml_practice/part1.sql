/*
Creating a Temporary Database (1.21.1) - Problem
1.21 DDL & DML - Pt. 1

Problem Statement
You will practice establishing a personal database workspace. This is just a temporary database; in the next problem, we will delete it.

Task

Create a SQL file in the Lesson folder named 1.21.1.sql.
Write a SQL command to create a new persistent database named sql_problems, ensuring the command does not fail if the database already exists.
Write a command to list all currently attached databases to verify that sql_problems has been successfully created and attached.
*/

CREATE DATABASE IF NOT EXISTS sql_problems;

/*
Initializing the Company Jobs Database (1.21.2) - Problem
1.21 DDL & DML - Pt. 1
Problem Statement
Clean up the database environment by removing the sql_problems database and establishing a new one dedicated to storing company job information.

Task

Create a SQL file in the Lesson folder named 1.21.2.sql.
Write a command to delete the database named sql_problems to clean up the workspace.
Execute the specific DuckDB command to list all currently available databases to verify the current state.
Create a new database named company_jobs, ensuring the command does not fail if the database already exists.
Switch the active session context to the new company_jobs database.
List the databases and verify company_jobs was created.
*/

DROP DATABASE IF EXISTS sql_problems;

CREATE DATABASE IF NOT EXISTS company_jobs;

USE company_jobs;

/*
Creating, Dropping, and Verifying Schemas (1.21.3) - Problem
1.21 DDL & DML - Pt. 1
Problem Statement
In this exercise, you will practice managing database namespaces by creating and deleting schemas using Data Definition Language (DDL) commands. You will then verify your structural changes by querying the database's internal metadata.

Task

Create a SQL file in the Lesson folder named 1.21.3.sql.
Connect to the data_jobs database in MotherDuck and then switch to use the company_jobs database.
Write a command to create a schema named staging. Ensure the command does not fail if the schema already exists.
Write a command to delete the staging schema you just created.
Write a command to create a permanent schema named dev, again, handling cases where it might already exist.
Write a final query to verify that all schemas were properly created and/or removed by inspecting the relevant table in information_schema.
Ensure you filter the results to only show schemas for company_jobs.
*/

USE company_jobs;

CREATE SCHEMA IF NOT EXISTS staging;

DROP SCHEMA IF EXISTS staging;

CREATE SCHEMA IF NOT EXISTS dev;

SELECT
    *
FROM
    information_schema.schemata
WHERE
    catalog_name = 'company_jobs';

/*
Building Recruitment Application Fact Table (1.21.4) - Problem
1.21 DDL & DML - Pt. 1
Problem Statement
You are tasked with setting up the foundational fact table for a recruitment analytics system. You will create the applications_fact table to log every job application, defining strict data types and a unique primary key to ensure data integrity for downstream reporting.

Task

Create a SQL file in the Lesson folder named 1.21.4.sql.
Use the company_jobs database.
Write a statement to create a table named applications_fact within the dev schema.
Ensure the table is only created if it does not already exist to prevent errors during pipeline execution.
Define the following columns:
Define the application_id as the PRIMARY KEY using an INTEGER type.
Include columns for candidate_id and job_id as INTEGER types to facilitate joins with dimension tables.
Add a date_applied column using the DATE type and an application_status column using the TEXT type.
Include a boolean flag named internal_candidate to distinguish between internal and external applicants.
Verify the table is created after completion.

*/

USE company_jobs;

CREATE TABLE IF NOT EXISTS dev.applications_fact(
    application_id INTEGER PRIMARY KEY,
    candidate_id INTEGER,
    job_id INTEGER,
    date_applied DATE,
    application_status TEXT,
    internal_candidate BOOLEAN
);

/*

Populating Application Fact Records (1.21.5) - Problem
1.21 DDL & DML - Pt. 1
Problem Statement
Insert initial mock data into the core applications_fact table. This step populates the recruitment system with foundational records, allowing you to track candidate statuses and internal versus external applicant flags for downstream analysis.

Task

Create a SQL file in the Lesson folder named 1.21.5.sql.
Use the company_jobs database.
Write an INSERT INTO statement to add data to the dev.applications_fact table.
Explicitly list the columns to be populated: application_id, job_id, candidate_id, date_applied, application_status, and internal_candidate.
Insert the following four records into the table:
Application 1 for Job 101 and Candidate 1 on 2025-11-10 with a status of 'Applied' and FALSE for the internal flag.
Application 2 for Job 102 and Candidate 2 on 2025-11-12 with a status of 'Interview' and TRUE for the internal flag.
Application 3 for Job 103 and Candidate 3 on 2025-11-08 with a status of 'Offer' and FALSE for the internal flag.
Application 4 for Job 104 and Candidate 4 on 2025-11-14 with a status of 'Rejected' and TRUE for the internal flag.
Inspect the table to make sure teh data was inserted in properly.
*/

USE company_jobs;

INSERT INTO dev.applications_fact(application_id, job_id, candidate_id, date_applied, application_status, internal_candidate)
VALUES (1, 101, 1, '2025-11-10', 'Applied', False),
       (2, 102, 2, '2025-11-12', 'Interview', True),
       (3, 103, 3, '2025-11-08', 'Offer', False),
       (4, 104, 4, '2025-11-14', 'Rejected', True);

SELECT
    *
FROM
    dev.applications_fact;

/*
Adding Application Follow-up Timestamps (1.21.6) - Problem
1.21 DDL & DML - Pt. 1
Problem Statement
Update the core applications fact table by adding a new column to track when follow-up actions occur. This new column will store time-zone-aware timestamps to accurately log application events for downstream analytics.

Task

Create a SQL file in the Lesson folder named 1.21.6.sql.
Use the company_jobs database.
Modify the schema of the existing dev.applications_fact table.
Add a new column named follow_up_timestamp to the table.
Ensure the new column uses the TIMESTAMPTZ data type to properly handle time zone offsets.
Inspect that this new column was created properly.

*/

ALTER TABLE dev.applications_fact
ADD COLUMN follow_up_timestamp TIMESTAMPTZ;

SELECT
    *
FROM
    dev.applications_fact;

/*
Updating Follow-up Date Column Type (1.21.7) - Problem
1.21 DDL & DML - Pt. 1
Problem Statement
Simplify the applications fact table by converting the follow-up timestamp column to a date-only format. This schema update removes unnecessary time-level granularity, improving storage efficiency and consistency for daily reporting.

Task

Create a SQL file in the Lesson folder named 1.21.7.sql.
Use the company_jobs database.
Modify the structure of the dev.applications_fact table.
Update the follow_up_timestamp column to change its data type to DATE.
Inspect that this column was updated properly.
*/

USE company_jobs;

ALTER TABLE dev.applications_fact
ALTER COLUMN follow_up_timestamp TYPE DATE;

SELECT
    *
FROM
    dev.applications_fact;


/*
Renaming Follow-up Timestamp to Date (1.21.8) - Problem

1.21 DDL & DML - Pt. 1

Problem Statement
Rename the follow_up_timestamp column to follow_up_date in the applications fact table. Since the column's data type was previously changed to store only dates, updating its name ensures the schema accurately reflects the data it holds and maintains clarity for downstream users.

Task

Create a SQL file in the Lesson folder named 1.21.8.sql.
Use the company_jobs database.
Write a statement to modify the structure of the dev.applications_fact table.
Rename the existing column follow_up_timestamp to follow_up_date.
Verify the column was updated.
Hint
When renaming a column, you need to use the ALTER TABLE command followed by the RENAME COLUMN clause. Make sure to reference the table using its full schema-qualified name: dev.applications_fact.
*/

USE company_jobs;

ALTER TABLE dev.applications_fact
RENAME COLUMN follow_up_timestamp TO follow_up_date;

SELECT
    *
FROM
    dev.applications_fact;

/*
Updating Cross-Schema Application Dates (1.21.9) - Problem
1.21 DDL & DML - Pt. 1
Problem Statement
Update the follow-up dates for specific candidates in the application tracking system. Modifying these records ensures the database reflects the latest recruitment activity and maintains accurate timelines for downstream reporting.

Task

Create a SQL file in the Lesson folder named 1.21.9.sql.
Use the company_jobs database.
Write UPDATE statements to modify the follow_up_date column for the following records:
For application_id 1 in the dev.applications_fact table, set the date to 2025-12-19.
For application_id 2 in the dev.applications_fact table, set the date to 2025-12-20.
For application_id 3 in the dev.applications_fact table, set the date to 2025-12-10.
For application_id 4 in the dev.applications_fact table, set the date to 2025-12-08.
Include a SELECT statement at the end of your script to retrieve all columns from the dev.applications_fact table to verify your updates.
Hint
When using the UPDATE command, always use a WHERE clause with a unique identifier like application_id to ensure you only change the intended row.

*/

UPDATE dev.applications_fact
SET follow_up_date = '2025-12-19'
WHERE application_id = 1;

UPDATE dev.applications_fact
SET follow_up_date = '2025-12-20'
WHERE application_id = 2;

UPDATE dev.applications_fact
SET follow_up_date = '2025-12-10'
WHERE application_id = 3;

UPDATE dev.applications_fact
SET follow_up_date = '2025-12-08'
WHERE application_id = 4;

SELECT
    *
FROM
    dev.applications_fact;

/*
Updating Internal Candidate Application Status (1.21.10) - Problem
1.21 DDL & DML - Pt. 1
Problem Statement
Update the internal candidate status for specific job applications to reflect recent hiring changes. Modifying these records ensures the database accurately identifies internal applicants for downstream reporting and tracking.

Task

Create a SQL file in the Lesson folder named 1.21.10.sql.
Use the company_jobs database.
Update the internal_candidate column to TRUE in the dev.applications_fact table for the record where the application_id is 1.
Perform a similar update in the dev.applications_fact table, setting internal_candidate to TRUE for the record where application_id is 3.
Write a final query to retrieve all columns from the dev.applications_fact table to confirm the changes were applied correctly.
Hint
The WHERE clause is essential in DML operations to prevent updating every row in the target table.
*/

UPDATE dev.applications_fact
SET internal_candidate = 'TRUE'
WHERE application_id = 1;

UPDATE dev.applications_fact
SET internal_candidate = 'TRUE'
WHERE application_id = 3;

SELECT
    *
FROM
    dev.applications_fact;

/*
Renaming and Verifying Internal Tables (1.21.11) - Problem
1.21 DDL & DML - Pt. 1
Problem Statement
Rename the applications fact table to indicate it specifically stores internal application data. Updating the table name improves schema clarity for downstream users, and querying the system metadata will verify the change was successfully registered.

Task

Create a SQL file in the Lesson folder named 1.21.11.sql.
Use the company_jobs database.
Write a statement to rename the existing table dev.applications_fact to dev.internal_applications_fact.
Write a query to inspect the information_schema.tables view to verify the name change.
Filter your verification query for rows where the table_catalog is 'company_jobs' and the table_schema is 'dev'.
Hint
When renaming a table, remember that DDL commands like ALTER TABLE are used to modify the structure of existing objects.
The information_schema is a standardized, read-only schema that provides information about all the tables and columns in your database.
*/

ALTER TABLE dev.applications_fact
RENAME TO internal_applications_fact;

SELECT
    *
FROM
    information_schema.tables
WHERE
    table_catalog = 'company_jobs';

/*
Removing Internal Candidate Fact Column (1.21.12) - Problem
1.21 DDL & DML - Pt. 1
Problem Statement
To streamline our database, we are deprecating columns that are no longer used for reporting. Your objective for this schema cleanup is to permanently remove the internal_candidate column from the internal_applications_fact table.

Task

Create a SQL file in the Lesson folder named 1.21.12.sql.
Use the company_jobs database.
Write a query to alter the structure of the dev.internal_applications_fact table.
Remove the internal_candidate column from the table definition.
Verify that the column was removed.
Hint
Remember that DDL (Data Definition Language) operations like ALTER TABLE make permanent changes to the table schema without needing a DELETE or UPDATE statement.
*/

ALTER TABLE dev.internal_applications_fact
DROP COLUMN internal_candidate;

SELECT
    *
FROM
    dev.internal_applications_fact;

/*

Fact Table Schema Cleanup (1.21.13) - Problem
1.21 DDL & DML - Pt. 1
Problem Statement
Write an idempotent script that clears the internal_applications_fact table from your environment. We will no longer be using this table for the remainder of the course, and this is part of our data cleanup.

Task

Create a SQL file in the Lesson folder named 1.21.13.sql.
Use the company_jobs database.
Write a statement to permanently remove the internal_applications_fact table from the database.
Ensure the script is idempotent by including a clause that prevents the statement from returning an error if the table has already been deleted.
NOTE: This will also hide if you specify the correct database, as it won't return an error message.
Ensure the table is dropped by querying the applicable information_schema table.
Hint
Think about using the IF EXISTS keywords to make your DROP statement more robust for automated environments. 
*/

DROP TABLE IF EXISTS dev.internal_applications_fact;

SELECT
    *
FROM
    information_schema.tables
WHERE
    table_catalog = 'company_jobs';