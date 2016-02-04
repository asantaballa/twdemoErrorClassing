Use AlsSandbox 
Go

Set NOCOUNT On
Go


If OBJECT_ID(N'ErrorMatchPatterns', N'U') Is Not Null
  Drop Table ErrorMatchPatterns
Go

CReate Table  ErrorMatchPatterns 
( Id			Int		Identity 
, Level			Int
, Pattern		Varchar(128)
)

Insert Into ErrorMatchPatterns (Level, Pattern)
Values
  (2, 'No setup for period %')
, (2, 'Security violation detected user %, access %')
, (1, 'Attemp to save failed, reason 16%')
, (2, 'Attemp to save failed, reason %')

Select * From ErrorMatchPatterns
