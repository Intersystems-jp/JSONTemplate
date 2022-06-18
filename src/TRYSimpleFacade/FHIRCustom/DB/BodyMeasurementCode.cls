/// 看護実践用語標準マスターサンプル
Class FHIRCustom.DB.BodyMeasurementCode Extends %Persistent
{

/// コード
Property Code As %String;

/// 名称
Property Name As %String;

/// Unit
Property Unit As %String;

Index IDKeyIdx On Code [ IdKey, Unique ];

Index NameUnitIdx On (Name, Unit);

/// データのインポート
///   MEDISの看護実践用語標準マスターからインポート
/// https://www2.medis.or.jp/master/kango/index.html
/// https://www2.medis.or.jp/master/kango/kansatsu/kansatsu-ver.3.6.txt
///     観察名称管理番号 Code ... 2カラム目
///     観察名称 Name ... 12カラム目
///     単位 Unit ... 21カラム目 
ClassMethod ImportData(filename As %String) As %Status
{
    set ret=$$$OK
    try {
        do ..%KillExtent()
        set file=##class(%Stream.FileCharacter).%New()
        set ret=file.LinkToFile( filename )
        set file.TranslateTable="UTF8"
        quit:$$$ISERR(ret)
        //最初のヘッダ行読み飛ばし
        do file.ReadLine()
        while 'file.AtEnd {
            set line=file.ReadLine()
            if $length(line,",")>=46 {
                set obj=..%New()
                set obj.Code=$piece(line,",",2)
                set obj.Name=$piece(line,",",12)
                set obj.Unit=$piece(line,",",21)
                set ret=obj.%Save()
                /* 31002406、31002407、31002408　がユニーク属性でエラーになるため3件入らない
                if $$$ISERR(ret) {
                    write $system.Status.GetErrorText(ret)
                }
                */
            }
        }

    } catch err {
        set ret=err.AsStatus()
    }
    quit ret
}

Storage Default
{
<Data name="BodyMeasurementCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Unit</Value>
</Value>
</Data>
<DataLocation>^FHIRCustom.DB.BodyMeasureE7ECD</DataLocation>
<DefaultData>BodyMeasurementCodeDefaultData</DefaultData>
<IdLocation>^FHIRCustom.DB.BodyMeasureE7ECD</IdLocation>
<IndexLocation>^FHIRCustom.DB.BodyMeasureE7ECI</IndexLocation>
<StreamLocation>^FHIRCustom.DB.BodyMeasureE7ECS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
