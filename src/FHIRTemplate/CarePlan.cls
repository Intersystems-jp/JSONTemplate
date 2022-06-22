Class FHIRTemplate.CarePlan Extends Resource
{

Parameter ResourceType = "CarePlan";

Parameter CategorySystem = "http://jpfhir.jp/fhir/CarePlan/CodeSystem/category";

Parameter CategoryDisplay = "discharge-plan,hospital-plan";

Property TextDiv As %String(MAXLEN = 10000);

/// identifier.value
Property IdentifierValue As %String;

/// statusvDISPLAYLIST = ",案,有効,保留,取消,完了,エラー,不明"
Property Status As %String(VALUELIST = ",draft,active,on-hold,revoked,completed,entered-in-error,unknown");

/// intent DISPLAYLIST = ",提案,計画,指示,オプション",
Property Intent As %String(VALUELIST = ",proposal,plan,order,option");

Property Category As FHIRTemplate.DataType.CodeableConcept;

Property Description As %String(MAXLEN = 10000);

/// Patient
Property Patient As FHIRTemplate.Patient;

/// Encounter
Property Encounter As FHIRTemplate.Encounter;

/// Practitioner
Property Practitioner As FHIRTemplate.Practitioner;

Property Period As FHIRTemplate.DataType.Period;

Property CreationTime As FHIRTemplate.DataType.TimeStamp;

XData Template [ MimeType = application/json ]
{
{
    "resourceType": "#(..#ResourceType)#",
    "meta": {
        "profile": ["http://jpfhir.jp/fhir/eClinicalSummary/StructureDefinition/JP_CarePlan_eClinicalSummary"]
    },
    "text": {
        "status": "generated",
        "div": "#(..TextDiv)#"
    },
    "identifier": [
        {
            "system":"http://jpfhir.jp/fhir/Common/CodeSystem/resourceInstance-identifier",
            "value": "#(..IdentifierValue)#"
        }
],    
    "status": "#(..Status)#",
    "intent": "#(..Intent)#",
    "category": [ "#(..Category(FHIRTemplate.DataType.CodeableConcept))#"],
    "title":"退院時の方針",
    "description":"#(..Description)#",
    "subject":"#(..Patient(FHIRTemplate.Reference))#",
    "encounter": "#(..Encounter(FHIRTemplate.Reference))#",
    "period": "#(..Period)#",
    "created":"#(..CreationTime)#",
    "author":"#(..Practitioner(FHIRTemplate.Reference))#"
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
    do:$isobject(..Practitioner) ..Practitioner.GetResources(br)
}

}
