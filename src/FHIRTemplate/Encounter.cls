Class FHIRTemplate.Encounter Extends Resource
{

Parameter ResourceType = "Encounter";

Property encounterId As %String;

Property class As %String;

Property period As FHIRTemplate.DataType.Period;

Property length As FHIRTemplate.DataType.Duration;

/// reasonCode.coding.0.systemが記入できる場合コードで。MEDIS：標準病名マスター病名交換用コードが例にある（urn:oid:1.2.392.200119.4.101.6）
Property reasonCode As list Of FHIRCustom.CodeableConcept.ByomeiCode;

/// Diagnosis
Property diagnosis As list Of FHIRTemplate.Encounter.diagnosis;

/// Organizationリソース
Property hospitalizationOrigin As FHIRTemplate.Organization;

Property admitSource As %String;

Property dischargeDisposition As %String;

Property Rank As %Integer [ InitialExpression = 1 ];

/// 固定値にしたもの
/// meta.profile/status/class以下/diagnosis.use.coding/diagnosis.rank
XData Template [ MimeType = application/json ]
{
{
    "resourceType": "#(..#ResourceType)#",
    "meta": {
        "profile": ["http://jpfhir.jp/fhir/eClinicalSummary/StructureDefinition/JP_Encounter_eClinicalSummary"]   
    },
    "identifier":[
        {
            "system": "http://jpfhir.jp/fhir/Common/CodeSystem/resourceInstance-identifier",
            "value": "#(..encounterId)#"
        }
    ],     
    "status": "finished",
    "class": "#(..class(FHIRCustom.Coding.ActCode))#",
    "period":"#(..period)#",
    "length":"#(..length)#",
    "reasonCode": ["#(..reasonCode)#"],
    "diagnosis":[
        "#(..diagnosis)#"
    ],
    "hospitalization":{
        "origin":"#(..hospitalizationOrigin(Reference))#",
        "admitSource": "#(..admitSource(FHIRCustom.CodeableConcept.AdmitSource))#",
        "dischargeDisposition": "#(..dischargeDisposition(FHIRCustom.CodableConcept.DischargeCode))#"
    }
}
}

}
