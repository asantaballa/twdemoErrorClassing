Use AlsSandbox
Go

Set NOCOUNT On
Go

If OBJECT_ID(N'vErrorsClassed', N'V') Is Not Null Drop View vErrorsClassed
Go

Create View vErrorsClassed As
Select 
  ErrorMatchPatternID = ecp.Id
, ecp.Level
, ecp.Pattern
, e.*
From ErrorLog e
Left Outer Join ErrorMatchPatterns ecp	On e.Message Like ecp.Pattern
										And Not Exists
											  (	Select 1
												From ErrorMatchPatterns ecp2
												Where e.Message Like ecp2.Pattern
												  And ecp2.Id < ecp.Id
											  )
