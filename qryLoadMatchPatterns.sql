Use AlsSandbox 
Go

Set NOCOUNT On
Go


If OBJECT_ID(N'ErrorMatchPatterns', N'U') Is Not Null
  Drop Table ErrorMatchPatterns
Go

CReate Table  ErrorMatchPatterns 
( Id			Int		Identity 
, Pattern		Varchar(128)
)

Insert Into ErrorMatchPatterns (Pattern)
Values
  ('No setup for period %')
, ('Security violation detected user %, access %')

Select * From ErrorMatchPatterns
