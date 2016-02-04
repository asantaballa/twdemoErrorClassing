Use AlsSandbox
Go

Set NOCOUNT On
Go

If OBJECT_ID(N'tempdb..#ErrClass', N'U') Is Not Null
  Drop Table #ErrClass
Go

Select 
  e.ErrorLogId
, ErrorMatchPatternID = ecp.Id
, ecp.Level
Into #ErrClass
From ErrorLog e
Left Outer Join ErrorMatchPatterns ecp On e.Message Like ecp.Pattern
--(
--	Select Top 1 *
--	From ErrorMatchPatterns ecp 
--	Where e.Message Like ecp.Pattern
--) ecp2 On e.Message Like ecp2.Pattern

-- Simple query --

--Select top 100 
--  ec.ErrorLogId
--, ecp.ID
--, ecp.Pattern
--, e.Message 
--From ErrorLog e 
--Left Outer Join #ErrClass			ec	On ec.ErrorLogId = e.ErrorLogId
--Left Outer Join ErrorMatchPatterns	ecp	On ecp.ID = ec.ErrorMatchPatternID

-- Sumamry Query --


Select 
  Pattern
, Count(*)
, Replicate('|', Count(*) / 1)
From
(
	Select 
	  ec.ErrorLogId
	, ecp.ID
	, ecp.Pattern
	, e.Message 
	From ErrorLog e 
	Left Outer Join #ErrClass			ec	On ec.ErrorLogId = e.ErrorLogId
	Left Outer Join ErrorMatchPatterns	ecp	On ecp.ID = ec.ErrorMatchPatternID
) e
Group by Pattern