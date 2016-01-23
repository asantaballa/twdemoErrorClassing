Drop Table #Errs
Drop Table #Patterns
Go

Create Table #Errs
(
  ErrorLogId	Int				Identity
, Message		Varchar(128) 
, ErrorDateTime	DateTime2
--, RandVal		Float
--, SelectedId	Int
)

CReate Table  #Patterns 
( Id			Int		Identity 
, Pattern		Varchar(128)
, NumDesired	Int
, Percentage	Float
, RandLow		Float
, RandHigh		Float
)

Insert Into #Patterns
( Pattern
, NumDesired
)
Values
  ( 'No row at location 0', 5)
, ( 'Error {n} returned from communicating with outside service', 20)
, ( 'No setup for period {d}', 1000)
, ( 'Unable to communicate with device {n2}, error {n}', 25)
, ( 'Security violation detected user {n}, access {n2}', 10)

Update #Patterns
Set 
  Percentage = Cast(NumDesired As Float) / (Select Sum(NumDesired) From #Patterns ptot)

Update #Patterns
Set 
  RandLow = IsNull((Select Sum(Percentage) From #Patterns p Where p.Id < #Patterns.Id), 0) 
, RandHigh = IsNull((Select Sum(Percentage) From #Patterns p Where p.Id < #Patterns.Id), 0) + #Patterns.Percentage

--Select * From #Patterns

Declare @CntGenned Int = 0
Declare @RandVal Float

While @CntGenned <= (Select Sum(NumDesired) from #Patterns)
Begin
	Set @RandVal = Rand()

	Declare @SelectedId Int = (Select Top 1 Id From #Patterns p Where @RandVal Between p.RandLow and p.RandHigh Order by Id)

	Declare @Pattern Varchar(128) = (Select p.Pattern From #Patterns p Where p.Id = @SelectedId)
	Set @Pattern = Replace(@Pattern, '{n}', Cast(Round(Rand() * 100, 0) As Varchar(16)))  
	Set @Pattern = Replace(@Pattern, '{n2}', Cast(Round(Rand() * 100, 0) As Varchar(16)))  
	Set @Pattern = Replace(@Pattern, '{d}', Cast(GetDate() As Varchar(32)))  

	Insert Into #Errs
	( Message
	, ErrorDateTime
	)
	Select 
	  @Pattern
	, SysDateTime();

	Set @CntGenned = @CntGenned + 1
End

Select * From #Errs



