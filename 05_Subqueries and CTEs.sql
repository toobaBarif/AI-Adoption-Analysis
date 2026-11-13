SELECT TOP (1000) [country]
      ,[industry]
      ,[ai_tool]
      ,[adoption_rate]
      ,[daily_active_users] 
      ,[year]
      ,[user_feedback]
      ,[age_group]
      ,[company_size]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]


 /*=======================================
      Level 5: Subqueries and CTEs
==========================================*/

/*---------------------------------------------------
   A. Compare countries against the global average
---------------------------------------------------*/
 
/*Calculate the overall average adoption rate.*/
/*Identify countries whose average adoption exceeds the overall average.
Calculate how many percentage points each qualifying country is above that average.
*/

SELECT
    country,
    ROUND(AVG(adoption_rate), 2) AS Country_Avg,
    ROUND(
        AVG(adoption_rate) -
        (SELECT AVG(adoption_rate)
         FROM [AI Adoption].[dbo].[ai_adoption_dataset]), 2
    ) AS Difference

FROM [AI Adoption].[dbo].[ai_adoption_dataset]

GROUP BY country

HAVING AVG(adoption_rate) >
    (SELECT AVG(adoption_rate)
     FROM [AI Adoption].[dbo].[ai_adoption_dataset])

ORDER BY Difference DESC;


/*---------------------------------------------------
  B. Compare AI tools against industry averages
---------------------------------------------------*/

/* Task 1: Calculate average adoption for every industry */

SELECT
    industry,
    ROUND(AVG(adoption_rate), 2) AS IndustryAvg
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
GROUP BY industry
ORDER BY IndustryAvg DESC;


/* Task 2: Calculate average adoption for each AI tool
   within each industry */

SELECT
    industry,
    ai_tool,
    ROUND(AVG(adoption_rate), 2) AS ToolAvg
FROM [AI Adoption].[dbo].[ai_adoption_dataset]
GROUP BY industry, ai_tool
ORDER BY industry, ToolAvg DESC;


/* Tasks 3, 4, 5: Join averages, calculate differences,
   and identify greatest positive differences */

;WITH IndustryAvg AS (
    SELECT
        industry,
        AVG(adoption_rate) AS IndustryAverage
    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    GROUP BY industry
),

ToolAvg AS (
    SELECT
        industry,
        ai_tool,
        AVG(adoption_rate) AS ToolAverage
    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    GROUP BY industry, ai_tool
)

SELECT TOP 10
    t.ai_tool,
    t.industry,
    ROUND(t.ToolAverage, 2) AS ToolAverage,
    ROUND(i.IndustryAverage, 2) AS IndustryAverage,
    ROUND(t.ToolAverage - i.IndustryAverage, 2) AS Difference
FROM ToolAvg t
JOIN IndustryAvg i
    ON t.industry = i.industry
WHERE t.ToolAverage > i.IndustryAverage
ORDER BY Difference DESC;

/*---------------------------------------------------
  C. Compare individual records against industry averages
---------------------------------------------------*/

/* Compare individual adoption against industry average */

;WITH IndustryAvg AS (
    SELECT
        industry,
        AVG(adoption_rate) AS IndustryAverage
    FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    GROUP BY industry
)

SELECT
    a.country,
    a.industry,
    a.ai_tool,
    a.adoption_rate,
    ROUND(i.IndustryAverage, 2) AS IndustryAverage,
    ROUND(a.adoption_rate - i.IndustryAverage, 2) AS Difference

FROM [AI Adoption].[dbo].[ai_adoption_dataset] a

JOIN IndustryAvg i
    ON a.industry = i.industry

WHERE a.adoption_rate - i.IndustryAverage > 20

ORDER BY Difference DESC;