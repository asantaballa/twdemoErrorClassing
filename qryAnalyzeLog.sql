Use AlsSandbox
Go

Set NOCOUNT On
Go

If OBJECT_ID(N'tempdb..#ErrClass', N'U') Is Not Null Drop Table #ErrClass
Go

-- Classify the errors --

Select 
  e.ErrorLogId
, ErrorMatchPatternID = ecp.Id
, ecp.Level
Into #ErrClass
From ErrorLog e
Left Outer Join ErrorMatchPatterns ecp	On e.Message Like ecp.Pattern
										And Not Exists
											  (	Select 1
												From ErrorMatchPatterns ecp2
												Where e.Message Like ecp2.Pattern
												  And ecp2.Id < ecp.Id
											  )
												  
-- Simple query --

Select top 100 
  ec.ErrorLogId
, ec.ErrorMatchPatternID
, ecp.Pattern
, e.Message 
From ErrorLog e 
Left Outer Join #ErrClass			ec	On ec.ErrorLogId = e.ErrorLogId
Left Outer Join ErrorMatchPatterns	ecp	On ecp.ID = ec.ErrorMatchPatternID

-- Sumamry Query --

Select 
  Pattern
, ErrorMatchPatternID
, NumMatched = Count(*)
, Graphed = Replicate('|', Count(*) / 1)
From
(
	Select 
	  ec.ErrorLogId
	, ec.ErrorMatchPatternID
	, ecp.Pattern
	, e.Message 
	From ErrorLog e 
	Left Outer Join #ErrClass			ec	On ec.ErrorLogId = e.ErrorLogId
	Left Outer Join ErrorMatchPatterns	ecp	On ecp.ID = ec.ErrorMatchPatternID
) e
Group By 
  Pattern
, ErrorMatchPatternID
