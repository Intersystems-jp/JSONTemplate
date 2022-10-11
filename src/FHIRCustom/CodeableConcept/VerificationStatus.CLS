Class FHIRCustom.CodeableConcept.VerificationStatus Extends (%Persistent, FHIRTemplate.DataType.CodeableConceptBase, FHIRTemplate.Util.CodeTable)
{

Parameter CodeSystem = "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification";

Index IDKeyIdx On code [ IdKey, Unique ];

XData InsertCode [ MimeType = application/json ]
{
{ "data":[
    "unconfirmed;Lv0 Unconfirmed",
    "provisional;Lv1 Provisional",
    "differential;Lv1 Differential",
    "confirmed;Lv0 Confirmed",
    "refuted;Lv0 Refuted",
    "entered-in-error;Lv0 Entered in Error"
  ]  
}
}

Storage Default
{
<Data name="VerificationStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>display</Value>
</Value>
</Data>
<DataLocation>^FHIRCustomC353.VerificatioF38FD</DataLocation>
<DefaultData>VerificationStatusDefaultData</DefaultData>
<IdLocation>^FHIRCustomC353.VerificatioF38FD</IdLocation>
<IndexLocation>^FHIRCustomC353.VerificatioF38FI</IndexLocation>
<StreamLocation>^FHIRCustomC353.VerificatioF38FS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
