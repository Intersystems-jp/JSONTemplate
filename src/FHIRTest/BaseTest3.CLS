Class FHIRTest.BaseTest3 Extends JSONTemplate.Base
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
    "p1":"BaseTest2",
    "a1": [
        {"p1":"#(..Param1)#","p2":"#(..Param2)#"},
        {"p1":"#(..Param3)#","p2":"#(..Param4)#"},
        "aaaa"
    ],
    "a2": [
        "#(..#Title)#",
        {"p1":"#(..Param1)#","p2":"#(..Param2)#"},
        {"p1":"#(..Param3)#","p2":"#(..Param4)#"}
    ],
    "a3": [
        {"p1":"#(..Param1)#","p2":"#(..Param2)#"},
        {"p1":"#(..Param3)#","p2":"#(..Param4)#"}
    ],
    "oa1": {"p1":123.5,"p2":[
        {"p1":"#(..Param1)#","p2":"#(..Param2)#"}
    ],
    "p3":[
        {"p1":"#(..Param3)#","p2":"#(..Param4)#"}
    ]},
    "oa2": {"p1":"#(..Param1)#","p2":[
        {"p1":"#(..Param3)#","p2":"#(..Param4)#"}
    ]},
    "oa3": {"p1":"#(..Param1)#","p2":[
        {"p1":"#(..Param3)#","p2":"#(..Param4)#","p3":"xx"}
    ]}
}
}

Parameter Title = "title";

Property Param1 As %String;

Property Param2 As %Numeric;

Property Param3 As %String;

Property Param4 As %Numeric;

ClassMethod Test0()
{
    set obj=..%New()
    do obj.OutputToDevice()
}

ClassMethod Test1()
{
    set obj=..%New()
    set obj.Param1="test1",obj.Param3="test1-3"
    do obj.OutputToDevice()
}

ClassMethod Test2()
{
    set obj=..%New()
    set obj.Param1="test2-1",obj.Param3="test2-3"
    set obj.Param2=22,obj.Param4=44
    do obj.OutputToDevice()
}

}
