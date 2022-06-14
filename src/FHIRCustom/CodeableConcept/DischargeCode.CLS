/// 文書カテゴリ
Class FHIRCustom.Coding.DischargeCode Extends (%Persistent, FHIRTemplate.DataType.CodingBase, FHIRTemplate.Util.CodeTable)
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
<DataLocation>^FHIRCustom.CF1F6.DischargeCodeD</DataLocation>
<DefaultData>DischargeCodeDefaultData</DefaultData>
<IdLocation>^FHIRCustom.CF1F6.DischargeCodeD</IdLocation>
<IndexLocation>^FHIRCustom.CF1F6.DischargeCodeI</IndexLocation>
<StreamLocation>^FHIRCustom.CF1F6.DischargeCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
