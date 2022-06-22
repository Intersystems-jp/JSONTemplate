/// コード付き参照テンプレート
///  FHIR規格では プロパティはconceptとreferenceとなっているが、
///  退院時サマリの仕様書では code,detailとなっているので、
///  こちらに合わせておく
Class FHIRCustom.Evidence Extends FHIRTemplate.ResourceBase
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
	"code": [
    "#(..code)#"
  ],
  "detail": [
    "#(..detail(FHIRTemplate.Reference))#"
  ]
}
}

Property code As FHIRCustom.CodeableConcept.ByomeiCode;

Property detail As FHIRTemplate.Resource;

}
