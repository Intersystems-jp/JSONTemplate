/// 退院時転帰コード
Class FHIRCustom.CodeableConcept.DischargeCode Extends (%Persistent, FHIRTemplate.Util.CodeTable, FHIRTemplate.DataType.CodingBase)
{

Parameter CodeSystem = "http://jpfhir.jp/fhir/Common/CodeSystem/discharge-disposition";

Index IDKeyIdx On code [ IdKey, Unique ];

XData InsertCode [ MimeType = application/json ]
{
{ "data":[
"1;傷病が治癒・軽快",
"3;傷病（白血病、潰瘍性大腸炎、クローン病等）が寛解",
"4;傷病が不変",
"5;傷病が増悪",
"6;傷病による死亡",
"7;傷病以外による死亡",
"9;その他（検査入院,正常分娩及び人間ドック含む）"
  ]  
}
}

Storage Default
{
<Data name="DischargeCodeDefaultData">
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
<DataLocation>^FHIRCustom.CC353.DischargeCodeD</DataLocation>
<DefaultData>DischargeCodeDefaultData</DefaultData>
<IdLocation>^FHIRCustom.CC353.DischargeCodeD</IdLocation>
<IndexLocation>^FHIRCustom.CC353.DischargeCodeI</IndexLocation>
<StreamLocation>^FHIRCustom.CC353.DischargeCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
