WITH store_lifetime AS (
  SELECT 
      StoreKey
    , DATEDIFF(CURDATE(), `Open Date` ) AS Days_Active
  FROM stores
),

sales_with_amount AS (
  SELECT 
      s.StoreKey
    , SUM(s.Quantity * p.`Unit Price USD`) AS Total_Sales_USD
  FROM sales s
  JOIN products p 
  ON s.ProductKey = p.ProductKey
  GROUP BY s.StoreKey
)

SELECT 
    st.StoreKey
  , st.Days_Active
  , swa.Total_Sales_USD
  , ROUND(swa.Total_Sales_USD / st.Days_Active, 2) AS Avg_Daily_Sales_USD
FROM store_lifetime st
JOIN sales_with_amount swa 
ON st.StoreKey = swa.StoreKey
WHERE st.StoreKey <> 0
ORDER BY st.Days_Active DESC;
