Use AlsSandbox
Go

Set NOCOUNT On
Go

If OBJECT_ID(N'ErrorLog', N'U') Is Not Null
  Drop Table ErrorLog

If OBJECT_ID(N'ErrorLogGenPatterns', N'U') Is Not Null
  Drop Table ErrorLogGenPatterns

Go

Create Table ErrorLog
(
  ErrorLogId	Int				Identity
, Message		Varchar(128) 
, ErrorDateTime	DateTime2
--, RandVal		Float
--, SelectedId	Int
)

CReate Table  ErrorLogGenPatterns 
( Id			Int		Identity 
, Pattern		Varchar(128)
, NumDesired	Int
, Percentage	Float
, RandLow		Float
, RandHigh		Float
)

Insert Into ErrorLogGenPatterns
( Pattern
, NumDesired
)
Values
  ( 'No row at location 0', 5)
, ( 'Error {n} returned from communicating with outside service', 20)
, ( 'No setup for period {d}', 12)
, ( 'Unable to communicate with device {n2}, error {n}', 25)
, ( 'Security violation detected user {n}, access {n2}', 10)

Update ErrorLogGenPatterns
Set 
  Percentage = Cast(NumDesired As Float) / (Select Sum(NumDesired) From ErrorLogGenPatterns ptot)

Update ErrorLogGenPatterns
Set 
  RandLow = IsNull((Select Sum(Percentage) From ErrorLogGenPatterns p Where p.Id < ErrorLogGenPatterns.Id), 0) 
, RandHigh = IsNull((Select Sum(Percentage) From ErrorLogGenPatterns p Where p.Id < ErrorLogGenPatterns.Id), 0) + ErrorLogGenPatterns.Percentage

--Select * From ErrorLogGenPatterns

Declare @CntGenned Int = 0
Declare @RandVal Float

While @CntGenned <= (Select Sum(NumDesired) from ErrorLogGenPatterns)
Begin
	Set @RandVal = Rand()

	Declare @SelectedId Int = (Select Top 1 Id From ErrorLogGenPatterns p Where @RandVal Between p.RandLow and p.RandHigh Order by Id)

	Declare @Pattern Varchar(128) = (Select p.Pattern From ErrorLogGenPatterns p Where p.Id = @SelectedId)
	Set @Pattern = Replace(@Pattern, '{n}', Cast(Round(Rand() * 100, 0) As Varchar(16)))  
	Set @Pattern = Replace(@Pattern, '{n2}', Cast(Round(Rand() * 100, 0) As Varchar(16)))  
	Set @Pattern = Replace(@Pattern, '{d}', Cast(GetDate() As Varchar(32)))  

	Insert Into ErrorLog
	( Message
	, ErrorDateTime
	)
	Select 
	  @Pattern
	, SysDateTime();

	Set @CntGenned = @CntGenned + 1
End

Select Top 1000 * From ErrorLog




