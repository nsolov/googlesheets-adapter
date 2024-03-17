Class Google.Service Extends %RegisteredObject [ Abstract ]
{

Property Service;

Property KeyFile;

Parameter SCOPE;

Parameter SERVICENAME;

Parameter SERVICEVERSION;

Method %OnNew(keyFile As %String) As %Status
{
    set ..KeyFile = keyFile
    do ..InitService()
    return $$$OK
}

Method InitService() As %Status [ Language = python ]
{
    import json
    from oauth2client.service_account import ServiceAccountCredentials
    from googleapiclient.discovery import build

    scope = []
    scope_string = self._GetParameter('SCOPE')
    scopeparts = map(lambda s: s.strip(), scope_string.split(';'))
    for part in scopeparts:
        scope.append(part)
    credentials = ServiceAccountCredentials.from_json_keyfile_name(self.KeyFile, scope)
    self.Service = build(self._GetParameter('SERVICENAME') , self._GetParameter('SERVICEVERSION') , credentials = credentials)

    return 1
}

Method convertFromDynamicObject(dyobj As %DynamicObject) As %SYS.Python [ Language = python ]
{
    import json

    json_string = dyobj._ToJSON()
    return json.loads(json_string)
}

Method convertToDynamicObject(pyo As %SYS.Python) As %DynamicObject [ Language = python ]
{
    import json
    import iris

    json_string = json.dumps(pyo)
    dynobj = iris.cls("%DynamicObject")._New()
    return dynobj._FromJSON(json_string)
}

}
