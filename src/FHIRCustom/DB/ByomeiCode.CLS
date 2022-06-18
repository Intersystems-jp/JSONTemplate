/// 傷病名マスターサンプル
Class FHIRCustom.DB.ByomeiCode Extends %Persistent
{

/// コード
Property Code As %String;

/// 名称
Property Name As %String;

Index IDKeyIdx On Code [ IdKey, Unique ];

/// データのインポート
/// nmain509.txtを読み込む
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
            if $length(line,""",""")>=6 {
                set obj=..%New()
                set obj.Code=$piece(line,""",""",6)
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
<Data name="ByomeiCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^FHIRCustom.DB.ByomeiCodeD</DataLocation>
<DefaultData>ByomeiCodeDefaultData</DefaultData>
<IdLocation>^FHIRCustom.DB.ByomeiCodeD</IdLocation>
<IndexLocation>^FHIRCustom.DB.ByomeiCodeI</IndexLocation>
<StreamLocation>^FHIRCustom.DB.ByomeiCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
