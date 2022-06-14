/// 患者参照テンプレート
/// 単なるリファレンスだけでなく、患者氏名をdisplayプロパティに出力
Class FHIRCustom.PatientReference Extends FHIRTemplate.Patient
{

/// JSON出力する際のテンプレート
/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
	"reference": "urn:uuid:#(..ResourceId)#",
  "display": "#(..LastName)# #(..FirstName)#"
}
}

}
