/// JLAC10Codeマスターサンプル
Class FHIRCustom.DB.JLAC10Code Extends %Persistent
{

/// コード
Property Code As %String;

/// 検査名称
Property Name As %String;

/// 販売名
Property BrandName As %String(MAXLEN = 255);

/// 製造販売業者
Property CompanyName As %String(MAXLEN = 255);

Index IDKeyIdx On Code [ IdKey, Unique ];

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
            if $length(line,"|")>=21 {
                set obj=..%New()
                set obj.Code=$translate($piece(line,"|",21),"-","")
                set obj.Name=$piece(line,"|",7)
                set obj.BrandName=$piece(line,"|",4)
                set obj.CompanyName=$piece(line,"|",6)
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
<Data name="JLAC10CodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>BrandName</Value>
</Value>
<Value name="4">
<Value>CompanyName</Value>
</Value>
</Data>
<DataLocation>^FHIRCustom.DB.JLAC10CodeD</DataLocation>
<DefaultData>JLAC10CodeDefaultData</DefaultData>
<IdLocation>^FHIRCustom.DB.JLAC10CodeD</IdLocation>
<IndexLocation>^FHIRCustom.DB.JLAC10CodeI</IndexLocation>
<StreamLocation>^FHIRCustom.DB.JLAC10CodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
