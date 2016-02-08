-- Simple query --

Select top 1000 * From vErrorsClassed

-- Sumamry Query --

Select 
  Pattern
, ErrorMatchPatternID
, NumMatched = Count(*)
, Graphed = Replicate('|', Count(*) / 1)
From vErrorsClassed
Group By 
  Pattern
, ErrorMatchPatternID

-- Ranked Sumamry Query --

Select 
  * 
, Graphed = Replicate('|', NumMatched / 1)
From
(
	Select 
	  Pattern
	, ErrorMatchPatternID
	, NumMatched = Count(*)
	From vErrorsClassed
	Group By 
	  Pattern
	, ErrorMatchPatternID
) Summary
Order by NumMatched Desc