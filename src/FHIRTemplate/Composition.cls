/// 文書構成リソース
Class FHIRTemplate.Composition Extends FHIRTemplate.Resource
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
  "resourceType": "#(..#ResourceType)#",
  "meta": {
    "profile": [
      "#(..#Profile)#"
    ]
  },
  "extension":[
    {
    "url":"http://hl7.org/fhir/StructureDefinition/composition-clinicaldocumentversionNumber",
    "valueString":"#(..docVer)#"
    }
  ],
  "identifier":{
    "system":"http://jpfhir.jp/fhir/Common/CodeSystem/resourceInstanceidentifier",
    "value":"#(..docId)#"
  },
  "status":"#(..status)#",
  "type":"#(..docType(FHIRCustom.CodeableConcept.DocType))#",
  "category":[
    "#(..docCategory(FHIRCustom.CodeableConcept.DocCategory))#"
  ],
  "subject": "#(..subject(Reference))#",
  "encounter": "#(..encounter(Reference))#",
  "date":"#(..date)#",
  "author":[
    "#(..author(Reference))#",
    "#(..authorOrg(Reference))#"
  ],
  "title": "#(..title)#",
  "custodian": "#(..custodian(Reference))#",
  "event": [
  {
    "code": "#(..eventCode)#",
    "period": "#(..eventPeriod)#"
  }
  ],
  "section": [
    "#(..section)#"
  ]
}
}

Parameter ResourceType = "Composition";

Parameter Profile = "http://jpfhir.jp/fhir/eDischargeSummary/StructureDefinition/JP_Composition_eDischargeSummary";

Property status As %Integer(DISPLAYLIST = ",preliminary,final,amended,entered-in-error", VALUELIST = ",0,1,-1,-2");

Property docId As %String;

Property docVer As %String;

Property docType As %String;

Property docCategory As %String;

Property subject As Patient;

Property author As Practitioner;

Property attester As Practitioner;

Property authorOrg As Organization;

Property custodian As Organization;

Property encounter As Encounter;

Property date As FHIRTemplate.DataType.TimeStamp(FORMAT = 1);

Property title As %String;

Property eventCode As FHIRTemplate.DataType.Coding;

Property eventPeriod As FHIRTemplate.DataType.Period;

Property section As list Of FHIRTemplate.Composition.section;

Method GetResources(br As FHIRTemplate.Util.BundleResource) As %Integer
{
  // 自分自身を登録
  set ret=br.AddResource($this)
  quit:ret<1 ret // 既に登録されていれば終了

  // 関連リソースの取り込み
  do:$isobject(..subject) ..subject.GetResources(br)
  do:$isobject(..author) ..author.GetResources(br)
  do:$isobject(..attester) ..attester.GetResources(br)
  do:$isobject(..authorOrg) ..authorOrg.GetResources(br)
  do:$isobject(..custodian) ..custodian.GetResources(br)
  do:$isobject(..encounter) ..encounter.GetResources(br)
  set key="" for {
    set section=..section.GetNext(.key)
    quit:key=""

    do section.GetResources(br)
  }
  quit ret
}

}
