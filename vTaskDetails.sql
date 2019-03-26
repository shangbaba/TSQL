CREATE VIEW vTaskDetails
AS
SELECT 
	TaskID, 
	t.Name AS Task, 
	Description, 
	c.Name AS Category, 
	b.Monday + b.Tuesday + b.Wednesday + b.Thursday + b.Friday + b.Saturday + b.Sunday AS WeeklyBudget,
	SUM(a.Duration) AS Actioned -- To be corrected. Time cannot be summed this way.
FROM TASK t
LEFT JOIN Category c ON t.Category_ID = c.CategoryID
LEFT JOIN Budget b ON t.TaskID = b.Task_ID
LEFT JOIN Activity a on t.TaskID = a.Task_ID
WHERE a.StartTime > GETDATE() - DATEPART(dw,getdate()) + 1 -- Start time greater than Monday this week


SET DATEFIRST 1; -- 1 for Monday as the first day of the week or 7 for Sunday as the first day of the week
SELECT DATEPART(dw,getdate()) as 'nth day of the week'

