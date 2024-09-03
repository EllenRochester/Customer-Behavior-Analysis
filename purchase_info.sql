CREATE OR REPLACE VIEW purchases_info AS
SELECT
	purchase_id,
    student_id,
    purchase_type,
    date_start,
	IF(date_refunded IS NULL, date_end, date_refunded) AS date_end
    
-- Subquery to calculate 'date_start' and 'date_end'
FROM
(SELECT 
	purchase_id,
    student_id,
    purchase_type, -- Type of purchase (0 = monthly, 1 = quarterly, 2 = yearly)
    date_purchased AS date_start,
    -- Calculate the end date based on the purchase type
	CASE
     -- If purchase_type is 0 (monthly), the end date is the same day next month
	WHEN purchase_type = 0 THEN
	DATE_ADD(MAKEDATE(YEAR(date_purchased),DAY(date_purchased)),
			INTERVAL MONTH(date_purchased) MONTH)
	-- If purchase_type is 1 (quarterly), the end date is the same day three months later
	WHEN purchase_type = 1 THEN
	DATE_ADD(MAKEDATE(YEAR(date_purchased),DAY(date_purchased)),
			INTERVAL MONTH(date_purchased) + 2 MONTH)
	-- If purchase_type is 2 (yearly), the end date is the same day twelve months later
	WHEN purchase_type = 2 THEN
	DATE_ADD(MAKEDATE(YEAR(date_purchased),DAY(date_purchased)),
			INTERVAL MONTH(date_purchased) + 11 MONTH)
	END AS date_end,
	date_refunded
FROM student_purchases) Sub;


