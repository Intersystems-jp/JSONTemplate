/// 入院経路
Class FHIRCustom.CodeableConcept.AdmitSource Extends (%Persistent, FHIRTemplate.Util.CodeTable, FHIRTemplate.DataType.CodeableConceptBase)
{

Parameter CodeSystem = "http://jpfhir.jp/fhir/Common/CodeSystem/admit-Source";

Index IDKeyIdx On code [ IdKey, Unique ];

XData InsertCode [ MimeType = application/json ]
{
{ "data":[
    "0;院内の他病棟からの転棟",
    "1;家庭からの入院",
    "4;他の病院・診療所の病棟からの転院",
    "5;介護施設・福祉施設に入所中",
    "8;院内で出生",
    "9;その他"
  ]  
}
}

Storage Default
{
<Data name="AdmitSourceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>display</Value>
</Value>
</Data>
<DataLocation>^FHIRCustom.CodC353.AdmitSourceD</DataLocation>
<DefaultData>AdmitSourceDefaultData</DefaultData>
<IdLocation>^FHIRCustom.CodC353.AdmitSourceD</IdLocation>
<IndexLocation>^FHIRCustom.CodC353.AdmitSourceI</IndexLocation>
<StreamLocation>^FHIRCustom.CodC353.AdmitSourceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
