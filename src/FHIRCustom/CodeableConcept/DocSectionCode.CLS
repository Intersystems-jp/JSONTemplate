/// 文書タイプ
Class FHIRCustom.CodeableConcept.DocSectionCode Extends (%Persistent, FHIRTemplate.DataType.CodeableConceptBase, FHIRTemplate.Util.CodeTable)
{

Index IDKeyIdx On code [ IdKey, Unique ];

Parameter CodeSystem = "http://jpfhir.jp/fhir/eClinicalSummary/CodeSystem/document-section";

XData InsertCode [ MimeType = application/json ]
{
{ "data":[
    "200;CDA参照;cda",
    "300;構造情報;structured",
    "322;入院詳細;detailsOnAdmission",
    "342;入院時診断;diagnosesOnAdmission",
    "510;アレルギー・不耐性反応;allergiesIntolerance",
    "352;入院時主訴;chiefProblemOnAdmission",
    "312;入院理由;reasonForAdmission",
    "362;入院時現病歴;presentIllnessOnAdmission",
    "372;入院時既往歴;pastIllnessOnAdmission",
    "432;入院時服薬;medicationsOnAdmission",
    "642;入院時社会歴;socialHistoryOnAdmission",
    "612;入院時身体所見;physicalStatusOnAdmission",
    "552;入院時家族歴;familiyHistoryOnAdmission",
    "333;入院中経過;hospitalCourse",
    "324;退院時詳細;detailsOnDischarge",
    "444;退院時投薬指示;medicationOnDischarge",
    "424;退院時方針指示;instructionOnDischarge",
    "614;退院時身体所見;physicalStatusOnDischarge",
    "713;入院中治療;hospitalProcedure",
    "623;入院中検査結果;hospitalStudy",
    "810;医療機器;medicalDevice",
    "530;予防接種歴;immunization",
    "410;事前指示;advanceDirective"
  ]  
}
}

Storage Default
{
<Data name="DocSectionCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>display</Value>
</Value>
</Data>
<DataLocation>^FHIRCustomC353.DocSectionCodeD</DataLocation>
<DefaultData>DocSectionCodeDefaultData</DefaultData>
<IdLocation>^FHIRCustomC353.DocSectionCodeD</IdLocation>
<IndexLocation>^FHIRCustomC353.DocSectionCodeI</IndexLocation>
<StreamLocation>^FHIRCustomC353.DocSectionCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
