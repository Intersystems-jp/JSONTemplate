Class FHIRTest.BaseTest Extends JSONTemplate.Base
{

Parameter ParamString = "defaultデータ";

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
    "p1":"123456",
    "p12":"#(..#ParamString)#",
    "p13":"#(..Param1)##(..#ParamString)#---#(..Param2)#",
    "p2":"#(..Param1)#",
    "p3":"#(..Param1)# #(..Param2)#",
    "p4":"#(..Param2)#",
    "p5":"aaaaaa#(..Param1)#",
    "o1":"#(..Obj1)#",
    "o2":"#(..CodeObj)#",
    "o3":"#(..CodeData(BaseCodeTest))#",
    "a1":[
        {
            "p1":"1234",
            "o2":"#(..Obj2)#"
        },
        "#(..Obj1)#",
        "#(..List1)#"
    ],
    "a2":[
        "#(..List2)#",
        {
            "p1":5678,
            "o2":"#(..Obj2)#"
        },
        "#(..Obj1)#"
    ]
}
}

Property Param1 As %String;

Property Param2 As %Numeric;

Property CodeObj As BaseCodeTest;

Property CodeData As %String;

Property Obj1 As BaseTest2;

Property Obj2 As BaseTest2;

Property List1 As list Of %String;

Property List2 As list Of BaseTest2;

// 通常のプロパティ指定

ClassMethod Test1(ByRef out)
{
    set obj=..%New()
    set obj.Param1="gggggg"
    set obj.Param2=1234.5
    set obj.CodeObj=##class(BaseCodeTest).GetByCode(1)
    set obj.Obj1=##class(BaseTest2).%New({
        "Param1":"qqqqq",
        "Param2":1111
    })
    set obj.Obj2=##class(BaseTest2).%New()
    set obj.Obj2.Param1="wwwwwww"
    set obj.Obj2.Param2=22222

    do obj.List1.Insert("list1")
    do obj.List1.Insert("list2")
    set obj1=##class(BaseTest2).%New()
    set obj1.Param1="list2 param1"
    set obj1.Param2=4444    
    do obj.List2.Insert(obj1)
    set obj1=##class(BaseTest2).%New()
    set obj1.Param1="list2 param1"
    set obj1.Param2=4444    
    do obj.List2.Insert(obj1)

    set ret=obj.OutputToDynamicObject(.out)
    set a=##class(%Stream.FileCharacter).%New()
    set a.TranslateTable="UTF8"
    set a.Filename="c:\temp\basetest2.json"
    set ret=obj.OutputToStream(a)
    if $$$ISOK(ret) {
        do a.%Save()
        use 0 write "正常終了",!
    }else {
        use 0 write "エラー発生",!
        do $SYSTEM.OBJ.DisplayError(ret)
    }
}

/// %Newにダイナミックオブジェクトを指定した場合
ClassMethod Test2()
{
    set obj=..%New({
      "Param1":"日本語",
      "CodeObj": 3,
      "Obj1":{
          "Param1":"子オブジェクト",
          "Param2": 123.56
      },
      "List1":["list array 1","list array 2"],
      "List2":[{"Param1": "array object 1"},{"Param1": "array object 2"}]
    })
    set a=##class(%Stream.FileCharacter).%New()
    set a.TranslateTable="UTF8"
    set a.Filename="c:\temp\basetest2_test2.json"
    set ret=obj.OutputToStream(a)
    if $$$ISOK(ret) {
        do a.%Save()
        use 0 write "正常終了",!
    }else {
        use 0 write "エラー発生",!
        do $SYSTEM.OBJ.DisplayError(ret)
    }
}

// CodeObjに直接コードを指定した場合

ClassMethod Test3(ByRef out)
{
    set obj=..%New()
    set obj.Param1="直接コード指定"
    set obj.Param2=1234.5
    set obj.CodeObj=##class(BaseCodeTest).%New(1)
    set obj.CodeData=3
    set obj.Obj1=##class(BaseTest2).%New({
        "Param1":"qqqqq",
        "Param2":1111
    })
    set obj.Obj2=##class(BaseTest2).%New()
    set obj.Obj2.Param1="wwwwwww"
    set obj.Obj2.Param2=22222

    do obj.List1.Insert("list1")
    do obj.List1.Insert("list2")
    set obj1=##class(BaseTest2).%New()
    set obj1.Param1="list2 param1"
    set obj1.Param2=4444    
    do obj.List2.Insert(obj1)
    set obj1=##class(BaseTest2).%New()
    set obj1.Param1="list2 param1"
    set obj1.Param2=4444    
    do obj.List2.Insert(obj1)

    set ret=obj.OutputToDynamicObject(.out)
    set a=##class(%Stream.FileCharacter).%New()
    set a.TranslateTable="UTF8"
    set a.Filename="c:\temp\basetest2.json"
    set ret=obj.OutputToStream(a)
    if $$$ISOK(ret) {
        do a.%Save()
        use 0 write "正常終了",!
    }else {
        use 0 write "エラー発生",!
        do $SYSTEM.OBJ.DisplayError(ret)
    }
}

}
