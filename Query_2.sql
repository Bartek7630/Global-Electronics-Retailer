WITH monthly_data AS (
  SELECT 
    YEAR(Order_Date) AS Order_Year,
    MONTH(Order_Date) AS Order_Month,
    COUNT(Order_Number) AS Nr_of_Orders
  FROM sales
  GROUP BY YEAR(Order_Date), MONTH(Order_Date)
)

SELECT 
  *
  , ROUND(100 * Nr_of_Orders / SUM(Nr_of_Orders) OVER (PARTITION BY Order_Year), 2) AS Percent_of_Year
FROM monthly_data
ORDER BY Order_Year, Order_Month;
