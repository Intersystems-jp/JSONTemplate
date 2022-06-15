Class FHIRTemplate.DataType.Narrative Extends JSONTemplate.Base
{

Property status As %String;

Property div As %String(MAXLEN = "");

XData Template [ MimeType = application/json ]
{
{
        "status":"#(..status)#",
        "div": "<div xmlns='http://www.w3.org/1999/xhtml'>#(..div)#</div>"
}
}

}
