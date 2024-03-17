Class GoogleSheets.Demo.BusinessService Extends Ens.BusinessService
{

Parameter ADAPTER = "GoogleSheets.InboundAdapter";

Method OnProcessInput(pInput As Google.JSONContainer, Output pOutput As %RegisteredObject) As %Status
{
    set row = pInput.GetDocument()
    set sum = 0
    set iter = row.%GetIterator()
    while iter.%GetNext(.i, .val) {
        if ( (i+1) = ..Adapter.IDColumn ) {
            continue
        }
        set sum = sum + val
    }
    set newRow = [(sum),($zdt($now()))]
    set tRequest = ##class(GoogleSheets.Request).%New()
    set tRequest.SpreadsheetId = pInput.GetMeta()."SpreadsheetId"
    set tRequest.Method = "AppendRow"
    set tRequest.Range = "newSheet"
    set tRequest.Data = [(newRow)]
    return ..SendRequestAsync("GoogleSheets.BusinessOperation", tRequest)
}

}
