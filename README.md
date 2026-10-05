## Introduction

This project uses SQL to analyze job market data and identify the skills, roles, and qualifications that are most relevant for data-related careers.

The analysis focuses on job titles, salaries, required skills, and other job characteristics to answer questions such as:

- Which data-related roles offer the highest salaries?
- Which technical skills are most frequently requested?
- Which skills are associated with higher-paying positions?
- What are the most common job titles in the data field?
- How do salaries vary between different roles?

The goal of this project is to demonstrate practical SQL skills by working with a real-world dataset and extracting insights that can support career and job-market decisions.
## Background
Driven by a desire to better understand the data analyst job market, this project focuses on identifying the most in-demand and highest-paying skills in data-related roles. The goal is to use SQL to analyze job postings and gain practical insights into which skills and qualifications can help candidates find suitable job opportunities.

The dataset comes from the SQL course by Luke Barousse. It contains information on job titles, salaries, locations, and required skills, providing a solid foundation for exploring current trends in the data job market.
## Tools I used 
- **SQL**: Used as the primary tool for querying and analyzing the job market data. The analysis includes filtering and sorting data, aggregating results, using JOIN operations, and applying functions such as AVG, SUM, and COUNT to identify patterns in salaries, job roles, and required skills.

- **PostgreSQL**: Used to create and manage the relational database. The job market data was imported into PostgreSQL, structured into tables, and queried throughout the project.

- **Visual Studio Code**: Served as the main development environment for writing, organizing, and testing the SQL scripts. The project was structured into separate SQL files for database creation, table creation, and data analysis.

- **Git & GitHub**: Used for version control and to document the project. It provides a central place to store the SQL scripts and makes the project accessible as part of my data analysis portfolio.
## The Analysis 
### 1. Top-Paying Data Analyst Jobs

I filtered the dataset for **remote Data Analyst positions with available salary data**, joined the job postings with company information, and ranked the positions by annual average salary to identify the **10 highest-paying roles**.

```sql
SELECT
    job_id,
    job_title,
    job_location
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND job_location= 'Anywhere'
    AND salary_year_avg IS NOT NULL 
ORDER BY 
    salary_year_avg DESC
LIMIT 10 ;
```
### Major Findings
- The highest-paying Data Analyst roles offer six-figure annual salaries.
- Remote positions can provide highly competitive compensation.
- Higher salaries are concentrated among specialized and senior-level Data Analyst roles.
- Company and role specialization appear to be important factors in determining salary.
- The analysis highlights that advanced skills and specialization can significantly increase earning potential in the Data Analyst job market.
### Top paying job's skills
I identified the 10 highest-paying Software Engineer jobs in Germany based on average annual salary, then joined the results with the skills data to determine which skills are associated with these top-paying positions.
```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Software Engineer' AND job_location= 'Germany'
        AND salary_year_avg IS NOT NULL 
    ORDER BY 
        salary_year_avg DESC
    LIMIT 10 
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```
- The highest-paying Software Engineer roles offer significantly above-average annual salaries.
- Technical skills are highly varied, indicating that top-paying positions are not limited to one specific technology stack.
- The data suggests that specialized technical expertise is common among the highest-paid roles.- 
- Skills related to software development, cloud technologies, data, and modern engineering tools appear frequently among top-paying positions.
- Senior-level and specialized roles are strongly represented, suggesting that experience and specialization are important drivers of salary.
- High-paying Software Engineering jobs in Germany tend to combine core programming expertise with specialized domain or infrastructure skills
### High demand skills 
I analyzed Data Analyst job postings in Germany to identify the 10 most frequently requested skills, based on how often each skill appears across job postings.
```sql
SELECT 
    skills_dim.skills,
    Count(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_location = 'Germany'
GROUP BY skills_dim.skills
ORDER BY demand_count DESC
LIMIT 10;
```
- SQL is among the most in-demand skills for Data Analyst positions.
- Excel remains a key requirement despite the growing use of modern data tools.
- Python is highly relevant for data analysis and automation.
- Data visualization and BI tools are frequently requested by employers.
- Employers generally seek a combination of technical and analytical skills, rather than a single programming language.
- The results highlight the importance of building a broad data-analysis skill set covering databases, programming, spreadsheets, and visualization.

### Top paying skills
I analyzed the average annual salary for Data Analyst roles by required skill, excluding jobs without salary information, and ranked the top 10 highest-paying skills.
```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 10;
```
- **Highest-paying skills:** The top-ranked skills are associated with significantly higher average salaries than typical Data Analyst skills.
- **Specialized skills pay more:** Advanced technical and analytical skills tend to command higher salaries than more general tools.
- **Skill choice impacts earning potential:** The results highlight which skills could be prioritized to target higher-paying Data Analyst positions.
### Most optimal skills
I analyzed Data Analyst skills by average annual salary, while filtering for skills that appear in more than 10 job postings, then ranked the top 10 by salary.
```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    Count(skills_job_dim.job_id) AS demand_count,
    Round(AVG(job_postings_fact.salary_year_avg)) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    Count(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 10;
```
- **Higher-paying skills:** Specialized technical skills are associated with the highest average salaries.
- **Demand matters:** The HAVING clause ensures the results only include skills with meaningful job-market demand (>10 postings).
- **Salary vs. demand:** The results show that the most in-demand skills are not necessarily the highest-paying, highlighting a trade-off between market demand and earning potential.
## What I Learned

- Learned how to combine multiple SQL concepts to answer a specific business question.
- Learned how to compare skill demand and salary potential using real-world job-market data.
- Learned how to use aggregation and grouping to identify patterns across different skills.
- Learned how to filter aggregated results with HAVING to focus on relevant skills.
- Learned how to rank and prioritize results using multiple ORDER BY criteria.
- Learned how SQL can turn raw data into actionable insights for career and business decisions.
## The Conclusion
- High-demand skills are not always the highest-paying skills, showing a trade-off between job availability and salary potential.
- Specialized technical skills tend to be associated with higher average salaries.
- Skills with both strong demand and high salary potential are particularly valuable for Data Analysts.
- The analysis can help identify which skills to prioritize when developing a Data Analyst skill set.
- Overall, SQL can be used to transform job-market data into practical insights for career planning and skill development.