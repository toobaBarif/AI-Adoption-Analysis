SELECT TOP (1000) [country]
      ,[industry]
      ,[ai_tool]
      ,[adoption_rate]
      ,[daily_active_users]
      ,[year]
      ,[age_group]
      ,[company_size]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]

 /*=================================
   Level 3: Adoption segmentation
=================================*/

 /*-------------------------
   A. Adoption categories
---------------------------*/
 
 /* Create adoption categories */
SELECT
    [adoption_rate],
    CASE
        WHEN [adoption_rate] >= 0 AND [adoption_rate] < 25 THEN 'Low'
        WHEN [adoption_rate] >= 25 AND [adoption_rate] < 50 THEN 'Moderate'
        WHEN [adoption_rate] >= 50 AND [adoption_rate] < 75 THEN 'High'
        WHEN [adoption_rate] >= 75 AND [adoption_rate] <= 100 THEN 'Very High'
        ELSE 'Invalid or Missing'
    END AS [Adoption Category]
FROM [AI Adoption].[dbo].[ai_adoption_dataset];


/*Calculate record count and percentage of total records in each adoption category.*/
;WITH AdoptionCategories AS (
    SELECT
        CASE
            WHEN [adoption_rate] >= 0 AND [adoption_rate] < 25 THEN 'Low'
            WHEN [adoption_rate] >= 25 AND [adoption_rate] < 50 THEN 'Moderate'
            WHEN [adoption_rate] >= 50 AND [adoption_rate] < 75 THEN 'High'
            WHEN [adoption_rate] >= 75 AND [adoption_rate] <= 100 THEN 'Very High'
            ELSE 'Invalid or Missing'
        END AS [Adoption Category]
    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
)

SELECT
    [Adoption Category],
    COUNT(*) AS [Record Count],
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM [AI Adoption].[dbo].[ai_adoption_dataset]),
        2
    ) AS [Percentage of Total Records]
FROM AdoptionCategories
GROUP BY [Adoption Category]
ORDER BY
    CASE [Adoption Category]
        WHEN 'Low' THEN 1
        WHEN 'Moderate' THEN 2
        WHEN 'High' THEN 3
        WHEN 'Very High' THEN 4
        ELSE 5
    END;


/*Calculate average daily active users for each adoption category.*/
;WITH AdoptionCategories AS (
    SELECT
        [daily_active_users],
        CASE
            WHEN [adoption_rate] >= 0 AND [adoption_rate] < 25 THEN 'Low'
            WHEN [adoption_rate] >= 25 AND [adoption_rate] < 50 THEN 'Moderate'
            WHEN [adoption_rate] >= 50 AND [adoption_rate] < 75 THEN 'High'
            WHEN [adoption_rate] >= 75 AND [adoption_rate] <= 100 THEN 'Very High'
            ELSE 'Invalid or Missing'
        END AS [Adoption Category]
    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
)

SELECT
    [Adoption Category],
    ROUND(AVG(CAST([daily_active_users] AS FLOAT)), 2) AS [Average DAU]
FROM AdoptionCategories
GROUP BY [Adoption Category]
ORDER BY
    CASE [Adoption Category]
        WHEN 'Low' THEN 1
        WHEN 'Moderate' THEN 2
        WHEN 'High' THEN 3
        WHEN 'Very High' THEN 4
        ELSE 5
    END;

/*-------------------------------
   B. Daily active user segments
--------------------------------*/

/*Examine the DAU distribution and define reasonable Low, Medium, and High usage categories.*/
SELECT DISTINCT
    MIN([daily_active_users]) OVER () AS [Minimum DAU],
    AVG(CAST([daily_active_users] AS FLOAT)) OVER () AS [Average DAU],
    MAX([daily_active_users]) OVER () AS [Maximum DAU],

    PERCENTILE_CONT(0.333333)
        WITHIN GROUP (ORDER BY [daily_active_users])
        OVER () AS [33rd Percentile],

    PERCENTILE_CONT(0.666667)
        WITHIN GROUP (ORDER BY [daily_active_users])
        OVER () AS [67th Percentile]

FROM [AI Adoption].[dbo].[ai_adoption_dataset]
WHERE [daily_active_users] IS NOT NULL;


/* Calculate average adoption rate and record count within each DAU category.*/
;WITH DAUPercentiles AS (
    SELECT
        [daily_active_users],
        [adoption_rate],

        PERCENTILE_CONT(0.333333)
            WITHIN GROUP (ORDER BY [daily_active_users])
            OVER () AS [LowLimit],

        PERCENTILE_CONT(0.666667)
            WITHIN GROUP (ORDER BY [daily_active_users])
            OVER () AS [HighLimit]

    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    WHERE [daily_active_users] IS NOT NULL
),

DAUCategories AS (
    SELECT
        [adoption_rate],
        CASE
            WHEN [daily_active_users] < [LowLimit]
                THEN 'Low'
            WHEN [daily_active_users] < [HighLimit]
                THEN 'Medium'
            ELSE 'High'
        END AS [DAU Category]
    FROM DAUPercentiles
)

SELECT
    [DAU Category],
    COUNT(*) AS [Record Count],
    ROUND(AVG([adoption_rate]), 2) AS [Average Adoption Rate]

FROM DAUCategories

GROUP BY [DAU Category]

ORDER BY
    CASE [DAU Category]
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
    END;