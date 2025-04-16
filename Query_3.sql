WITH days_difference AS (
  SELECT 
  	  YEAR(Order_Date) 						AS Year_of_order
    , MONTH(Order_Date) 					AS Month_of_order
    , DATEDIFF(Delivery_Date, Order_Date) 	AS Nr_of_days
  FROM sales
),

monthly_avg AS (
  SELECT 
      Year_of_order
    , Month_of_order
    , ROUND(AVG(Nr_of_days), 2) AS Avg_Delivery_Days
  FROM days_difference
  GROUP BY Year_of_order, Month_of_order
),

yearly_avg AS (
  SELECT 
      Year_of_order
    , ROUND(AVG(Nr_of_days), 2) AS Yearly_Avg_Delivery
  FROM days_difference
  GROUP BY Year_of_order
)

SELECT 
  	m.Year_of_order
  ,	m.Month_of_order
  ,	m.Avg_Delivery_Days
  ,	y.Yearly_Avg_Delivery
  ,	ROUND(m.Avg_Delivery_Days - y.Yearly_Avg_Delivery, 2) AS Difference_vs_Year_Avg
FROM monthly_avg m
JOIN yearly_avg y 
ON m.Year_of_order = y.Year_of_order
ORDER BY m.Year_of_order, m.Month_of_order;
