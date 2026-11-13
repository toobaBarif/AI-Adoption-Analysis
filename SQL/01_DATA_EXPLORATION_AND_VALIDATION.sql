SELECT [country]
      ,[industry]
      ,[ai_tool]
      ,[adoption_rate]
      ,[daily_active_users]
      ,[year]
      ,[age_group]
      ,[company_size]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]

/*====================================================
    LEVEL 1: DATA EXPLORATION AND VALIDATION
====================================================*/


/*----------------------------------------------------
TASK 1: Verify total records and records for each year
----------------------------------------------------*/

-- Total records
SELECT COUNT(*) AS [Total Records]
FROM [AI Adoption].[dbo].[ai_adoption_dataset];

-- Records by year
SELECT
    [year],
    COUNT(*) AS [Record Count]
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
GROUP BY [year]
ORDER BY [year];


/*----------------------------------------------------
TASK 2: Identify available categories
----------------------------------------------------*/

-- Available countries
SELECT DISTINCT country
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
ORDER BY country;

-- Available industries
SELECT DISTINCT industry
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
ORDER BY industry;

-- Available AI tools
SELECT DISTINCT ai_tool
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
ORDER BY ai_tool;

-- Available age groups
SELECT DISTINCT age_group
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
ORDER BY age_group;

-- Available company sizes
SELECT DISTINCT company_size
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
ORDER BY company_size;


/*----------------------------------------------------
TASK 3: Check NULL values and invalid numerical values
----------------------------------------------------*/

-- NULL values in every column
SELECT
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS [Country NULLs],
    SUM(CASE WHEN industry IS NULL THEN 1 ELSE 0 END) AS [Industry NULLs],
    SUM(CASE WHEN ai_tool IS NULL THEN 1 ELSE 0 END) AS [AI Tool NULLs],
    SUM(CASE WHEN adoption_rate IS NULL THEN 1 ELSE 0 END) AS [Adoption Rate NULLs],
    SUM(CASE WHEN daily_active_users IS NULL THEN 1 ELSE 0 END) AS [DAU NULLs],
    SUM(CASE WHEN [year] IS NULL THEN 1 ELSE 0 END) AS [Year NULLs],
    SUM(CASE WHEN user_feedback IS NULL THEN 1 ELSE 0 END) AS [Feedback NULLs],
    SUM(CASE WHEN age_group IS NULL THEN 1 ELSE 0 END) AS [Age Group NULLs],
    SUM(CASE WHEN company_size IS NULL THEN 1 ELSE 0 END) AS [Company Size NULLs]
FROM [AI Adoption].[dbo].[ai_adoption_dataset];

-- Adoption rates outside 0 to 100%
SELECT *
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
WHERE adoption_rate < 0
   OR adoption_rate > 100;

-- Negative daily active users
SELECT *
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
WHERE daily_active_users < 0;


/*----------------------------------------------------
TASK 4: Enterprise records from 2024 with adoption >75%
----------------------------------------------------*/

SELECT *
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
WHERE company_size = 'Enterprise'
  AND [year] = 2024
  AND adoption_rate > 75;


/*----------------------------------------------------
TASK 5: High daily active users but low adoption
----------------------------------------------------*/

SELECT *
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
WHERE daily_active_users > 8000
  AND adoption_rate < 25;


/*----------------------------------------------------
TASK 6: Filter multiple AI tools using IN
----------------------------------------------------*/

SELECT *
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
WHERE ai_tool IN ('ChatGPT', 'Claude', 'Bard')
ORDER BY adoption_rate DESC;
