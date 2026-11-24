// UNEXECUTED M SOURCE. Create text parameter WorkbookPath with the full local path of Synthetic_Inputs.xlsx.
// Create this function as fxSheet; every query below is a separate query, not one script.
(sheetName as text) as table =>
let
    Source = Excel.Workbook(File.Contents(WorkbookPath), null, true),
    Data = Source{[Item=sheetName, Kind="Sheet"]}[Data],
    Headers = Table.PromoteHeaders(Data, [PromoteAllScalars=true])
in
    Headers

// Query named DimAgent:
let
    Source = fxSheet("DimAgent"),
    Typed = Table.TransformColumnTypes(Source, {{"AgentKey", Int64.Type}, {"AgentName", type text}, {"Tier", type text}}, "en-US")
in
    Typed

// Query named DimCategory:
let
    Source = fxSheet("DimCategory"),
    Typed = Table.TransformColumnTypes(Source, {{"CategoryKey", Int64.Type}, {"CategoryName", type text}, {"ProductArea", type text}}, "en-US")
in
    Typed

// Query named DimDate:
let
    Source = fxSheet("DimDate"),
    Typed = Table.TransformColumnTypes(Source, {{"Date", type date}, {"Year", Int64.Type}, {"MonthNum", Int64.Type}, {"MonthName", type text}, {"YearMonth", type text}}, "en-US")
in
    Typed

// Query named FactTickets (raw sheet has 3 duplicate rows and 12 CSAT scores of 0):
let
    Source = fxSheet("FactTickets"),
    Typed = Table.TransformColumnTypes(Source, {{"TicketID", type text}, {"OpenedDate", type date}, {"AgentKey", Int64.Type}, {"CategoryKey", Int64.Type}, {"Priority", type text}, {"SLAHours", Int64.Type}, {"Status", type text}, {"ResolutionHours", type number}, {"CSATScore", Int64.Type}}, "en-US"),
    Deduped = Table.Distinct(Typed),
    CSATClean = Table.ReplaceValue(Deduped, 0, null, Replacer.ReplaceValue, {"CSATScore"}),
    SLAMet = Table.AddColumn(CSATClean, "SLAMet", each if [Status] <> "Resolved" then null else if [ResolutionHours] <= [SLAHours] then 1 else 0, Int64.Type)
in
    SLAMet
