Class GoogleSheets.Demo.DemoBP Extends Ens.BusinessProcess
{

Method OnRequest(request As Ens.Request, Output response As %Library.Persistent) As %Status
{
    $$$TRACE("Start process")
    set msg = ##class(GoogleSheets.Request).%New()
    set msg.SpreadsheetId = "1zFE9f72FLdg1wJE1BjwE0jVvLuZ2USPRNbZS4-vFpiA"
    set msg.Method = "GetMetadata"
    return ..SendRequestAsync("GoogleSheets.BusinessOperation",msg,1,msg.Method)
}

Method OnResponse(request As %Library.Persistent, ByRef response As %Library.Persistent, callrequest As %Library.Persistent, callresponse As %Library.Persistent, pCompletionKey As %String) As %Status
{
    $$$TRACE(callresponse.GetValue().%ToJSON())
    return $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
