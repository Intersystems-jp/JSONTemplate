Class FHIRTemplate.DataType.Address Extends JSONTemplate.Base
{

XData Template [ MimeType = application/json ]
{
{
        "use":"#(..use)#",
        "type":"#(..type)#",
        "text":"#(..state)##(..city)##(..line)#",
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

}
