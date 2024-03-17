/// /irisdev/app/key/pythontest-393906-be088f1f4df8.json
Class Google.GoogleSheets Extends Google.Service
{

Parameter SCOPE = "https://www.googleapis.com/auth/spreadsheets";

Parameter SERVICENAME = "sheets";

Parameter SERVICEVERSION = "v4";

/// Create new Spreadsheet
Method CreateDocument(title As %String) As %String [ Language = python ]
{
    spreadsheet = {
        'properties': {
            'title': title
        }
    }
    spreadsheet = self.Service.spreadsheets().create(body=spreadsheet, fields='spreadsheetId').execute()
    return spreadsheet.get('spreadsheetId')
}

/// Check if Spreadsheet exists
Method IsExists(spreadsheetId As %String) As %Boolean [ Language = python ]
{
    import googleapiclient.errors
    result = True
    try:
        sheet_metadata = self.Service.spreadsheets().get(spreadsheetId=spreadsheetId).execute()
    except googleapiclient.errors.HttpError as inst:
        if ((inst.args[0].status>=400) and (inst.args[0].status<500)):
            result = False
    return result
}

/// Get Spreadsheet Metadata
Method GetMetadata(spreadsheetId As %String) As %DynamicObject [ Language = python ]
{
    try:
        sheet_metadata = self.Service.spreadsheets().get(spreadsheetId=spreadsheetId).execute()
    except Exception as inst:
        print(type(inst))
        print(inst.args[0].status)
        print(inst)
    return self.convertToDynamicObject(sheet_metadata)
}

Method Clear(spreadsheetId As %String, range As %String) As %DynamicObject [ Language = python ]
{
    sheet = self.Service.spreadsheets()
    result = sheet.values().clear(
        spreadsheetId=spreadsheetId,
        range=range).execute()
    return self.convertToDynamicObject(result)
}

/// Add new sheet to the Spreadsheet
Method AddSheet(spreadsheetId As %String, title As %String) As %DynamicObject [ Language = python ]
{
    sheet = self.Service.spreadsheets()
    body = {
        'requests': {
            'addSheet':{
                'properties':{
                    'title': title
                }
            }
        }
    }
    result = sheet.batchUpdate(
        spreadsheetId=spreadsheetId,
        body=body).execute()
    return self.convertToDynamicObject(result)
}

/// Applies one or more updates to the spreadsheet
Method UpdateSpreadsheet(spreadsheetId As %String, requests As %DynamicObject) As %DynamicObject [ Language = python ]
{
    sheet = self.Service.spreadsheets()
    body = {
        'requests': self.convertFromDynamicObject(requests)
    }
    result = sheet.batchUpdate(
        spreadsheetId=spreadsheetId,
        body=body).execute()
    return self.convertToDynamicObject(result)
}

/// Use this method to get UserEnteredFormat of the Cells (sheets/data/rowData/values/userEnteredFormat)
/// It can be used to get URL links from cells
Method GetUserEnteredFormat(spreadsheetId As %String, range As %String) As %DynamicObject [ Language = python ]
{
    result = self.Service.spreadsheets().get(
        spreadsheetId=spreadsheetId,
        ranges=range,
        fields="sheets/data/rowData/values/userEnteredFormat"
    ).execute()
    return self.convertToDynamicObject(result)
}

/// Get Values from range
/// range - value in A1 notation (Sheet1!A1:C4)
/// majorDimension - ROWS/COLUMNS
/// valueRenderOption - FORMATTED_VALUE/UNFORMATTED_VALUE/FORMULA
/// dateTimeRenderOption - SERIAL_NUMBER/FORMATTED_STRING
Method GetValues(spreadsheetId As %String, range As %String, majorDimension As %String = "ROWS", valueRenderOption As %String = "FORMATTED_VALUE", dateTimeRenderOption As %String = "SERIAL_NUMBER") As %DynamicObject [ Language = python ]
{
    sheet = self.Service.spreadsheets()
    result = sheet.values().get(spreadsheetId=spreadsheetId,
                                range=range,
                                majorDimension=majorDimension,
                                valueRenderOption=valueRenderOption,
                                dateTimeRenderOption=dateTimeRenderOption).execute()
    values = result.get('values', [])
    return self.convertToDynamicObject(values)
}

/// Replace existing data in the spreadsheet
/// valueInputOption - RAW/USER_ENTERED
Method UpdateValues(spreadsheetId As %String, range As %String, newValues As %DynamicArray, valueInputOption As %String = "USER_ENTERED") As %DynamicObject [ Language = python ]
{
    sheet = self.Service.spreadsheets()
    body = {
        'values': self.convertFromDynamicObject(newValues)
    }
    result = sheet.values().update(spreadsheetId=spreadsheetId,
                                    range=range,
                                    valueInputOption=valueInputOption,
                                    body=body).execute()
    return self.convertToDynamicObject(result)
}

/// Add new rows
/// valueInputOption - RAW/USER_ENTERED
Method AppendValues(spreadsheetId As %String, range As %String, newValues As %DynamicArray, valueInputOption As %String = "USER_ENTERED") As %DynamicObject [ Language = python ]
{
    sheet = self.Service.spreadsheets()
    body = {
        'values': self.convertFromDynamicObject(newValues)
    }
    result = sheet.values().append(spreadsheetId=spreadsheetId,
                                    range=range,
                                    valueInputOption=valueInputOption,
                                    body=body).execute()
    return self.convertToDynamicObject(result)
}

}
