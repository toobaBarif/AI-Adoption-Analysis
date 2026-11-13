Global AI Adoption Analysis (2023–2024)
Project Overview
I worked on this project to understand how AI adoption varies across countries, industries, AI tools, company sizes, and age groups. I also wanted to see whether daily active users are related to adoption rates and how the results changed between 2023 and 2024.

I used Python for data preparation, exploratory analysis, and visualizations. I used Microsoft SQL Server and SQL Server Management Studio (SSMS) to explore the original dataset independently and compare adoption across different groups.
About the Dataset
The dataset contains 145,000 records from 2023 and 2024, covering 10 countries, 8 industries, and 5 AI tools. It includes adoption rates, daily active users, age groups, and company sizes. There are 43,048 records from 2023 and 101,952 from 2024.

The adoption rate is recorded on a scale from 0 to 100. Each row is an observation in the dataset and should not automatically be treated as a unique person or company.
Python Analysis
I started by checking the structure and quality of the dataset, including data types, missing values, duplicate records, and the distributions of adoption rates and daily active users. I also cleaned text fields and created adoption categories so I could compare low, moderate, high, and very high adoption.

I then examined average adoption rates across AI tools, countries, industries, age groups, company sizes, and years. I compared combinations such as AI tools within industries and AI tools across countries to understand how adoption differed between groups.

I used Matplotlib and Seaborn to explore the results through histograms, bar charts, box plots, heatmaps, and scatter plots. The user feedback field was left out of the main analysis because it was not suitable for meaningful sentiment analysis.
SQL Analysis
For the SQL portion, I imported the original CSV into Microsoft SQL Server rather than relying on results calculated in Python.

I began by checking record counts, available categories, missing values, and invalid numerical values. I then calculated adoption rates and daily active user averages by country, industry, AI tool, company size, and age group.

After that, I used SQL to compare individual records with their industry averages, identify AI tools performing above industry averages, and rank tools across industries and countries. I also compared 2023 with 2024 to examine changes in adoption rates over time.

This part of the project helped me practise filtering, grouping, conditional calculations, subqueries, common table expressions, joins, and window functions using an actual dataset.
Findings
The overall average adoption rate was approximately 49.87%. Claude had the highest average adoption among the AI tools, Germany led the countries, and Agriculture had the highest industry average. However, the differences between these leading groups and the overall average were small.

The average adoption rate was approximately 50.02% in 2023 and 49.81% in 2024, a decrease of about 0.21 percentage points. The two years contain different numbers of observations, so this does not show that the same users or companies reduced their AI adoption.

Daily active users showed almost no linear relationship with adoption rate in this dataset. This suggests that higher usage counts should not be treated as evidence of higher adoption without looking more closely at how the data was collected.
Limitations
These results describe patterns in the dataset rather than cause-and-effect relationships. The number of records differs considerably between the two years, and each row does not necessarily represent a unique individual or organization. Some group averages differ by only a small amount, so the highest-ranked group is not necessarily meaningfully ahead of the others.

The analysis also does not establish that AI adoption caused changes in user activity, or the reverse. Machine-learning results are not included here because that part of the project has not been completed and verified.
Tools Used
Python, Pandas, Matplotlib, Seaborn, Microsoft SQL Server, and SQL Server Management Studio (SSMS).
