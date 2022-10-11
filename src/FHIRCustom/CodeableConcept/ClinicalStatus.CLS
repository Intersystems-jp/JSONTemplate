Class FHIRCustom.CodeableConcept.ClinicalStatus Extends (%Persistent, FHIRTemplate.DataType.CodeableConceptBase, FHIRTemplate.Util.CodeTable)
{

Parameter CodeSystem = "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical";

Index IDKeyIdx On code [ IdKey, Unique ];

XData InsertCode [ MimeType = application/json ]
{
{ "data":[
    "active;Lv0 active",
    "reccurence;Lv1 recurrence",
    "relapse;Lv1 relapse",
    "inactive;Lv0 inactive",
    "remission;Lv1 remission",
    "resolved;Lv1 resolved"
  ]  
}
}

Storage Default
{
<Data name="ClinicalStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>display</Value>
</Value>
</Data>
<DataLocation>^FHIRCustomC353.ClinicalStatusD</DataLocation>
<DefaultData>ClinicalStatusDefaultData</DefaultData>
<IdLocation>^FHIRCustomC353.ClinicalStatusD</IdLocation>
<IndexLocation>^FHIRCustomC353.ClinicalStatusI</IndexLocation>
<StreamLocation>^FHIRCustomC353.ClinicalStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
