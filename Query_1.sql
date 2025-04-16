WITH sales_summary AS (
  	SELECT
    	c.Country,
    	s.ProductKey,
    	COUNT(s.Order_Number) AS Nr_of_orders
  	FROM sales s
  	LEFT JOIN customers c ON s.CustomerKey = c.CustomerKey
  	GROUP BY c.Country, s.ProductKey
),
sales_ranked AS (
  	SELECT
    	*,
    	ROW_NUMBER() OVER (PARTITION BY Country ORDER BY Nr_of_orders DESC) AS rn
  	FROM sales_summary
),
country_customers as (
	select
		Country
		, count(CustomerKey) as Nr_of_customers
	from
		customers
	group by 1
),
country_orders AS (
  	SELECT
    	c.Country
    	,count(s.Order_Number) AS Total_Country_Orders
  	FROM sales s
  	LEFT JOIN customers c 
  	ON s.CustomerKey = c.CustomerKey
  	GROUP BY c.Country
)

SELECT 
	sr.Country
	, cc.Nr_of_customers
	, pr.`Product Name` as Top_Product
	, sr.Nr_of_orders as Top_Product_Order_Count
	, co.Total_Country_Orders
	, Round((sr.Nr_of_orders / co.Total_Country_Orders) * 100, 2) as Top_Product_Country_Percent
FROM sales_ranked sr
left join country_customers cc
on sr.Country = cc.Country
left join products pr
on sr.ProductKey = pr.ProductKey
LEFT JOIN country_orders co 
ON sr.Country = co.Country
WHERE rn = 1
order by sr.Country;
