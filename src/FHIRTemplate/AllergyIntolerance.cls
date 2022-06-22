Class FHIRTemplate.AllergyIntolerance Extends FHIRTemplate.Resource
{

Parameter ResourceType = "AllergyIntolerance";

/// FHIRCustom.ClinicalStatus利用時未使用
Parameter ClinicalStatusCode = "active,inactive,resolved";

/// FHIRCustom.ClinicalStatus利用時未使用
Parameter ClinicalStatusDisplay = "現存,非現存,解消";

/// FHIRCustom.VerificationStatus利用時未使用
Parameter VerificationStatusCode = "unconfirmed,confirmed,refuted,entered-in-error";

/// FHIRCustom.VerificationStatus利用時未使用
Parameter VerificationStatusDisplay = "未確認,確認済,否定,エラー";

Property TextDiv As %String(MAXLEN = 10000);

/// identifier.value
Property IdentifierValue As %String;

/// FHIRCustom.DataType.ClinicalStatus利用の為タイプを%Stringに設定
Property ClinicalStatus As %String;

/// FHIRCustom.DataType.VerificationStatus利用の為タイプを%Stringに設定
Property VerificationStatus As %String;

Property Type As %String(VALUELIST = ",allergy,intolerance");

/// DISPLAYLIST = ",食物,医薬品,環境,生物学的"
Property Category As %String(VALUELIST = ",food,medication,environment,biologic");

/// DISPLAYLIST = ",低,高,評価不能".DataType
Property Criticality As %String(VALUELIST = ",low,high,unable-to-assess");

Property Code As FHIRTemplate.DataType.CodeableConcept;

/// Patient
Property Patient As FHIRTemplate.Patient;

/// Encounter
Property Encounter As FHIRTemplate.Encounter;

XData Template [ MimeType = application/json ]
{
{
    "resourceType": "#(..#ResourceType)#",
    "meta": {
        "profile": ["http://jpfhir.jp/fhir/eClinicalSummary/StructureDefinition/JP_AllergyIntolerance_eClinicalSummary"]
    },
    "text":{
        "status":"generated",
        "div":"#(..TextDiv)#"
    },
    "identifier":[
        {
        "system":"http://jpfhir.jp/fhir/Common/CodeSystem/resourceInstance-identifier",
        "value":"#(..IdentifierValue)#"
        }
    ],
    "clinicalStatus": "#(..ClinicalStatus(FHIRCustom.CodeableConcept.ClinicalStatus))#",
    "verificationStatus":"#(..VerificationStatus(FHIRCustom.CodeableConcept.VerificationStatus))#",
    "type":"#(..Type)#",
    "category": ["#(..Category)#"],
    "criticality":"#(..Criticality)#",
    "code": "#(..Code)#",
    "patient":"#(..Patient(FHIRTemplate.Reference))#",
    "encounter":"#(..Encounter(FHIRTemplate.Reference))#"
}
}

Method GetResources(br As FHIRTemplate.Util.BundleResource) As %Integer
{
    // 自分自身を登録
    set ret=##super(br)
    quit:ret<1 ret // 既に登録されていれば終了

    //関連リソースの取り込み
    do:$isobject(..Patient) ..Patient.GetResources(br)
    do:$isobject(..Encounter) ..Encounter.GetResources(br)
}

}
