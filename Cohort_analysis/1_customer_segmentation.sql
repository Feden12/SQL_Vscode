WITH customer_ltv  AS (
SELECT 
	customerkey,
	Concat(trim(givenname),' ',trim(surname)) AS cleaned_name,
	Sum(total_net_revenue) AS total_ltv
FROM 
	cohort_analysis
GROUP BY 
	customerkey,
	cleaned_name
	), customer_segments AS (
SELECT 
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv)  AS ltv_25th_percentile,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv)  AS ltv_75th_percentile
FROM customer_ltv 
), segment_values AS (
SELECT	*,
	CASE WHEN total_ltv <= ltv_25th_percentile THEN '1 - Low Value'
		 WHEN total_ltv < ltv_75th_percentile THEN '2 - Middle Value'
		ELSE '3 - High Value'
	END AS customer_segment 
FROM customer_ltv, customer_segments 
)
SELECT 
	customer_segment,
	sum(total_ltv) AS total_ltv,
	count(customerkey) AS customer_count,
	Sum(total_ltv)/count(customerkey) AS avg_ltv
FROM 
	segment_values 
GROUP BY customer_segment 
	
	
	
	