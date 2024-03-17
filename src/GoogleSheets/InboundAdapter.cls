Class GoogleSheets.InboundAdapter Extends Ens.InboundAdapter
{

Property SpreadsheetId As %String;

Property SheetTitle As %String;

/// full path to the file
Property KeyFile As %String(MAXLEN = "");

/// Column with unique values
Property IDColumn As %Integer;

/// comma separated list
Property RequiredColumns As %String;

Parameter SETTINGS As %String = "KeyFile:Google,SpreadsheetId:Google,SheetTitle:Google,IDColumn:Google,RequiredColumns:Google";

Property GoogleSheetsService As Google.GoogleSheets [ Private ];

Method SetRowProcessed(id As %Integer) As %Integer [ Private ]
{
    set ^GoogleSheetsAdapter(..SpreadsheetId, ..SheetTitle, id) = 1
    return id
}

Method IsRowProcessed(id As %Integer) As %Boolean [ Private ]
{
    return $get(^GoogleSheetsAdapter(..SpreadsheetId, ..SheetTitle, id),0)
}

Method CheckRequiredFields(row As %DynamicArray) As %Boolean
{
    set l = $listfromstring(..RequiredColumns,",")
    for i=1:1:$listlength(l) {
        if (row.%Get($list(l,i)-1) = "") {
            return 0
        }
    }
    return 1
}

Method OnInit() As %Status
{
    if (..KeyFile = "") {
        return $$$ERROR(5001, "KeyFile required")
    }
    if (..SpreadsheetId = "") {
        return $$$ERROR(5001, "SpreadsheetId required")
    }
    if (..SheetTitle = "") {
        return $$$ERROR(5001, "SheetTitle required")
    }
    if (..IDColumn = "") {
        return $$$ERROR(5001, "ID Column required")
    }
    if (..RequiredColumns '="") {
        // all values must be integer
        set l = $listfromstring(..RequiredColumns,",")
        for i=1:1:$listlength(l) {
            if ('$ISVALIDNUM($listget(l,i),,0)) {
                return $$$ERROR(5001, "RequiredColumns - Invalid format")
            }
        }
    }
    try {
        set ..GoogleSheetsService = ##class(Google.GoogleSheets).%New(..KeyFile)
    } catch ex {
        return ex.AsStatus()
    }
    return $$$OK
}

Method OnTask() As %Status
{
    $$$TRACE("On Task")

    set range = ..SheetTitle

    // get all data from the sheet
    set result = ..GoogleSheetsService.GetValues(..SpreadsheetId, range)

    try {
        set iter = result.%GetIterator()
        while iter.%GetNext(.key, .row) {
            set id = row.%Get(..IDColumn-1)
            if (id = "") {
                // check if IDColumn is empty - skip
                continue
            }
            if ( ..IsRowProcessed(id) ) {
                // row already processes - skip
                continue
            }
            if ( '..CheckRequiredFields(row)) {
                // not all required fields filledin - skip
                continue
            }
            set meta = {
                "SpreadsheetId": (..SpreadsheetId),
                "SheetTitle":(..SheetTitle)
            }
            set msg = ##class(Google.JSONContainer).%New(row, meta)
            $$$ThrowOnError( ..BusinessHost.ProcessInput(msg) )
            do ..SetRowProcessed(id)
        }
    } catch ex {
        return ex.AsStatus()
    }
    return $$$OK
}

}
