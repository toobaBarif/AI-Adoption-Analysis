SELECT TOP (1000) [country]
      ,[industry]
      ,[ai_tool]
      ,[adoption_rate]
      ,[daily_active_users]
      ,[year]
      ,[age_group]
      ,[company_size]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]


 /*=======================================
    Level 4: Combined category performance
==========================================*/

 /*-------------------------
   A. AI Tool × Industry
---------------------------*/
 
 /*Calculate record count, average adoption rate, and average DAU for each tool-industry combination.*/

 SELECT
	[ai_tool],
	[industry],
	COUNT(*) AS [Record Count],
	ROUND(AVG([adoption_rate]), 2) AS [Average Adoption Rate],
	ROUND(AVG(CAST([daily_active_users] AS FLOAT)), 2) AS [Average Daily Active Users]

  FROM [AI Adoption].[dbo].[ai_adoption_dataset]
  GROUP BY [ai_tool], [industry]
  HAVING
    COUNT(*) >= 1000
    AND AVG([adoption_rate]) > (
        SELECT AVG([adoption_rate])
        FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    )
ORDER BY [Average Adoption Rate] DESC;


/*-------------------------
    B. AI Tool × Country
---------------------------*/
 
/*Calculate record count, average adoption rate,
and average DAU for each tool-country combination.*/

 SELECT
	[ai_tool],
	[country],
	COUNT(*) AS [Record Count],
	ROUND(AVG([adoption_rate]), 2) AS [Average Adoption Rate],
	ROUND(AVG(CAST([daily_active_users] AS FLOAT)), 2) AS [Average Daily Active Users]

  FROM [AI Adoption].[dbo].[ai_adoption_dataset]
  GROUP BY [ai_tool], [country]
  HAVING
    COUNT(*) >= 1000
    AND AVG([adoption_rate]) > (
        SELECT AVG([adoption_rate])
        FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    )
ORDER BY [Average Adoption Rate] DESC;

/*-------------------------
  C. Country × Company Size
---------------------------*/
 
/*Calculate record count and average adoption rate for each 
country-company-size combination.*/


 SELECT
	[ai_tool],
	[company_size],
	COUNT(*) AS [Record Count],
	ROUND(AVG([adoption_rate]), 2) AS [Average Adoption Rate],
	ROUND(AVG(CAST([daily_active_users] AS FLOAT)), 2) AS [Average Daily Active Users]

  FROM [AI Adoption].[dbo].[ai_adoption_dataset]
  GROUP BY [ai_tool], [company_size]
  HAVING
    COUNT(*) >= 1000
    AND AVG([adoption_rate]) > (
        SELECT AVG([adoption_rate])
        FROM [AI Adoption].[dbo].[ai_adoption_dataset]
    )
ORDER BY [Average Adoption Rate] DESC;



