Class FHIRTemplate.Observation Extends FHIRTemplate.Resource
{

/// JSON出力する際のテンプレート
/// https://jpfhir.jp/jpcoreV1/ObservationCommon を参考に作成
/// JSONの値の文字列に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
XData Template [ MimeType = application/json ]
{
{
  "resourceType": "#(..#ResourceType)#",
  "category": [ "#(..Category)#" ],
  "code": "#(..Code)#",
  "effectiveDateTime": "#(..EffectiveDateTime)#",
  "subject": "#(..Patient(FHIRTemplate.Reference))#",
  "status": "final",
  "valueQuantity": "#(..ValueQuantity(FHIRTemplate.DataType.Quantity))#"
}
}

Parameter ResourceType = "Observation";

Property Category As list Of FHIRTemplate.DataType.CodeableConceptBase;

Property Code As FHIRTemplate.DataType.CodeableConceptBase;

Property EffectiveDateTime As FHIRTemplate.DataType.TimeStamp;

/// Patientリファレンス
Property Patient As FHIRTemplate.Patient;

Property ValueQuantity As FHIRTemplate.DataType.Quantity;

}
