-- 1. For every user in the system, get the user_id and last booked room_no
SELECT u.user_id, b.room_no
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE b.booking_date = (
    SELECT MAX(booking_date)
    FROM bookings b2
    WHERE b2.user_id = u.user_id
);

-- 2. Get booking_id and total billing amount of every booking created in November, 2021
SELECT b.booking_id, SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE b.booking_date >= '2021-11-01' AND b.booking_date < '2021-12-01'
GROUP BY b.booking_id;

-- 3. Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000
SELECT bc.bill_id, SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE DATE(bc.bill_date) >= '2021-10-01' AND DATE(bc.bill_date) < '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- 4. Determine the most ordered and least ordered item of each month of year 2021
WITH MonthlyData AS (
    SELECT 
        EXTRACT(MONTH FROM bc.bill_date) as ord_month,
        bc.item_id,
        SUM(bc.item_quantity) as total_qty
    FROM booking_commercials bc
    WHERE EXTRACT(YEAR FROM bc.bill_date) = 2021
    GROUP BY EXTRACT(MONTH FROM bc.bill_date), bc.item_id
),
RankedData AS (
    SELECT 
        ord_month,
        item_id,
        total_qty,
        RANK() OVER(PARTITION BY ord_month ORDER BY total_qty DESC) as rank_most,
        RANK() OVER(PARTITION BY ord_month ORDER BY total_qty ASC) as rank_least
    FROM MonthlyData
)
SELECT 
    ord_month,
    MAX(CASE WHEN rank_most = 1 THEN item_id END) as most_ordered_item,
    MAX(CASE WHEN rank_least = 1 THEN item_id END) as least_ordered_item
FROM RankedData
GROUP BY ord_month;

-- 5. Find the customers with the second highest bill value of each month of year 2021
WITH MonthlyBills AS (
    SELECT 
        EXTRACT(MONTH FROM bc.bill_date) as ord_month,
        b.user_id,
        bc.bill_id,
        SUM(bc.item_quantity * i.item_rate) as bill_value
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE EXTRACT(YEAR FROM bc.bill_date) = 2021
    GROUP BY EXTRACT(MONTH FROM bc.bill_date), b.user_id, bc.bill_id
),
RankedBills AS (
    SELECT 
        ord_month,
        user_id,
        bill_value,
        DENSE_RANK() OVER(PARTITION BY ord_month ORDER BY bill_value DESC) as rnk
    FROM MonthlyBills
)
SELECT ord_month, user_id, bill_value
FROM RankedBills
WHERE rnk = 2;
