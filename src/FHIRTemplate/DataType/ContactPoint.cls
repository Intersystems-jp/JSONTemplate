Class FHIRTemplate.DataType.ContactPoint Extends JSONTemplate.Base
{

XData Template [ MimeType = application/json ]
{
{
        "system":"#(..system)#",
        "value":"#(..value)#",
        "use":"#(..use)#",
        "rank":"#(..rank)#",
        "period":"#(..period)#"
}
}

Property system As %String(VALUELIST = ",phone,fax,email,pager,url,sms,other") [ Required ];

Property value As %String [ Required ];

Property use As %String(VALUELIST = ",home,work,temp,old,mobile") [ Required ];

Property rank As %Integer [ InitialExpression = 1 ];

Property period As Period;

}
