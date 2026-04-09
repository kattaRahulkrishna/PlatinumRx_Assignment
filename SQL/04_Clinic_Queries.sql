-- 1. Find the revenue we got from each sales channel in a given year (e.g. 2021)
SELECT sales_channel, SUM(amount) AS total_revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM datetime) = 2021
GROUP BY sales_channel;

-- 2. Find top 10 the most valuable customers for a given year (e.g. 2021)
SELECT c.uid, c.name, SUM(cs.amount) AS total_purchase
FROM customer c
JOIN clinic_sales cs ON c.uid = cs.uid
WHERE EXTRACT(YEAR FROM cs.datetime) = 2021
GROUP BY c.uid, c.name
ORDER BY total_purchase DESC
LIMIT 10;

-- 3. Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year (e.g. 2021)
WITH MonthlyRev AS (
    SELECT EXTRACT(MONTH FROM datetime) as month_num, SUM(amount) as revenue
    FROM clinic_sales
    WHERE EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY EXTRACT(MONTH FROM datetime)
),
MonthlyExp AS (
    SELECT EXTRACT(MONTH FROM datetime) as month_num, SUM(amount) as expense
    FROM expenses
    WHERE EXTRACT(YEAR FROM datetime) = 2021
    GROUP BY EXTRACT(MONTH FROM datetime)
),
MonthsData AS (
    SELECT COALESCE(r.month_num, e.month_num) AS month_num,
           COALESCE(r.revenue, 0) AS revenue,
           COALESCE(e.expense, 0) AS expense
    FROM MonthlyRev r
    LEFT JOIN MonthlyExp e ON r.month_num = e.month_num
    UNION
    SELECT COALESCE(r.month_num, e.month_num) AS month_num,
           COALESCE(r.revenue, 0) AS revenue,
           COALESCE(e.expense, 0) AS expense
    FROM MonthlyRev r
    RIGHT JOIN MonthlyExp e ON r.month_num = e.month_num
)
SELECT 
    month_num,
    revenue,
    expense,
    (revenue - expense) AS profit,
    CASE 
        WHEN (revenue - expense) > 0 THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM MonthsData;

-- 4. For each city find the most profitable clinic for a given month (e.g. Sept 2021)
WITH ClinicProfits AS (
    SELECT 
        c.city,
        c.cid,
        c.clinic_name,
        COALESCE(SUM(cs.amount), 0) - COALESCE(SUM((SELECT SUM(amount) FROM expenses e WHERE e.cid = c.cid AND EXTRACT(MONTH FROM e.datetime) = 9 AND EXTRACT(YEAR FROM e.datetime) = 2021)), 0) AS profit
    FROM clinics c
    LEFT JOIN clinic_sales cs ON c.cid = cs.cid AND EXTRACT(MONTH FROM cs.datetime) = 9 AND EXTRACT(YEAR FROM cs.datetime) = 2021
    GROUP BY c.city, c.cid, c.clinic_name
),
RankedProfits AS (
    SELECT 
        city,
        cid,
        clinic_name,
        profit,
        RANK() OVER(PARTITION BY city ORDER BY profit DESC) as rnk
    FROM ClinicProfits
)
SELECT city, cid, clinic_name, profit
FROM RankedProfits
WHERE rnk = 1;

-- 5. For each state find the second least profitable clinic for a given month (e.g. Sept 2021)
WITH ClinicProfits AS (
    SELECT 
        c.state,
        c.cid,
        c.clinic_name,
        COALESCE(SUM(cs.amount), 0) - COALESCE(SUM((SELECT SUM(amount) FROM expenses e WHERE e.cid = c.cid AND EXTRACT(MONTH FROM e.datetime) = 9 AND EXTRACT(YEAR FROM e.datetime) = 2021)), 0) AS profit
    FROM clinics c
    LEFT JOIN clinic_sales cs ON c.cid = cs.cid AND EXTRACT(MONTH FROM cs.datetime) = 9 AND EXTRACT(YEAR FROM cs.datetime) = 2021
    GROUP BY c.state, c.cid, c.clinic_name
),
RankedProfits AS (
    SELECT 
        state,
        cid,
        clinic_name,
        profit,
        DENSE_RANK() OVER(PARTITION BY state ORDER BY profit ASC) as rnk
    FROM ClinicProfits
)
SELECT state, cid, clinic_name, profit
FROM RankedProfits
WHERE rnk = 2;
