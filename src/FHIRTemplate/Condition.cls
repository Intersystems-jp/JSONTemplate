Class FHIRTemplate.Condition Extends Resource
{

Parameter ResourceType = "Condition";

Property textDiv As FHIRTemplate.DataType.Narrative;

/// identifier.valueの値
Property patientStatusValue As %String;

Property clinicalStatus As %String;

Property verificationStatus As %String;

Property code As %String;

Property bodySite As %String;

Property subject As FHIRTemplate.Patient;

Property encounter As FHIRTemplate.Encounter;

Property age As FHIRTemplate.DataType.Age;

Property recordedDate As FHIRTemplate.DataType.TimeStamp(FORMAT = 3);

Property evidence As list Of FHIRCustom.Evidence;

/// 固定値
/// meta.profile/
XData Template [ MimeType = application/json ]
{
{
    "resourceType" : "#(..#ResourceType)#",
    "meta":{
        "profile":[
            "http://jpfhir.jp/fhir/eClinicalSummary/StructureDefinition/JP_Condition_eClinicalSummary"
        ]
    },
    "text" : "#(..textDiv)#",
    "identifier":[
        {
            "system":"http://jpfhir.jp/fhir/Common/CodeSystem/resourceInstance-identifier",
            "value":"#(..patientStatusValue)#"
        }
    ],
    "clinicalStatus":"#(..clinicalStatus(FHIRCustom.CodeableConcept.ClinicalStatus))#",
    "verificationStatus" : "#(..verificationStatus(FHIRCustom.CodeableConcept.VerificationStatus))#",
    "code": "#(..code(FHIRCustom.CodeableConcept.ByomeiCode))#",
    "bodySite": [ "#(..bodySite(FHIRCustom.CodeableConcept.ModifierCode))#" ],
    "subject" : "#(..subject(FHIRCustom.PatientReference))#",
    "encounter": "#(..encounter(Reference))#",
    "onsetAge": "#(..age)#",
    "recordedDate": "#(..recordedDate)#",
    "evidence": [ "#(..evidence)#" ]
}
}

Method GetResources(br As FHIRTemplate.Util.BundleResource) As %Integer
{
  // 自分自身を登録
  set ret=##super(br)
  quit:ret<1 ret // 既に登録されていれば終了

  // 関連リソースの取り込み
  do:$isobject(..subject) ..subject.GetResources(br)
  do:$isobject(..encounter) ..encounter.GetResources(br)

  set key="" for {
    set evidence=..evidence.GetNext(.key)
    quit:key=""

    if $isobject(evidence) {
        if $isobject(evidence.detail) {
            do evidence.detail.GetResources(br)
        }
    }
  }
  quit ret
}

}
