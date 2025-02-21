Class JSONTemplate.Generator Extends %RegisteredObject
{

/// 出力データ
Property outstream As %Stream.TmpCharacter;

/// JSON文字列
Property jsonstring [ MultiDimensional ];

/// プロパティ一覧
/// props(プロパティ名)=$lb(プロパティクラス,クライアントデータタイプ,Requiredかどうか,コレクションかどうか,LogicalToDisplayを使用するかどうか)
Property props [ MultiDimensional ];

/// パラメータ一覧
Property params [ MultiDimensional ];

/// JSON出力する処理の生成
/// JSONの値の文字列に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
Method GenerateObject(type As %String, template As %DynamicAbstractObject, path As %String) As %Status
{
    set ret=$$$OK
    try {
        set dynamic=$select(type="array":1,1:0)
        
        // templateのメンバーを順に取り出す
        set iter=template.%GetIterator()
#if $SYSTEM.Version.GetMajor()>2021
        while iter.%GetNext(.mkey,.value,.mtype) {
#Else
        while iter.%GetNext(.mkey,.value) {
            set mtype=$select($isobject(value):$select(value.%IsA("%DynamicArray"):"array",1:"object"),1:"string")
#Endif
             if mtype="object" {
                // メンバーがオブジェクトの場合
                set path2=$select(dynamic:..SetJSONString(value),1:path_"."_$select(type="object":mkey,1:"%Get("_mkey_")"))
                set ret=..GenerateObject("object",value,path2)
                quit:$$$ISERR(ret)
                do:type="object" ..outstream.WriteLine(" do:"_path2_".%Size()=0 "_path_".%Remove("""_mkey_""")")
                do:type="array" ..outstream.WriteLine(" do:"_path2_".%Size()>0 "_path_".%Push("_path2_")")
                continue
            } elseif mtype="array" {
                // メンバーがarray の場合
                // Array部分の生成
                set path2=$select(dynamic:..SetJSONString(value),1:path_"."_$select(type="object":mkey,1:"%Get("_mkey_")"))
                set ret=..GenerateObject("array", value, path2)
                quit:$$$ISERR(ret)
                do:type="object" ..outstream.WriteLine(" do:"_path2_".%Size()=0 "_path_".%Remove("""_mkey_""")")
                do:type="array" ..outstream.WriteLine(" do:"_path2_".%Size()>0 "_path_".%Push("_path2_")")
                continue
            } elseif value'["#("&&(value'[")#") {
                // 固定文字列の場合
                if type="array"&&(dynamic) {
                    do ..OutputValue(value,path_".%Get("_mkey_")")
                }
                continue
            } elseif value="#($this)#" {
                // 現在のインスタンスでデフォルトのテンプレートを使って出力する
                // objectやarray形式の置き換え
                set token=$piece($piece(value,")#"),"#(",2)
                set ret=..GetParamInfo(token,.info)
                quit:$$$ISERR(ret)
                //zw info
                set:'dynamic&&(type="array") dynamic=mkey+1
                do ..OutputObject(info, path_"."_$select(type="object":mkey,1:"%Get("_mkey_")"))
                do template.%Set(mkey,"")
                continue
            } elseif value?1"#("2"."1E1A.AN.1(1"("1(1A.AN).(1"."1A.AN)1")")1")#" {
                // objectやarray形式の置き換え
                set token=$piece($piece(value,")#"),"#(",2)
                set ret=..GetParamInfo(token,.info)
                quit:$$$ISERR(ret)
                //zw info
                set:'dynamic&&(type="array") dynamic=mkey+1
                if $lg(info)="param" {
                    // パラメータの場合
                    if type="array" {
                        do ..OutputParameter($lg(info,2),path_"."_$select(type="object":mkey,1:"%Get("_mkey_")"))
                        do template.%Set(mkey,"")
                    } else {
                        // テンプレートを変更した際にパラメータ値が異なる点を修正
                        //do template.%Set(mkey,$lg(info,3)) // 値を代入してしまう
                        do ..OutputParameter($lg(info,2),path_"."_$select(type="object":mkey,1:"%Get("_mkey_")"))
                        do template.%Set(mkey,"")
                    }
                    continue
                }
                if $lg(info)="prop" {
                    // プロパティの場合
                    if $lg(info,4)="" {
                        // クライアントデータタイプがNULLの場合(型がオブジェクトの場合)
                        do ..OutputObject(info, path_"."_$select(type="object":mkey,1:"%Get("_mkey_")"))
                    } else {
                        do ..OutputProperty(info, path_"."_$select(type="object":mkey,1:"%Get("_mkey_")"))
                    }
                    do template.%Set(mkey,"")
                    continue
                }
                continue
           }
            // 文字列、数字の置き換え
            // 最初に#)がないかをチェック
            set code=""
            set literal=$piece(value,"#(")
            if $length(literal,")#")>1 {
                set ret=$$$ERROR(5001,"「#(」が見つかりません")
                quit
            }
            set code="",codeopen=0
            set:literal'="" code=""""_$replace(literal,"""",""""""),codeopen=1

            // プロパティ、パラメータを抽出
            for v=2:1:$length(value,"#(") {
                set var=$piece(value,"#(",v)
                // )#があることをチェック
                set l=$length(var,")#")
                if l'=2 {
                    set ret=$$$ERROR(5001,"「)#」が"_$select(l>2:"多すぎます",1:"見つかりません"))
                    quit
                }
                set literal=$piece(var,")#",2)
                set var=$piece(var,")#")
                quit:$$$ISERR(ret)
                set ret=..GetParamInfo(var,.info)
                quit:$$$ISERR(ret)
                if $lg(info)="param" {
                    //set code=code_$select(code'=""&&codeopen:"""_",code'="":"_",1:"")_"obj.#"_$lg(info,2),codeopen=0
                    set code=code_$select(code'=""&&codeopen:"",code'="":"_""",1:"""")_$replace($lg(info,3),"""",""""""),codeopen=1
                } elseif $lg(info)="prop" {
                    set code=code_$select(code'=""&&codeopen:"""_",code'="":"_",1:"")_"obj."_$lg(info,2),codeopen=0
                }
                set:literal'="" code=code_$select(code'=""&&codeopen:"",code'="":"_""",1:"""")_$replace(literal,"""",""""""),codeopen=1
            }
            set code=code_$select(codeopen:"""",1:"")
            set:'dynamic&&(type="array") dynamic=mkey+1
            // 出力
            if type="array" {
                do ..outstream.WriteLine(" do "_path_".%Push("_code_")")
            } else {
                do ..outstream.WriteLine(" set "_path_"."_mkey_"="_code)
            }
            do template.%Set(mkey,"")
            quit:$$$ISERR(ret)
#if $SYSTEM.Version.GetMajor()>2021
        }
#else
        }
#endif
        // arrayの場合、ノードを削除
        if type="array" {
            set size=template.%Size()
            for i=0:1:size {
                do template.%Pop()
            }
        }
    } catch err {
        set ret=$SYSTEM.Status.AppendStatus($$$ERROR(5001,"エラーが発生しました"),err.AsStatus())
    }
    quit ret
}

/// 変数の構文解析
/// パラメータやプロパティの属性を取得する
/// info ... $lb("param",paramname,default)
///          $lb("this","",%class.Name,"object")
///          $lb("prop",propname,proptype,classtype,required,collection,displayflg,scale,templateclass)
Method GetParamInfo(token As %String, ByRef info) As %Status
{
    set info=""
    set ret=$$$OK
    try {
        if token="$this" {
            set info=$lb("this","",%class.Name,"object")
        } elseif $extract(token,1,3)="..#" {
            // パラメータ値代入
            set token=$extract(token,4,*)
            write:%debug "パラメータ:",token,!
            // パラメータチェック
            if token="" {
                set ret=$$$ERROR(5001,"パラメータ名が存在しません")
                quit
            }
            if '$data(..params(token),val) {
                set ret=$$$ERROR(5001,"パラメータ「"_token_"」が存在しません")
                quit
            }
            set info=$lb("param",token)_val
        } elseif $extract(token,1,2)=".." {
            set token=$extract(token,3,*)
            // パラメータチェック
            write:%debug "プロパティ:",token,!
            // テンプレートクラスチェック
            if token["(" {
                set templateclass=$piece($piece(token,")"),"(",2)
                set token=$piece(token,"(")
                if templateclass="" {
                    set ret=$$$ERROR(5001,"プロパティ"_token_"のテンプレート名が指定されていません")
                    quit
                }
            }
            if token="" {
                set ret=$$$ERROR(5001,"プロパティ名が存在しません")
                quit
            }
            if '$data(..props(token),val) {
                set ret=$$$ERROR(5001,"プロパティ「"_token_"」が存在しません")
                quit
            }
            set info=$lb("prop",token)_val_$select($data(templateclass):$lb(templateclass),1:"")
        } else {
            set ret=$$$ERROR(5001,"パラメータ、プロパティの指定が誤っています 値:"_token)
            quit
        }
    } catch err {
        set ret=err.AsStatus()
    }
    quit ret
}

/// パラメータ値の出力
Method OutputParameter(param As %String, path As %String) As %Status
{
    write:%debug "output parameter",!
    set base=$piece(path,".",1,*-1)_".",current=$piece(path,".",*)
    if current["(" {
        set cmd=base_$zstrip($replace(current,"%Get","%Push"),">W",")")
        do ..outstream.WriteLine(" do "_base_"%Push(obj.#"_param_")")
    } else {
        do ..outstream.WriteLine(" set "_path_"=obj.#"_param)
    }
    quit $$$OK
}

/// 固定文字列の出力
Method OutputValue(value As %String, path As %String) As %Status
{
    write:%debug "output value",!
    set base=$piece(path,".",1,*-1)_"."
    do ..outstream.WriteLine(" do "_base_"%Push("_$select((+value)=value:value,1:""""_$replace(value,"""","""""")_""")"))
    quit $$$OK
}

/// オブジェクト出力
Method OutputObject(info As %List, path As %String) As %Status
{
    write:%debug "output Object",!
    set propstr=$select($lg(info,2)'="":"obj."_$lg(info,2),1:"obj")
    set templatestr=$select($lg(info,9)'="":"##class("_$lg(info,9)_")",1:propstr)
    set templateclass=$select($lg(info,9)'="":$lg(info,9),1:$lg(info,3))

    set base=$piece(path,".",1,*-1)_".",current=$piece(path,".",*)
    if $lg(info,6)'="" {
        // プロパティがリスト形式の場合
        //do ..outstream.WriteLine(" if $isobject("_propstr_") {")
        // ListプロパティがDynamicArrayに出来ないので削除
        //do ..outstream.WriteLine(" if "_propstr_".%Extends(""%Library.DynamicArray"") {")
        //do ..outstream.WriteLine("   set iter="_propstr_".%GetIterator() for loop=1:1 { quit:'iter.%GetNext(.k,.v)  set dobj=##class("_templateclass_").Process(v,.ret) quit:$$$ISERR(ret)  continue:dobj.%Size()=0  do "_base_"%Push(dobj) quit:$$$ISERR(ret) } quit:$$$ISERR(ret)")
        //do ..outstream.WriteLine(" } else {")
        do ..outstream.WriteLine("   set key="""" for loop=1:1 { set obj2="_propstr_".GetNext(.key) quit:key=""""  set dobj="_$select($lg(info,9)'="":"##class("_templateclass_")",1:"obj2")_".Process(obj2,.ret) quit:$$$ISERR(ret)  continue:dobj.%Size()=0  do "_base_"%Push(dobj) quit:$$$ISERR(ret) } quit:$$$ISERR(ret)")
        //do ..outstream.WriteLine(" }}")
    } else {
        // プロパティがオブジェクトの場合
        do ..outstream.WriteLine(" if $isobject("_propstr_") {")

        // プロパティにDynamicObjectが割り当てられれている場合
        do ..outstream.WriteLine(" if "_propstr_".%Extends(""%Library.DynamicObject"") {")
        do ..outstream.WriteLine("   set dobj=##class("_templateclass_").Process("_propstr_",.ret) quit:$$$ISERR(ret)")
        if $lg(info)="this" {
            // $thisの場合、自己参照に陥るのを防ぐため、プロパティの型が自分自身と同じかをチェック
            do ..outstream.WriteLine(" } elseif "_propstr_".%ClassName(1)="""_$lg(info,3)_""" {")
            do ..outstream.WriteLine("   set ret=$$$ERROR(5001,""テンプレートとオブジェクトの型が一致しているため出力できません class=""_"_propstr_".%ClassName(1)) quit")
        }
        // プロパティ値が指定されたテンプレートクラスを継承している場合
        do ..outstream.WriteLine(" } elseif "_propstr_".%Extends("""_$lg(info,3)_""") {")
        do ..outstream.WriteLine("   set dobj="_templatestr_".Process("_propstr_",.ret)  quit:$$$ISERR(ret)")
        do ..outstream.WriteLine(" } else { set ret=$$$ERROR(5001,""プロパティ"_$lg(info,2)_"の型が誤っています class=""_"_propstr_".%ClassName(1)) quit }")

        // プロパティへの登録
        if current["(" {
            // リスト形式の場合
            //set cmd=base_$zstrip($replace(current,"%Get","%Set"),">W",")")
            do ..outstream.WriteLine("   do "_base_"%Push(dobj) quit:$$$ISERR(ret)")
        } else {
            // オブジェクト形式の場合
            do ..outstream.WriteLine("   set "_path_"=dobj do:dobj.%Size=0 "_base_"%Remove("""_current_""")")
        }
        
        do ..outstream.WriteLine(" } else {")
        // プロパティがNULLの場合
        if current["(" {
            do:$lg(info,5) ..outstream.WriteLine("   set ret=$$$ERROR(5001,""プロパティ"_$lg(info,2)_"がNULLになっています"") quit")
        } else {
            do ..outstream.WriteLine("   "_$select('$lg(info,5):"do "_base_"%Remove("""_current_""")",1:"set ret=$$$ERROR(5001,""プロパティ"_$lg(info,2)_"がNULLになっています"") quit"))
        }
        do ..outstream.WriteLine(" }")
    }
    quit $$$OK
}

/// プロパティ値の出力
Method OutputProperty(info As %List, path As %String) As %Status
{
    write:%debug "output Property",!
    set propstr=$select($lg(info,2)'="":"obj."_$lg(info,2),1:"obj")
    set base=$piece(path,".",1,*-1)_".",current=$Piece(path,".",*)

    // プロパティがリストの場合
    if $lg(info,6)'="" {
        // 必ずオブジェクトが入っているため、この条件をコメントアウト
        //do ..outstream.WriteLine(" if "_propstr_"="""" {")
        //do ..outstream.WriteLine(" } elseif "_propstr_".%Extends(""%Library.DynamicArray"") {")
        //do ..outstream.WriteLine("   set iter="_propstr_".%GetIterator() for loop=1:1 { quit:'iter.%GetNext(.k,.v)  do "_base_"%Push(v) }")
        //do ..outstream.WriteLine(" } else {")
        do ..outstream.WriteLine("   set key="""" for loop=1:1 { set v="_propstr_".GetNext(.key) quit:key=""""  do "_base_"%Push(v) }")
        //do ..outstream.WriteLine(" }")
    } else {
        
        if current["(" {
            // Arrayの場合
            if $lg(info,9)'="" {
                do ..outstream.WriteLine(" if "_propstr_"'="""" { set objtmp=##class("_$lg(info,9)_").GetByCode("_propstr_") do:"_propstr_"'="""" "_base_"%Push(##class("_$lg(info,9)_").Process(objtmp,.ret)) quit:$$$ISERR(ret) }")
            } elseif $lg(info,7) {
                // DISPLAYLIST,VALUELISTがある場合
                do ..outstream.WriteLine(" do:"_propstr_"'="""" "_base_"%Push(##class("_%class.Name_")."_$lg(info,2)_"LogicalToDisplay("_propstr_")")
            } elseif ",INTEGER,DECIMAL,NUMERIC,DOUBLE,BIGINT,"[(","_$lg(info,4)_",") {
                // 数値型でSCALEがNULLでない場合、$fnumber()演算子を使って数値化
                // $fnumberを使用すると文字列となるため、先頭に$c(0)を付与し、Formatterで$c(0)があれば削除する
                if $lg(info,8)'="" {
                    do ..outstream.WriteLine(" do:"_propstr_"'="""" "_base_"%Push($c(0)_$fnumber("_propstr_","""","_$lg(info,8)_"))")
                } else {
                    do ..outstream.WriteLine("  do:"_propstr_"'="""" "_base_"%Push(+("_propstr_"))")
                }
            } elseif $lg(info,4)="BOOLEAN" {
                // Boolean型の場合、True,falseに変換
                do ..outstream.WriteLine(" do:"_propstr_"'="""" "_base_"%Push("_propstr_",""boolean"")")
            } else {
                do ..outstream.WriteLine(" do:"_propstr_"'="""" "_base_"%Push("_propstr_")")
            }
        } else {
            // Objectの場合
            if $lg(info,9)'="" {
                // 出力用テンプレートクラスが指定されている場合GetByCodeでオブジェクトを取得
                do ..outstream.WriteLine(" set objtmp=$select("_propstr_"'="""":##class("_$lg(info,9)_").GetByCode("_propstr_"),1:"""")")
                do ..outstream.WriteLine(" if $isobject(objtmp) { set "_path_"=##class("_$lg(info,9)_").Process(objtmp,.ret) } else { do "_base_"%Remove("""_$piece(path,".",*)_""") }")
                quit
            }
            do:'$lg(info,5) ..outstream.WriteLine(" if "_propstr_"="""" { do "_base_"%Remove("""_$piece(path,".",*)_""") } else {")
            if $lg(info,7) {
                // DISPLAYLIST,VALUELISTがある場合
                do ..outstream.WriteLine(" set "_path_"=##class("_%class.Name_")."_$lg(info,2)_"LogicalToDisplay("_propstr_")")
            } elseif ",INTEGER,DECIMAL,NUMERIC,DOUBLE,BIGINT,"[(","_$lg(info,4)_",") {
                // 数値型でSCALEがNULLでない場合、$fnumber()演算子を使って数値化
                // $fnumberを使用すると文字列となるため、先頭に$c(0)を付与し、Formatterで$c(0)があれば削除する
                if $lg(info,8)'="" {
                    do ..outstream.WriteLine(" set "_path_"=$c(0)_$fnumber("_propstr_","""","_$lg(info,8)_")")
                } else {
                    do ..outstream.WriteLine(" set "_path_"=+("_propstr_")")
                }
            } elseif $lg(info,4)="BOOLEAN" {
                // Boolean型の場合、True,falseに変換
                do ..outstream.WriteLine(" do "_base_"%Set("""_current_""","_propstr_",""boolean"")")
            } else {
                do ..outstream.WriteLine(" set "_path_"="_propstr)
            }
            do:'$lg(info,5) ..outstream.WriteLine(" }")
        }
    }
    quit $$$OK
}

/// JSONStringの設定行を作成
Method SetJSONString(tpl As %DynamicAbstractObject) As %String
{
    //set %jsonstring($increment(%jsonstring))=tpl
    set ..jsonstring($increment(..jsonstring))=tpl
    do ..outstream.WriteLine("")
    do ..outstream.WriteLine("$tpl"_..jsonstring)
    quit "tpl"_..jsonstring
}

/// 対象クラスのプロパティの一覧を取得する
/// props(プロパティ名)=$lb(プロパティクラス,クライアントデータタイプ,Requiredかどうか,コレクションかどうか,LogicalToDisplayを使用するかどうか)
Method GetPropertyList(compiledclass As %Dictionary.CompiledClass) As %Status
{
    set ret=$$$OK
    try {
        set key="" for {
            set pdef=compiledclass.Properties.GetNext(.key)
            quit:key=""
            set tdef=##class(%Dictionary.ClassDefinition).%OpenId(pdef.Type,,.ret)
            //quit:$$$ISERR(ret)
            set display=$select(pdef.Parameters.GetAt("DISPLAYLIST")'=""||(pdef.Parameters.GetAt("FORMAT")'=""):1,1:0)
            set classtype=$select($isobject(tdef)&&(tdef.ClassType="datatype"):tdef.ClientDataType,$extract(pdef.Type)="%":tdef.ClientDataType,1:"")

            set ..props(pdef.Name)=$lb(pdef.Type,classtype,pdef.Required,pdef.Collection,display,pdef.Parameters.GetAt("SCALE"))
        }
    } catch err {
        set ret=err.AsStatus()
    }
    quit ret
}

}
