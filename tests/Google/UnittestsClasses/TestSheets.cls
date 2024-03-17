Class Google.Unittests.TestSheets Extends %UnitTest.TestCase
{

Parameter KEY = "/irisdev/app/key.json";

Property Adapter;

Property SpreadsheetID;

Method OnBeforeAllTests() As %Status
{
    set ..Adapter = ##class(GoogleSheets.OutboundAdapter).%New()
    set ..Adapter.KeyFile = ..#KEY
    do ..Adapter.OnInit()

    // create Spreadsheet
    set res = ..Adapter.AppendOrCreate("","Sheet1!A1:B3",[[125,"text 1"],[234,"test 2"],[345,"test 2"]])
    set ..SpreadsheetID = res.spreadsheetId
    set res = ..Adapter.AppendOrCreate(..SpreadsheetID,"Sheet1",[[456,"=1+2"]])

    return $$$OK
}

Method OnAfterAllTests() As %Status
{
    set res = ..Adapter.DeleteDocument(..SpreadsheetID)
    return $$$OK
}

Method TestAdapterCreateAppend()
{
    set oa = ..Adapter

    set sheet = "Sheet1"

    // create
    set res = oa.AppendOrCreate("",sheet,[[125,"text"]])
    set id = res.spreadsheetId
    do $$$AssertNotEquals(id,"","New Sheet Created")

    set res = oa.AppendOrCreate(id,sheet,[[255,"text2"]])

    do $$$AssertEquals(res.updates.updatedCells,2,"New Cells Added")

    set res = oa.GetValues(id, sheet)

    do $$$AssertEquals(res.%Size(),2,"2 rows found")

    do $$$AssertEquals(res.%Get(0).%Get(0),125,"value A1")
    do $$$AssertEquals(res.%Get(0).%Get(1),"text","value B1")

    do $$$AssertEquals(res.%Get(1).%Get(0),255,"value A2")
    do $$$AssertEquals(res.%Get(1).%Get(1),"text2","value B2")


    set res = oa.DeleteDocument(id)

    do $$$AssertEquals(res,1,"File deleted")
}

Method TestAdapterCreateUpdate()
{
    set oa = ..Adapter

    set sheet = "Sheet1"

    // create
    set res = oa.UpdateOrCreate("",sheet_"!A1:B1",[[125,"text"]])
    set id = res.spreadsheetId
    do $$$AssertNotEquals(id,"","New Sheet Created")

    set res = oa.UpdateOrCreate(id,sheet_"!A1:B1",[[255,"text2"]])
    do $$$AssertEquals(res.updatedCells, 2, "Cells updated")

    set res = oa.GetValues(id, sheet)

    do $$$AssertEquals(res.%Size(),1,"1 rows found")

    do $$$AssertEquals(res.%Get(0).%Get(0),255,"value A1")
    do $$$AssertEquals(res.%Get(0).%Get(1),"text2","value A2")

    set res = oa.DeleteDocument(id)

    do $$$AssertEquals(res,1,"File deleted")
}

Method TestGet()
{
    set oa = ..Adapter

    set id = ..SpreadsheetID
    set range = "Sheet1!A1:B3"

    set res = oa.GetValues(id,range)
    do $$$AssertEquals(res.%Get(0).%Get(0), 125, "A1 value")
    do $$$AssertEquals(res.%Get(0).%Get(1), "text 1", "B1 value")

    set res = oa.GetValues(id,range,"COLUMNS")
    do $$$AssertEquals(res.%Size(), 2, "Number of columns as rows")
    do $$$AssertEquals(res.%Get(0).%Get(2), 345, "Original A3 value")

    set res = oa.GetValues(id,"Sheet1!B4",,"FORMULA")
    do $$$AssertEquals(res.%Get(0).%Get(0), "=1+2", "Get Formula")
}

}
