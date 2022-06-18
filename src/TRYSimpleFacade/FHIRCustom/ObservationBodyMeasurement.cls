Class FHIRCustom.ObservationBodyMeasurement Extends FHIRTemplate.Observation
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
  "category": [
      {
          "coding": [
              {
                  "system": "http://jpfhir.jp/fhir/Common/ValueSet/bodyMeasurement-code",
                  "code": "exam",
                  "display": "身体検査・観察"
              }
          ],
          "text": "身体検査・観察"
      }
  ],
  "code": "#(..Code)#",
  "effectiveDateTime": "#(..EffectiveDateTime)#",
  "subject": "#(..Patient(FHIRTemplate.Reference))#",
  "status": "final",
  "valueQuantity": "#(..ValueQuantity(FHIRTemplate.DataType.Quantity))#"
}
}

Property Code As FHIRCustom.CodeableConcept.BodyMeasurementCode;

}
