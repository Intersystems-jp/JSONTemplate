/// 修飾語交換用コードテーブルサンプル
Class FHIRCustom.DB.ModifierCode Extends %Persistent
{

/// コード
Property Code As %String;

/// 名称
Property Name As %String;

Index IDKeyIdx On Code [ IdKey, Unique ];

/// データのインポート
/// mdfy509.txtを読み込む
ClassMethod ImportData(filename As %String) As %Status
{
    set ret=$$$OK
    try {
        do ..%KillExtent()
        set file=##class(%Stream.FileCharacter).%New()
        set ret=file.LinkToFile( filename )
        quit:$$$ISERR(ret)

        while 'file.AtEnd {
            set line=file.ReadLine()
            if $length(line,""",""")>=5 {
                set obj=..%New()
                set obj.Code=$piece(line,""",""",5)
                set obj.Name=$piece(line,""",""",3)
                set ret=obj.%Save()
                //quit:$$$ISERR(ret)
            }
        }
    } catch err {
        set ret=err.AsStatus()
    }
    quit ret
}

Storage Default
{
<Data name="ModifierCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^FHIRCustom.DB.ModifierCodeD</DataLocation>
<DefaultData>ModifierCodeDefaultData</DefaultData>
<IdLocation>^FHIRCustom.DB.ModifierCodeD</IdLocation>
<IndexLocation>^FHIRCustom.DB.ModifierCodeI</IndexLocation>
<StreamLocation>^FHIRCustom.DB.ModifierCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
