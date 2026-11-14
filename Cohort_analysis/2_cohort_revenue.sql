CREATE OR REPLACE VIEW cohort_revenue AS (
SELECT
	ca.cohort,
	count(DISTINCT customerkey) AS total_customers,
	Sum(total_net_revenue ) AS total_revenue,
	Sum(total_net_revenue)/ Count(DISTINCT ca.customerkey) AS customer_revenue
FROM cohort_analysis ca
WHERE ca.orderdate = ca.first_purchase_date 
GROUP BY ca.cohort
)
