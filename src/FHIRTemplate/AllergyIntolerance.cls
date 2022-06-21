Class FHIRTemplate.AllergyIntolerance Extends FHIRTemplate.Resource
{

Parameter ResourceType = "AllergyIntolerance";

Parameter ClinicalStatusCode = "active,inactive,resolved";

Parameter ClinicalStatusDisplay = "現存,非現存,解消";

Parameter VerificationStatusCode = "unconfirmed,confirmed,refuted,entered-in-error";

Parameter VerificationStatusDisplay = "未確認,確認済,否定,エラー";

Property TextDiv As %String(MAXLEN = 10000);

/// identifier.value
Property IdentifierValue As %String;

Property ClinicalStatus As FHIRTemplate.DataType.CodeableConcept;

Property VerificationStatus As FHIRTemplate.DataType.CodeableConcept;

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
    "clinicalStatus": "#(..ClinicalStatus)#",
    "verificationStatus":"#(..VerificationStatus)#",
    "type":"#(..Type)#",
    "category": ["#(..Category)#"],
    "criticality":"#(..Criticality)#",
    "code": "#(..Code)#",
    "patient":"#(..Patient(FHIRTemplate.Reference))#",
    "encounter":"#(..Encounter(FHIRTemplate.Reference))#"
}
}

}
