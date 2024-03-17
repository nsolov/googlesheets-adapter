/// basic operations with files
Class Google.GoogleDrive Extends Google.Service
{

Parameter SCOPE = "https://www.googleapis.com/auth/spreadsheets;https://www.googleapis.com/auth/drive.file";

Parameter SERVICENAME = "drive";

Parameter SERVICEVERSION = "v3";

/// share file with a user
Method ShareUser(fileId As %String, role As %String, email As %String) As %DynamicObject [ Language = python ]
{
    user_permission = {
        'type': 'user',
        'role': role,
        'emailAddress': email
    }
    result = self.Service.permissions().create(
                            fileId=fileId,
                            body=user_permission).execute()
    return self.convertToDynamicObject(result)
}

Method ListAllFiles() As %DynamicObject [ Language = python ]
{
    result = self.Service.files().list(pageSize=100, q='', supportsAllDrives=True, includeItemsFromAllDrives=True).execute()
    return self.convertToDynamicObject(result)
}

Method GetMetadata(fileId As %String) As %DynamicObject [ Language = python ]
{
    result = self.Service.files().get_media(fileId=fileId).execute()
    return self.convertToDynamicObject(result)
}

Method Delete(fileId As %String) As %Boolean [ Language = python ]
{
    result = self.Service.files().delete(fileId=fileId).execute()
    return True
}

}
