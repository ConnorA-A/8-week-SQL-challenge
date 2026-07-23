-- Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month

ALTER TABLE interest_metrics
ALTER COLUMN month_year VARCHAR(10);

UPDATE interest_metrics
SET month_year = CASE WHEN month_year = 'NULL' THEN NULL
ELSE CONVERT(VARCHAR, CONVERT(DATE, '01' + '-' + month_year, 103), 23)
END;

ALTER TABLE interest_metrics 
ALTER COLUMN month_year DATE
