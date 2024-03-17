Class GoogleSheets.BusinessOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "GoogleSheets.OutboundAdapter";

Property Adapter As GoogleSheets.OutboundAdapter;

Parameter SETTINGS As %String = "SpreadsheetId:Google,MajorDimension:Google,ValueInputOption:Google,ValueRenderOption:Google,DateTimeRenderOption:Google,ShareWith:Google,ShareRole:Google";

Property SpreadsheetId As %String;

/// ROWS/COLUMNS
Property MajorDimension As %String(VALUELIST = ",ROWS,COLUMNS") [ InitialExpression = "ROWS" ];

/// valueInputOption RAW/USER_ENTERED
Property ValueInputOption As %String(VALUELIST = ",RAW,USER_ENTERED") [ InitialExpression = "USER_ENTERED" ];

Property ValueRenderOption As %String(VALUELIST = ",FORMATTED_VALUE,UNFORMATTED_VALUE,FORMULA") [ InitialExpression = "FORMATTED_VALUE" ];

Property DateTimeRenderOption As %String(VALUELIST = ",SERIAL_NUMBER,FORMATTED_STRING") [ InitialExpression = "SERIAL_NUMBER" ];

/// Email of the user to share a new document with
Property ShareWith As %String;

/// Role of the user
Property ShareRole As %String(VALUELIST = ",owner,organizer,fileOrganizer,writer,commenter,reader") [ InitialExpression = "reader" ];

Method GoogleSheetsCall(pRequest As GoogleSheets.Request, Output pResponse As Google.JSONContainer) As %Status
{
    set spreadsheetId = pRequest.SpreadsheetId
    if (spreadsheetId = "") {
        set spreadsheetId = ..SpreadsheetId
    }
    if (pRequest.Method = "GetMetadata") {
        set pResponse = ##class(Google.JSONContainer).%New(..Adapter.GetMetadata(spreadsheetId))
    } elseif (pRequest.Method = "GetValues") {
        try {
            set range = pRequest.Data.range
            set majorDimension = pRequest.Data.majorDimension
            if (majorDimension = "") {
                set majorDimension = ..MajorDimension
            }
            set valueRenderOption = pRequest.Data.valueRenderOption
            if (valueRenderOption = "") {
                set valueRenderOption = ..ValueRenderOption
            }
            set dateTimeRenderOption = pRequest.Data.dateTimeRenderOption
            if (dateTimeRenderOption = "") {
                set dateTimeRenderOption = ..DateTimeRenderOption
            }
        } catch ex {
            return $$$ERROR(5001, "pRequest.Data must be a valid json object, range field is required")
        }
        set responseData = ..Adapter.GetValues(spreadsheetId, range, majorDimension, valueRenderOption, dateTimeRenderOption)
        set pResponse = ##class(Google.JSONContainer).%New(responseData)

    } elseif (pRequest.Method = "AppendRow") {
        set responseData = ..Adapter.AppendOrCreate(spreadsheetId, pRequest.Range, pRequest.Data, ..ValueInputOption, ..ShareWith, ..ShareRole, pRequest.Filename )
        set pResponse = ##class(Google.JSONContainer).%New(responseData)
    } elseif (pRequest.Method = "UpdateRow") {
        set responseData = ..Adapter.UpdateOrCreate(spreadsheetId, pRequest.Range, pRequest.Data, ..ValueInputOption, ..ShareWith, ..ShareRole, pRequest.Filename )
        set pResponse = ##class(Google.JSONContainer).%New(responseData)
    } elseif (pRequest.Method = "Delete") {
        set responseData = ..Adapter.DeleteDocument(spreadsheetId)
        set pResponse = ##class(Google.JSONContainer).%New({"deleted":(responseData)})
    }
    return $$$OK
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="GoogleSheets.Request">
    <Method>GoogleSheetsCall</Method>
  </MapItem>
</MapItems>
}

}
