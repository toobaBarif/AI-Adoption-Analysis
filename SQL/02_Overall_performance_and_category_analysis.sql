SELECT [country]
      ,[industry]
      ,[ai_tool]
      ,[adoption_rate]
      ,[daily_active_users]
      ,[year]
      ,[age_group]
      ,[company_size]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]

  /*===================================================
   Level 2: Overall performance and category analysis
  =====================================================*/

 /*-------------------------------------
    TASK 1: Overall dataset summary
  --------------------------------------*/
	/*Total records.*/
	  SELECT COUNT(*) AS [TOTAL RECORDS]
	  FROM [AI Adoption].[dbo].[ai_adoption_dataset]
  
	 /*Number of countries, INDUSTRIES, AI_Tool.*/
  SELECT
	COUNT(DISTINCT [country]) AS [Number of countries],
	COUNT(DISTINCT [industry]) AS [Number of Industry],
	COUNT(DISTINCT [ai_tool]) AS [Number of AI_Tool]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset];

	/*Average, Minimum AND Maximum Adoption Rate.*/
  SELECT 
	AVG([adoption_rate]) AS [Average adoption rate],
	MIN([adoption_rate]) AS [Minimum adoption rate],
	MAX([adoption_rate]) AS [Maximum adoption rate]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]

	 /*Average,Minimum AND Maximum daily_active_users.*/
  SELECT 
	AVG([daily_active_users]) AS [Average daily_active_users],
	MIN([daily_active_users]) AS [Minimum daily_active_users],
	MAX([daily_active_users]) AS [Maximum daily_active_users]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]

 /*--------------------------------
    TASK 2: Category performance
  ---------------------------------*/

  /*Category summary by Tool.*/
  SELECT 
	[ai_tool],
	COUNT(*) AS [Record count by AI Tool.],
	AVG([adoption_rate]) AS [Average Adoption Rate],
	AVG([daily_active_users]) AS [Average daily_active_users],
	ROUND(
        100.0 * SUM(CASE WHEN [adoption_rate] >= 75 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS [High Adoption %]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]
  GROUP BY [ai_tool]
  ORDER BY [Average Adoption Rate] DESC;


    /*Category summary by Countries.*/
  SELECT 
	[country],
	COUNT(*) AS [Record count by Countries.],
	AVG([adoption_rate]) AS [Average Adoption Rate],
	AVG([daily_active_users]) AS [Average daily_active_users],
	ROUND(
        100.0 * SUM(CASE WHEN [adoption_rate] >= 75 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS [High Adoption %]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]
  GROUP BY [country]
  ORDER BY [Average Adoption Rate] DESC;

  /*Category summary by Industries.*/
    SELECT 
	[industry],
	COUNT(*) AS [Record count by Industries.],
	AVG([adoption_rate]) AS [Average Adoption Rate],
	AVG([daily_active_users]) AS [Average daily_active_users],
	ROUND(
        100.0 * SUM(CASE WHEN [adoption_rate] >= 75 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS [High Adoption %]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]
  GROUP BY [industry]
  ORDER BY [Average Adoption Rate] DESC;

   /*Category summary by Company sizes.*/
    SELECT 
	[company_size],
	COUNT(*) AS [Record count by Company sizes.],
	AVG([adoption_rate]) AS [Average Adoption Rate],
	AVG([daily_active_users]) AS [Average daily_active_users],
	ROUND(
        100.0 * SUM(CASE WHEN [adoption_rate] >= 75 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS [High Adoption %]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]
  GROUP BY [company_size]
  ORDER BY [Average Adoption Rate] DESC;

 /*Category summary by Age Groups.*/
    SELECT 
	[age_group],
	COUNT(*) AS [Record count by Age Groups.],
	AVG([adoption_rate]) AS [Average Adoption Rate],
	AVG([daily_active_users]) AS [Average daily_active_users],
	ROUND(
        100.0 * SUM(CASE WHEN [adoption_rate] >= 75 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS [High Adoption %]
  FROM [AI Adoption].[dbo].[ai_adoption_dataset]
  GROUP BY [age_group]
  ORDER BY [Average Adoption Rate] DESC;
