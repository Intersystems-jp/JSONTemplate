Class FHIRTest.BaseTest4 Extends JSONTemplate.Base
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
    "t1":"BaseTest4",
    "t2":"#(..Param1)# #(..Param2)#"
}
}

Property Param1 As %String;

Property Param2 As %Numeric;

}
