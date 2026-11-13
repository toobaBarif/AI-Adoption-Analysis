SELECT TOP (1000) [country]
      ,[industry]
      ,[ai_tool]
      ,[adoption_rate]
      ,[daily_active_users]
      ,[year]
      ,[age_group]
      ,[company_size]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]

/*==================================================
	Level 7: Year-over-year analysis (2023 vs 2024)
===================================================*/

/*----------------------------------------
   A. Overall Performance Comparison 
------------------------------------------*/

;WITH YearAvg AS (
    SELECT
        [year],
        AVG(adoption_rate) AS AvgAdoption,
        AVG(CAST(daily_active_users AS FLOAT)) AS AvgDAU
    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    WHERE [year] IN (2023, 2024)
    GROUP BY [year]
),

YearComparison AS (
    SELECT
        [year],
        AvgAdoption,
        AvgDAU,
        LAG(AvgAdoption) OVER (ORDER BY [year]) AS PreviousAdoption,
        LAG(AvgDAU) OVER (ORDER BY [year]) AS PreviousDAU
    FROM YearAvg
)

SELECT
    [year],
    ROUND(AvgAdoption, 2) AS AverageAdoption,
    ROUND(AvgDAU, 2) AS AverageDAU,
    ROUND(AvgAdoption - PreviousAdoption, 2) AS AdoptionChangePP,
    ROUND(AvgDAU - PreviousDAU, 2) AS DAUChange,
    ROUND(
        100.0 * (AvgDAU - PreviousDAU) /
        NULLIF(PreviousDAU, 0), 2
    ) AS DAUChangePercent
FROM YearComparison
ORDER BY [year];

/*--------------------------------------
	B. AI Tool Performance Over Time
----------------------------------------*/
;WITH ToolYearAvg AS (
    SELECT
        ai_tool,
        [year],
        AVG(adoption_rate) AS AvgAdoption
    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    WHERE [year] IN (2023, 2024)
    GROUP BY ai_tool, [year]
),

ToolComparison AS (
    SELECT
        ai_tool,
        [year],
        AvgAdoption,
        LAG(AvgAdoption) OVER (
            PARTITION BY ai_tool
            ORDER BY [year]
        ) AS PreviousAdoption
    FROM ToolYearAvg
),

ToolChanges AS (
    SELECT
        ai_tool,
        PreviousAdoption AS Adoption2023,
        AvgAdoption AS Adoption2024,
        AvgAdoption - PreviousAdoption AS ChangePP
    FROM ToolComparison
    WHERE [year] = 2024
      AND PreviousAdoption IS NOT NULL
),

ToolRanking AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY ChangePP DESC, ai_tool) AS IncreaseRank,
        ROW_NUMBER() OVER (ORDER BY ChangePP ASC, ai_tool) AS DecreaseRank
    FROM ToolChanges
)

SELECT
    ai_tool,
    ROUND(Adoption2023, 2) AS Adoption2023,
    ROUND(Adoption2024, 2) AS Adoption2024,
    ROUND(ChangePP, 2) AS ChangePP,
    CASE
        WHEN IncreaseRank = 1 AND ChangePP > 0 THEN 'Largest Increase'
        WHEN DecreaseRank = 1 AND ChangePP < 0 THEN 'Largest Decrease'
        ELSE ''
    END AS Result
FROM ToolRanking
ORDER BY ChangePP DESC;

/*------------------------------------------------
	C. Market and industry performance over time
--------------------------------------------------*/

/* C2. Industry Performance Over Time */

;WITH IndustryYearAvg AS (
    SELECT
        industry,
        [year],
        AVG(adoption_rate) AS AvgAdoption
    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    WHERE [year] IN (2023, 2024)
    GROUP BY industry, [year]
),

IndustryComparison AS (
    SELECT
        industry,
        [year],
        AvgAdoption,
        LAG(AvgAdoption) OVER (
            PARTITION BY industry
            ORDER BY [year]
        ) AS PreviousAdoption
    FROM IndustryYearAvg
),

IndustryChanges AS (
    SELECT
        industry,
        PreviousAdoption AS Adoption2023,
        AvgAdoption AS Adoption2024,
        AvgAdoption - PreviousAdoption AS ChangePP
    FROM IndustryComparison
    WHERE [year] = 2024
      AND PreviousAdoption IS NOT NULL
),

IndustryRanking AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY ChangePP DESC, industry) AS IncreaseRank,
        ROW_NUMBER() OVER (ORDER BY ChangePP ASC, industry) AS DecreaseRank
    FROM IndustryChanges
)

SELECT
    industry,
    ROUND(Adoption2023, 2) AS Adoption2023,
    ROUND(Adoption2024, 2) AS Adoption2024,
    ROUND(ChangePP, 2) AS ChangePP,
    CASE
        WHEN IncreaseRank <= 3 AND ChangePP > 0 THEN 'Top 3 Increase'
        WHEN DecreaseRank <= 3 AND ChangePP < 0 THEN 'Top 3 Decrease'
        ELSE ''
    END AS Result
FROM IndustryRanking
ORDER BY ChangePP DESC;