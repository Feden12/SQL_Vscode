WITH customer_last_purchase AS (
SELECT 
	customerkey,
	Concat(TRIM(givenname),' ',TRIM(surname)) AS cleaned_name,
	first_purchase_date,
	orderdate,
	cohort,
	row_number() OVER (PARTITION BY customerkey ORDER BY orderdate desc) AS rn  
FROM cohort_analysis  
), churned_customers AS (
SELECT 
	customerkey,
	cleaned_name,
	cohort,
	orderdate AS last_purchase_date,
	CASE 
		WHEN orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 Months' THEN 'Churned'
		ELSE 'Active'
	END AS customer_status
FROM customer_last_purchase 
WHERE rn = 1
	AND first_purchase_date < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 Months'
)
SELECT 
	customer_status,
	cohort,	
	Count(customerkey) AS num_customers,
	Sum(Count(customerkey)) Over(PARTITION BY cohort) as total_customers,
	Round(Count(customerkey)/ Sum(Count(customerkey)) Over(PARTITION BY cohort),2) AS status_percentage
FROM
	churned_customers 
GROUP BY cohort,customer_status 