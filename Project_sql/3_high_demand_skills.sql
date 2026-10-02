-- What are the most in-demand skills for my role ?

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