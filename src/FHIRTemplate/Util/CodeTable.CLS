Class FHIRTemplate.Util.CodeTable [ Abstract ]
{

Property code As %String;

Property display As %String;

/// コード値からインスタンスを取得
ClassMethod GetByCode(code As %String) As FHIRTemplate.DataType.CodeableConceptBase
{
    quit $classmethod(..%ClassName(1),"%OpenId",code)
}

/// InsertCodeに設定されたデータを登録
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

/// CodeTableを継承した全クラスのデータを登録
ClassMethod GenerateAll() As %Status
{
  set rs=##class(%ResultSet).%New("%Dictionary.ClassDefinition:SubclassOf")
  set ret=rs.Execute(..%ClassName(1))
  quit:$$$ISERR(ret) ret

  while rs.Next() {
    use 0 write !,rs.GetData(1)_"のデータを登録します"
    set ret=$classmethod(rs.GetData(1),"GenerateData")
    quit:$$$ISERR(ret)
  }
  if $$$ISOK(ret) {
    use 0 write !,"正常に登録されました"
  } else {
    use 0 do $SYSTEM.OBJ.DisplayError(ret)
  }
  quit ret
}

}
