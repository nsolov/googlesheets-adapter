Class Google.Unittests.TestProduction Extends %UnitTest.TestProduction
{

Parameter PRODUCTION = "GoogleSheets.Demo.Production";

Property SpreadsheetID;

Method CheckResults(ByRef Log As %String, New As %String) As %Status
{
    return $$$OK
}

Method OnBeforeAllTests() As %Status
{
    // start production if not started
    $$$ThrowOnError(##class(Ens.Director).GetProductionStatus(.tProductionName))
    if (..#PRODUCTION '= tProductionName) {
        do ##class(Ens.Director).StartProduction(..#PRODUCTION)
    }

    return $$$OK
}

Method Test09DeleteDocument() As %Status
{
    // delete document
    set msg = ##class(GoogleSheets.Request).%New()
    set msg.Method = "Delete"
    set msg.SpreadsheetId = ..SpreadsheetID
    do ..SendRequest("GoogleSheets.BusinessOperation",msg,.response, 1)
    do $$$AssertEquals(response.Document.deleted, 1, "Document deleted")
}

Method Test01CreateDocument()
{
    set msg = ##class(GoogleSheets.Request).%New()
    set msg.Method = "AppendRow"
    set msg.Range = "Sheet1!A1:B3"
    set msg.Data = [[123,234,345],["=1+2","text","12/31/2023"]]
    set msg.Filename = "TestDocument"
    do ..SendRequest("GoogleSheets.BusinessOperation",msg,.response, 1)
    set doc = response.Document
    do $$$AssertNotEquals(doc.spreadsheetId, "", "Document created")
    set ..SpreadsheetID = doc.spreadsheetId
}

Method Test02GetMetadata()
{
    set msg = ##class(GoogleSheets.Request).%New()
    set msg.SpreadsheetId = ..SpreadsheetID
    set msg.Method = "GetMetadata"
    do ..SendRequest("GoogleSheets.BusinessOperation",msg,.response, 1)
    do $$$AssertEquals(response.GetDocument().properties.title, "TestDocument", "Get Document Title")
}

Method Test03GetValues1()
{
    set msg = ##class(GoogleSheets.Request).%New()
    set msg.SpreadsheetId = ..SpreadsheetID
    set msg.Method = "GetValues"
    set msg.Data = {"range":"Sheet1!A1:C2"}
    do ..SendRequest("GoogleSheets.BusinessOperation",msg,.response, 1)
    set data = response.Document
    do $$$AssertEquals(data.%Get(0).%Get(0), 123, "Get Int Value")
    do $$$AssertEquals(data.%Get(1).%Get(0), 3, "Get Sum Value")
    do $$$AssertEquals(data.%Get(1).%Get(2), "12/31/2023", "Get Date")
}

Method Test04Update()
{
    set msg = ##class(GoogleSheets.Request).%New()
    set msg.SpreadsheetId = ..SpreadsheetID
    set msg.Method = "UpdateRow"
    set msg.Range = "Sheet1!A1:B1"
    set msg.Data = [[1000,2000]]
    do ..SendRequest("GoogleSheets.BusinessOperation",msg,.response, 1)
    set doc = response.Document
    do $$$AssertNotEquals(doc.spreadsheetId, "", "Document updated")
}

Method Test05GetValues2()
{
    set msg = ##class(GoogleSheets.Request).%New()
    set msg.SpreadsheetId = ..SpreadsheetID
    set msg.Method = "GetValues"
    set msg.Data = {"range":"Sheet1!A1:C1"}
    do ..SendRequest("GoogleSheets.BusinessOperation",msg,.response, 1)
    set data = response.Document
    do $$$AssertEquals(data.%Get(0).%Get(0), 1000, "A1 Changed value")
    do $$$AssertEquals(data.%Get(0).%Get(1), 2000, "B1 Changed value")
    do $$$AssertEquals(data.%Get(0).%Get(2), 345, "C1 unchanged Value")
}

}
