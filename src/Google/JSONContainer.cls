Class Google.JSONContainer Extends %Library.Persistent
{

Property Document As %DynamicAbstractObject;

Property Meta As %DynamicAbstractObject;

Method %OnNew(json As %DynamicAbstractObject = "", meta As %DynamicAbstractObject = "") As %Status
{
    if (json = "") {
        set ..Document = {}
    } else {
        set ..Document = json
    }

    if (meta = "") {
        set ..Meta = {}
    } else {
        set ..Meta = meta
    }

    return $$$OK
}

Method GetDocument() As %DynamicAbstractObject
{
    return ..Document
}

Method GetMeta() As %DynamicAbstractObject
{
    return ..Meta
}

Method GetString() As %String
{
    return ..Document.%ToJSON()
}

Storage Default
{
<Data name="Document">
<Attribute>Document</Attribute>
<Structure>node</Structure>
<Subscript>"Document"</Subscript>
</Data>
<Data name="JSONContainerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="Meta">
<Attribute>Meta</Attribute>
<Structure>node</Structure>
<Subscript>"Meta"</Subscript>
</Data>
<DataLocation>^Google.JSONContainerD</DataLocation>
<DefaultData>JSONContainerDefaultData</DefaultData>
<IdLocation>^Google.JSONContainerD</IdLocation>
<IndexLocation>^Google.JSONContainerI</IndexLocation>
<StreamLocation>^Google.JSONContainerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
