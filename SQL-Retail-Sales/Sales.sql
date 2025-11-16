--Query aggregate daily sales into monthly total,using Common Table Expressions (CTE).
WITH MonthlyData AS (
    SELECT DATE_TRUNC('month', sale_date) AS month_start,
        SUM(sales) AS monthly_sales,
        SUM(cost_of_sales) AS monthly_cos
    FROM salesdata
    GROUP BY month_start)
    SELECT *
    FROM monthlydata;
    
    -- query to calculate growth rates using LAG() MoM % Sales Growth
SELECT
    month_start,
    monthly_sales,
    monthly_cos,
    ROUND( (monthly_sales - LAG(monthly_sales, 1) OVER (ORDER BY month_start)) * 100.0 / 
        NULLIF(LAG(monthly_sales, 1) OVER (ORDER BY month_start), 0), 2) AS MoM_Sales_Growth_Pct
    FROM
    MonthlyData
ORDER BY
    month_start;

--to calculate MoM % Cost of Sales Growth
SELECT
    month_start,
    monthly_sales,
    monthly_cos,
ROUND((monthly_cos - LAG(monthly_cos, 1) OVER (ORDER BY month_start)) * 100.0 / 
        NULLIF(LAG(monthly_cos, 1) OVER (ORDER BY month_start), 0), 2) AS MoM_COS_Growth_Pct
    FROM
    MonthlyData
ORDER BY
    month_start;

--query to determine YoY % Sales Growth

SELECT
    month_start,
    monthly_sales,
    monthly_cos,
    ROUND((monthly_sales - LAG(monthly_sales, 12) OVER (ORDER BY month_start)) * 100.0 / 
        NULLIF(LAG(monthly_sales, 12) OVER (ORDER BY month_start), 0), 2) AS YoY_Sales_Growth_Pct
 FROM
    MonthlyData
ORDER BY
    month_start;

--query to calculate MoM Growth CoS
SELECT
    month_start,
    monthly_sales,
    monthly_cos,
ROUND((monthly_cos - LAG(monthly_cos, 1) OVER (ORDER BY month_start)) * 100.0 / 
        NULLIF(LAG(monthly_cos, 1) OVER (ORDER BY month_start), 0) , 2) AS MoM_COS_Growth_Pct
    FROM
    MonthlyData
ORDER BY
    month_start;
    
--query to calculate YoY Growth CoS

SELECT
    month_start,
    monthly_sales,
    monthly_cos,
    ROUND((monthly_cos - LAG(monthly_cos, 12) OVER (ORDER BY month_start)) * 100.0 / 
        NULLIF(LAG(monthly_cos, 12) OVER (ORDER BY month_start), 0), 2) AS YoY_COS_Growth_Pct
    FROM
    MonthlyData
ORDER BY
    month_start;

--Query to create a new transformed, inclusive table of MoM % and YoY% for both Sales and Cost of Sales respectively.

SELECT
    month_start,
    monthly_sales,
    monthly_cos,
    ROUND((monthly_sales - LAG(monthly_sales, 1) OVER (ORDER BY month_start)) * 100.0 / 
        NULLIF(LAG(monthly_sales, 1) OVER (ORDER BY month_start), 0)
    , 2) AS MoM_Sales_Growth_Pct,
    ROUND((monthly_sales - LAG(monthly_sales, 12) OVER (ORDER BY month_start)) * 100.0 / 
        NULLIF(LAG(monthly_sales, 12) OVER (ORDER BY month_start), 0)
    , 2) AS YoY_Sales_Growth_Pct,
    ROUND((monthly_cos - LAG(monthly_cos, 1) OVER (ORDER BY month_start)) * 100.0 / 
        NULLIF(LAG(monthly_cos, 1) OVER (ORDER BY month_start), 0)
    , 2) AS MoM_COS_Growth_Pct,
    ROUND((monthly_cos - LAG(monthly_cos, 12) OVER (ORDER BY month_start)) * 100.0 / 
        NULLIF(LAG(monthly_cos, 12) OVER (ORDER BY month_start), 0)
    , 2) AS YoY_COS_Growth_Pct
FROM
    MonthlyData
ORDER BY
    month_start;

--query analyse quarterly sales performance
YEAR(sale_date) AS Sale_Year,
    quarter(sale_date) AS Sale_Quarter,quantity_sold, daily_gross_profit_pct,
    SUM(quantity_sold) AS Total_Quantity_Sold_Per_Quarter,
    AVG(daily_sales) AS Avg_Daily_Profit_Per_Quarter,
  CASE 
   WHEN Sale_Quarter = 1 THEN 'Q1'
   WHEN Sale_Quarter = 2 THEN 'Q2'
   WHEN Sale_Quarter = 3 THEN 'Q3'
   WHEN Sale_Quarter = 4 THEN 'Q4'
  END AS Sale_Quarter
FROM sales_retail
GROUP BY Sale_Year, Sale_Quarter, quantity_sold,daily_gross_profit_pct
ORDER BY Sale_Year, Sale_Quarter;
