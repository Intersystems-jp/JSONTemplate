/// 文書カテゴリ
Class FHIRCustom.Coding.DiagnosisRoleCode Extends (%Persistent, FHIRTemplate.Util.CodeTable, FHIRTemplate.DataType.CodingBase)
{

Parameter CodeSystem = "http://terminology.hl7.org/CodeSystem/diagnosis-role";

Index IDKeyIdx On code [ IdKey, Unique ];

XData InsertCode [ MimeType = application/json ]
{
{ "data":[
    "AD;入院時診断",
    "DD;退院時診断",
    "CC;主訴",
    "CM;併存症診断",
    "pre-op;術前診断",
    "post-op;術後診断",
    "billing;会計請求診断"
  ]  
}
}

Storage Default
{
<Data name="DiagnosisRoleCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>display</Value>
</Value>
<Value name="3">
<Value>version</Value>
</Value>
<Value name="4">
<Value>userSelected</Value>
</Value>
</Data>
<DataLocation>^FHIRCustomF1F6.DiagnosisRo8DCFD</DataLocation>
<DefaultData>DiagnosisRoleCodeDefaultData</DefaultData>
<IdLocation>^FHIRCustomF1F6.DiagnosisRo8DCFD</IdLocation>
<IndexLocation>^FHIRCustomF1F6.DiagnosisRo8DCFI</IndexLocation>
<StreamLocation>^FHIRCustomF1F6.DiagnosisRo8DCFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
