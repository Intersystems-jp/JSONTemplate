Include %occErrors

Class JSONTemplate.Base Extends %RegisteredObject [ Abstract, DependsOn = JSONTemplate.Generator ]
{

/// JSON出力する際のテンプレート
/// JSONの値に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// #(..プロパティ名(テンプレート名))#を指定すると、特定のプロパティに対して
/// テンプレートとして使用するクラスを指定できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
XData Template [ MimeType = application/json ]
{
{}
}

Parameter %JSONENABLED = 1;

/// 標準デバイスへの出力
Method OutputToDevice() As %Status
{
    set ret=$$$OK
    try {
        set ret=..OutputToDynamicObject(.tpl)
        quit:$$$ISERR(ret)

        // フォーマット出力
        set out=##class(%JSON.Formatter).%New()
        set out.Indent=1
        set ret=out.Format(tpl)
    } catch err {
        set ret=err.AsStatus()
    }
    quit ret
}

/// ファイルへの出力
Method OutputToFile(filename As %String, charset As %String = "UTF8") As %Status
{
    set ret=$$$OK
    try {
        set ret=..OutputToDynamicObject(.tpl)
        quit:$$$ISERR(ret)

        open filename:("WNS"_$select(charset'="":"K\"_charset_"\",1:"")):5
        if '$test {
            set ret=$$$ERROR($$$FileCanNotOpen,filename)
            quit
        }

        #dim out as %JSON.Formatter
        set out=##class(%JSON.Formatter).%New()
        set out.Indent=1

        use filename
        set ret=out.Format(tpl)
    } catch err {
        set ret=err.AsStatus()
    }
    close filename
    quit ret
}

/// ストリームへの出力
Method OutputToStream(stream As %Stream) As %Status
{
    set ret=$$$OK
    try {
        set ret=..OutputToDynamicObject(.tpl)
        quit:$$$ISERR(ret)

        do tpl.%ToJSON(stream)
    } catch err {
        set ret=err.AsStatus()
    }
    quit ret
}

/// ダイナミックオブジェクトへの出力
Method OutputToDynamicObject(ByRef obj As %DynamicAbstractObject) As %Status
{
    set ret=$$$OK
    set obj=..Process($this,.ret)
    quit ret
}

/// テンプレートからJSONデータを出力
/// テンプレートを元にプロパティを挿入したJSONオブジェクトを返す
ClassMethod Process(obj As %RegisteredObject, ByRef ret As %Status) As %DynamicAbstractObject [ CodeMode = objectgenerator ]
{
    // Abstractクラスの場合は生成しない
    if %class.Abstract {
        do %code.WriteLine(" set ret=$$$NotImplemented quit """"")
        quit $$$OK
    }
    set ret=$$$OK,lineno=0
    try {
        set %debug=$get(%debug,0)
        // プロパティの一覧と型を取得
        set generator=##class(JSONTemplate.Generator).%New()
        set ret=generator.GetPropertyList(%compiledclass)
        quit:$$$ISERR(ret)

        // パラメータの一覧を取得
        set key="" for {
            set pdef=%compiledclass.Parameters.GetNext(.key)
            quit:key=""
            set generator.params(pdef.Name)=$lb(pdef.Default)
        }
        do %code.WriteLine(" set ret=$$$OK try {")

        // OnPreProcess()メソッドがあれば呼び出す
        set mdef=##class(%Dictionary.CompiledMethod).%OpenId(%class.Name_"||OnPreProcess")
        if $isobject(mdef)&&(mdef.Implementation.Size>0) {
            do %code.WriteLine(" set ret=..OnPreProcess(obj) quit:$$$ISERR(ret)")
        }

        // テンプレートを読み込む
        Set compiledXdata=##class(%Dictionary.CompiledXData).%OpenId(%class.Name_"||Template")
        set tplstm=compiledXdata.Data
        do tplstm.Rewind()

        // JSONからオブジェクトを作成
        set tpl={}.%FromJSON(tplstm)
        if 'tpl.%IsA("%DynamicObject") {
            set ret=$$$ERROR(5001,"テンプレートがJSON objectではありません")
            quit
        }
        // JSON出力処理の生成
        //set code=##class(%Stream.TmpCharacter).%New()
        ////set code.TranslateTable="UTF8"
        //do ##class(Generator).InitJSONString()
        set objstr=generator.SetJSONString(tpl)
        set ret=generator.GenerateObject("object",tpl,objstr)
        quit:$$$ISERR(ret)
        do generator.outstream.Rewind()
        while 'generator.outstream.AtEnd {
            set line=generator.outstream.ReadLine()
            if $zstrip(line,"<>W")?1"$tpl"1.N {
                // $tplで始まる行があれば、JSON文字列出力
                write:%debug "line "_line,!
                do %code.WriteLine("  set "_$piece(line,"$",2)_"="_generator.jsonstring(+$piece(line,"$tpl",2)).%ToJSON())
            } else {
                do %code.WriteLine("   "_line)
            }
        }

        do %code.WriteLine(" } catch err { set ret=err.AsStatus() }")
        do %code.WriteLine(" quit $select($$$ISOK(ret):"_objstr_",1:"""")")

    } catch err {
        set ret=$SYSTEM.Status.AppendStatus($$$ERROR(5001,"エラーが発生しました"),err.AsStatus())
    }
    quit ret
}

Method %OnNew(initvalue As %DynamicObject = "") As %Status [ CodeMode = objectgenerator ]
{
    quit:%class.Abstract $$$OK
    do %code.WriteLine(" quit:initvalue="""" $$$OK")
    do %code.WriteLine(" quit:'$isobject(initvalue)||('initvalue.%IsA(""%DynamicObject"")) $$$ERROR(5001,""%DynamicObjectを継承したインスタンスを指定してください"")")
    do %code.WriteLine(" set ret=$$$OK try {")

    set ret=$$$OK
    set key="" for {
        set pdef=%compiledclass.Properties.GetNext(.key)
        quit:key=""
        continue:pdef.Name["%"

        set tdef=##class(%Dictionary.ClassDefinition).%OpenId(pdef.Type,,.ret)
        if $isobject(tdef) {
            if $classmethod(pdef.Type,"%Extends","JSONTemplate.Base") {
                if pdef.Collection'="" {
                    do %code.WriteLine(" if $isobject(initvalue."_pdef.Name_") { if 'initvalue."_pdef.Name_".%Extends(""%Library.DynamicArray"") { set ret=$$$ERROR(5001,""プロパティ"_pdef.Name_"はリストコレクションです"") quit }")
                    do %code.WriteLine("   set iter=initvalue."_pdef.Name_".%GetIterator() while iter.%GetNext(.mkey,.mval) { do:$isobject(mval) .."_pdef.Name_".Insert(##class("_pdef.Type_").%New(mval)) }}")
                } else {
                    do %code.WriteLine(" set:$isobject(initvalue."_pdef.Name_") .."_pdef.Name_"=##class("_pdef.Type_").%New(initvalue."_pdef.Name_")")
                }
            } else {
                if pdef.Collection'="" {
                    do %code.WriteLine(" if $isobject(initvalue."_pdef.Name_") { if 'initvalue."_pdef.Name_".%Extends(""%Library.DynamicArray"") { set ret=$$$ERROR(5001,""プロパティ"_pdef.Name_"はリストコレクションです"") quit }")
                    do %code.WriteLine("   set iter=initvalue."_pdef.Name_".%GetIterator() while iter.%GetNext(.mkey,.mval) { do .."_pdef.Name_".Insert(mval) }}")
                } else {
                    do %code.WriteLine(" set:initvalue.%IsDefined("""_pdef.Name_""") .."_pdef.Name_"=initvalue."_pdef.Name)
                }
            }
        } else {
            set ret=$$$ERROR(5001,"プロパティ"_pdef.Name_"の型"_pdef.Type_"がありません")
            quit
        }
        quit:$$$ISERR(ret)
    }
    do %code.WriteLine("} catch err {")
    do %code.WriteLine("    set ret=err.AsStatus()")
    do %code.WriteLine("} quit ret")
    quit ret
}

/// コード文字列からインスタンスを取得
/// 継承先にて実装
ClassMethod GetByCode(code As %String) As JSONTemplate.Base [ Abstract ]
{
	quit ""
}

/// JSON出力前処理
/// JSONを出力する前に実行されるコールバック
ClassMethod OnPreProcess(obj As JSONTemplate.Base) As %Status
{
}

}
