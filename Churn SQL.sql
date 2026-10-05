CREATE DATABASE Churn_Project;
USE Churn_Project;

ALTER TABLE churn_data
MODIFY COLUMN MonthlyCharges DECIMAL(10, 2),
MODIFY COLUMN TotalCharges DECIMAL(10, 2),
MODIFY COLUMN SeniorCitizen TINYINT,
MODIFY COLUMN tenure INT;

-- Safe mode ko 0 (off) kar do
SET SQL_SAFE_UPDATES = 0;

-- Ab apni queries chalao
UPDATE churn_data SET OnlineSecurity = 'No' WHERE OnlineSecurity = 'No internet service';
UPDATE churn_data SET OnlineBackup = 'No' WHERE OnlineBackup = 'No internet service';
UPDATE churn_data SET TechSupport = 'No' WHERE TechSupport = 'No internet service';
UPDATE churn_data SET DeviceProtection = 'No' WHERE DeviceProtection = 'No internet service';
UPDATE churn_data SET StreamingTV = 'No' WHERE StreamingTV = 'No internet service';
UPDATE churn_data SET StreamingMovies = 'No' WHERE StreamingMovies = 'No internet service';

-- Kaam hone ke baad wapas on kar do (Safety ke liye)
SET SQL_SAFE_UPDATES = 1;

SELECT 
    (CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN TechSupport = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN StreamingTV = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN StreamingMovies = 'Yes' THEN 1 ELSE 0 END) AS Multi_Service_Count,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100, 2) AS Churn_Rate
FROM churn_data
GROUP BY Multi_Service_Count
ORDER BY Multi_Service_Count;

CREATE OR REPLACE VIEW v_Churn_Final_Analysis AS
SELECT 
    *,
    CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS Churn_Status,
    CASE 
        WHEN tenure <= 6 THEN 'New (0-6m)'
        WHEN tenure <= 24 THEN 'Mid-Term (1-2yr)'
        ELSE 'Long-Term (2yr+)'
    END AS Tenure_Group
FROM churn_data;