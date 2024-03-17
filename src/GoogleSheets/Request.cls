Class GoogleSheets.Request Extends Ens.Request
{

Property Method As %String;

Property Data As %DynamicAbstractObject [ InitialExpression = "{}" ];

Property SpreadsheetId As %String;

Property Range As %String(MAXLEN = "");

Property Filename As %String;

Storage Default
{
<Data name="Data">
<Attribute>Data</Attribute>
<Structure>node</Structure>
<Subscript>"GoogleSheets.Request.Data"</Subscript>
</Data>
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>Method</Value>
</Value>
<Value name="2">
<Value>SpreadsheetId</Value>
</Value>
<Value name="3">
<Value>Range</Value>
</Value>
<Value name="4">
<Value>Filename</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
