Class FHIRTemplate.Util.CodeTable [ Abstract ]
{

Property code As %String;

Property display As %String;

ClassMethod GetByCode(code As %String) As FHIRTemplate.DataType.CodeableConceptBase
{
    quit $classmethod(..%ClassName(1),"%OpenId",code)
}

/// コードからインスタンスを取得
/// データ生成
ClassMethod GenerateData() As %Status
{
    set stream=##class(%Dictionary.CompiledXData).%OpenId(..%ClassName(1)_"||InsertCode").Data
    set data={}.%FromJSON(stream)

    do ..%KillExtent()
    set iter=data.data.%GetIterator()
    while iter.%GetNext(.k,.line) {
        set obj=$method($this,"%New")
        set obj.code=$piece(line,";",1),obj.display=$piece(line,";",2)
        do $method(obj,"%Save")
    }
    quit $$$OK
}

}
