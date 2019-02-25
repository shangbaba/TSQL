SELECT
	NationalIDNumber,
	JobTitle,
	VacationHours,
	RANK() OVER (ORDER BY VacationHours DESC) as 'Vacation Rank',
	DENSE_RANK() OVER (ORDER BY VacationHours DESC) as 'Vacation Rank No Number Skipped',
	ROW_NUMBER() OVER (ORDER BY VacationHours DESC) as 'Row Number'
FROM [HumanResources].[Employee] 

SELECT
	JobTitle,
	VacationHours,
	RANK() OVER (PARTITION BY JobTitle ORDER BY VacationHours DESC) as 'Vacation Ranking Per Title'
FROM [HumanResources].[Employee] 
ORDER BY JobTitle DESC
	