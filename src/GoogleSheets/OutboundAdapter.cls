Include Ensemble

Class GoogleSheets.OutboundAdapter Extends Ens.OutboundAdapter
{

Property KeyFile As %String(MAXLEN = "");

Parameter SETTINGS As %String = "KeyFile:Google";

Property GoogleSheetsService As Google.GoogleSheets [ Private ];

Property GoogleDriveService As Google.GoogleDrive [ Private ];

Method OnInit() As %Status
{
    if (..KeyFile = "") {
        return $$$ERROR(5001, "KeyFile required")
    }
    try {
        set ..GoogleSheetsService = ##class(Google.GoogleSheets).%New(..KeyFile)
        set ..GoogleDriveService = ##class(Google.GoogleDrive).%New(..KeyFile)
    } catch ex {
        return ex.AsStatus()
    }
    return $$$OK
}

Method GetMetadata(spreadsheetId As %String) As %DynamicAbstractObject
{
    return ..GoogleSheetsService.GetMetadata(spreadsheetId)
}

/// Get values
/// 
/// majorDimension - ROWS/COLUMNS (https://developers.google.com/sheets/api/reference/rest/v4/Dimension)
/// valueRenderOption - FORMATTED_VALUE/UNFORMATTED_VALUE/FORMULA (https://developers.google.com/sheets/api/reference/rest/v4/ValueRenderOption)
/// dateTimeRenderOption - SERIAL_NUMBER/FORMATTED_STRING (https://developers.google.com/sheets/api/reference/rest/v4/DateTimeRenderOption)
Method GetValues(spreadsheetId As %String, range As %String, majorDimension As %String = "ROWS", valueRenderOption As %String = "FORMATTED_VALUE", dateTimeRenderOption As %String = "SERIAL_NUMBER") As %DynamicObject
{
    return ..GoogleSheetsService.GetValues(spreadsheetId, range, majorDimension, valueRenderOption, dateTimeRenderOption)
}

Method GetValuesWithFormat(spreadsheetId As %String, range As %String) As %DynamicAbstractObject
{
    set values = ..GoogleSheetsService.GetValues(spreadsheetId, range)
    set format = ..GoogleSheetsService.GetUserEnteredFormat(spreadsheetId, range)

    set userEnteredFormat = format.sheets.%Get(0).data.%Get(0).rowData

    set result = []
    set rows = values.%GetIterator()
    while rows.%GetNext(.rowkey, .row) {
        set resultRow = []
        set cells = row.%GetIterator()
        while cells.%GetNext(.cellkey, .cell) {
            set resultCell = {
                "value": (cell),
                "userEnteredFormat": (userEnteredFormat.%Get(rowkey).values.%Get(cellkey).userEnteredFormat)
            }
            do resultRow.%Push(resultCell)
        }
        do result.%Push(resultRow)
    }

    return result
}

Method UpdateValues(spreadsheetId As %String, range As %String, newValues As %DynamicArray, valueInputOption As %String = "USER_ENTERED") As %DynamicAbstractObject
{
    return ..GoogleSheetsService.UpdateValues(spreadsheetId, range, newValues, valueInputOption)
}

Method AppendValues(spreadsheetId As %String, range As %String, newValues As %DynamicArray, valueInputOption As %String = "USER_ENTERED") As %DynamicAbstractObject
{
    return ..GoogleSheetsService.AppendValues(spreadsheetId, range, newValues, valueInputOption)
}

/// Delete document
Method DeleteDocument(spreadsheetId As %String) As %Boolean
{
    return ..GoogleDriveService.Delete(spreadsheetId)
}

/// Create document if document doesn't exist
/// returns DocumentID
Method CreateDocument(spreadsheetId As %String, filename As %String, shareWith As %String = "", shareRole As %String = "") As %String [ Private ]
{
    if ( (spreadsheetId = "") || ('..GoogleSheetsService.IsExists(spreadsheetId)) ) {
        set filename = filename
        set spreadsheetId = ..GoogleSheetsService.CreateDocument(filename)

        // share created document with user
        if ( (shareWith'="") && (shareRole'="") ) {
            do ..GoogleDriveService.ShareUser(spreadsheetId, shareRole, shareWith)
        }
    }
    return spreadsheetId
}

/// Create sheet if sheet doesn't exist
Method CreateSheet(spreadsheetId As %String, sheetName As %String) As %Status
{
    set meta = ..GoogleSheetsService.GetMetadata(spreadsheetId)
    set iter = meta.sheets.%GetIterator()
    set found = 0
    while iter.%GetNext(.key, .value) {
        if (value.properties.title = sheetName) {
            set found = 1
        }
    }
    if ('found) {
        do ..GoogleSheetsService.AddSheet(spreadsheetId,sheetName)
    }
    return $$$OK
}

/// Replaces values in the spreadsheet
/// If spreadsheet doesn't exist - creates it
/// 
/// valueInputOption - USER_ENTERED/RAW (https://developers.google.com/sheets/api/reference/rest/v4/ValueInputOption)
/// shareWith, shareRole, filename - used only if spreadsheetId doesn't exist
/// filename - name of new spreadsheet
Method UpdateOrCreate(spreadsheetId As %String, range As %String, newValues As %DynamicArray, valueInputOption As %String = "USER_ENTERED", shareWith As %String = "", shareRole As %String = "", filename As %String = "iris_spreadsheet") As %DynamicArray
{
    // if document doesn't exist - create it
    set spreadsheetId = ..CreateDocument(spreadsheetId, filename, shareWith, shareRole)

    // if sheet doesn't exist - create it
    set sheetName = $piece(range,"!")
    if (sheetName = "") {
        $$$ThrowStatus($$$ERROR(5001, "Range must include sheetName"))
    }
    do ..CreateSheet(spreadsheetId, sheetName)

    // update data
    return ..UpdateValues(spreadsheetId, range, newValues, valueInputOption)
}

/// Add rows to the spreadsheet
/// If spreadsheet doesn't exist - creates it
/// 
/// valueInputOption - USER_ENTERED/RAW (https://developers.google.com/sheets/api/reference/rest/v4/ValueInputOption)
/// shareWith, shareRole, filename - used only if spreadsheetId doesn't exist
/// filename - name of new spreadsheet
Method AppendOrCreate(spreadsheetId As %String, range As %String, newValues As %DynamicArray, valueInputOption As %String = "USER_ENTERED", shareWith As %String = "", shareRole As %String = "", filename As %String = "iris_spreadsheet") As %DynamicArray
{
    // if document doesn't exist - create it
    set spreadsheetId = ..CreateDocument(spreadsheetId, filename, shareWith, shareRole)

    // if sheet doesn't exist - create it
    set sheetName = $piece(range,"!")
    if (sheetName = "") {
        set sheetName = "Sheet1"
    }
    do ..CreateSheet(spreadsheetId, sheetName)

    // append data
    return ..AppendValues(spreadsheetId, range, newValues, valueInputOption)
}

}
