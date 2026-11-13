SELECT TOP (1000) [country]
      ,[industry]
      ,[ai_tool]
      ,[adoption_rate]
      ,[daily_active_users]
      ,[year]
      ,[age_group]
      ,[company_size]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]

/*================================================
  Level 6: Window functions and rankings
=================================================*/

/*----------------------------------------------
	A. Rank AI tools within industries
------------------------------------------------*/

/*Calculate the average adoption rate for each AI tool within every industry.
Use DENSE_RANK() to rank AI tools separately within each industry.
Identify the highest-adoption AI tool within each industry.*/

/* Rank AI tools within each industry */

;WITH ToolAvg AS (
    SELECT
        industry,
        ai_tool,
        AVG(adoption_rate) AS AverageAdoption
    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    GROUP BY industry, ai_tool
),

ToolRanking AS (
    SELECT
        industry,
        ai_tool,
        AverageAdoption,
        DENSE_RANK() OVER (
            PARTITION BY industry
            ORDER BY AverageAdoption DESC
        ) AS ToolRank
    FROM ToolAvg
)

SELECT
    industry,
    ai_tool,
    ROUND(AverageAdoption, 2) AS AverageAdoption,
    ToolRank
FROM ToolRanking
ORDER BY industry, ToolRank;

/*------------------------------------
  B. Rank industries within countries
-------------------------------------*/
/*Rank industries by average adoption separately for each country.
Identify the highest and lowest-ranked industries within each country.*/

/* Rank AI tools within each industry */

;WITH ToolAvg AS (
    SELECT
        industry,
        ai_tool,
        AVG(adoption_rate) AS AverageAdoption
    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    GROUP BY industry, ai_tool
),

ToolRanking AS (
    SELECT
        industry,
        ai_tool,
        AverageAdoption,
        DENSE_RANK() OVER (
            PARTITION BY industry
            ORDER BY AverageAdoption DESC
        ) AS ToolRank
    FROM ToolAvg
)

SELECT
    industry,
    ai_tool,
    ROUND(AverageAdoption, 2) AS AverageAdoption,
    ToolRank
FROM ToolRanking
ORDER BY industry, ToolRank;

/*-----------------------------------
  C. Rank country-tool combinations
-------------------------------------*/
;WITH CountryToolAvg AS (
    SELECT
        country,
        ai_tool,
        COUNT(*) AS RecordCount,
        AVG(adoption_rate) AS AverageAdoption
    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    GROUP BY country, ai_tool
),

CountryToolRank AS (
    SELECT
        country,
        ai_tool,
        RecordCount,
        AverageAdoption,
        RANK() OVER (
            ORDER BY AverageAdoption DESC
        ) AS AdoptionRank
    FROM CountryToolAvg
)

SELECT TOP 10
    AdoptionRank,
    country,
    ai_tool,
    RecordCount,
    ROUND(AverageAdoption, 2) AS AverageAdoption
FROM CountryToolRank
ORDER BY AdoptionRank, country, ai_tool;

/*-------------------------
	D. Window averages
--------------------------*/
/*Show individual adoption alongside industry average */

SELECT
    country,
    industry,
    ai_tool,
    adoption_rate,

    ROUND(
        AVG(adoption_rate) OVER (PARTITION BY industry),
        2
    ) AS IndustryAverage

FROM [AI Adoption].[dbo].[ai_adoption_dataset]

ORDER BY industry, adoption_rate DESC;