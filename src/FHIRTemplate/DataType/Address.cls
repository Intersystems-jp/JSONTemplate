Class FHIRTemplate.DataType.Address Extends JSONTemplate.Base
{

XData Template [ MimeType = application/json ]
{
{
        "use":"#(..use)#",
        "type":"#(..type)#",
        "text":"#(..text)#",
        "line":"#(..line)#",
        "city": "#(..city)#",
        "district":"#(..district)#",
        "state":"#(..state)#",
        "postalCode":"#(..postalCode)#",
        "country":"JP"
}
}

Property use As %String;

Property type As %String;

Property text As %String;

Property line As %String;

Property city As %String;

Property district As %String;

Property state As %String;

Property postalCode As %String;

Property country As %String;

Property period As Period;

/// JSON出力前処理
/// JSONを出力する前に実行されるコールバック
ClassMethod OnPreProcess(obj As FHIRTemplate.Resource) As %Status
{
   if obj.text=""&&((obj.state'="")||(obj.city'="")) {
        set obj.text=obj.state_obj.city_obj.line
   }
   quit $$$OK
}

}
