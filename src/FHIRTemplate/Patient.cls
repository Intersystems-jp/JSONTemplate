/// 患者リソース
Class FHIRTemplate.Patient Extends Resource
{

/// JSON出力する際のテンプレート
/// JSONの値の文字列に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
XData Template [ MimeType = application/json ]
{
{
  "resourceType": "#(..#ResourceType)#",
  "meta": {
    "profile": [ "#(..#ProfileURI)#" ]
  },
  "identifier": [
    {
      "system": "urn:oid:1.2.392.100495.20.3.51.1#(..MedInstCode)#",
      "value": "#(..PatientId)#"
    }
  ],
  "name": [
    {
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/iso21090-EN-representation",
          "valueCode": "IDE"
        }
      ],
      "use": "official",
      "text": "#(..LastName)#　#(..FirstName)#",
      "family": "#(..LastName)#",
      "given": [
        "#(..FirstName)#"
      ]
    },
    {
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/iso21090-EN-representation",
          "valueCode": "SYL"
        }
      ],
      "use": "official",
      "text": "#(..LastNameKana)#　#(..FirstNameKana)#",
      "family": "#(..LastNameKana)#",
      "given": [
        "#(..FirstNameKana)#"
      ]
    }
  ],
  "telecom": [
    {
      "system": "phone",
      "value": "#(..Phone)#",
      "use": "home"
    }
  ],
  "gender": "#(..Gender)#",
  "birthDate": "#(..DOB)#",
  "address": [
    "#(..Address)#"
  ],
  "maritalStatus": "#(..MaritalStatus)#"
}
}

Parameter ResourceType = "Patient";

Property ProfileURI As %String;

Property LastName As %String;

Property FirstName As %String;

Property LastNameKana As %String;

Property FirstNameKana As %String;

Property Phone As %String;

Property DOB As %Date(FORMAT = 3);

Property Gender As %String(DISPLAYLIST = ",male,female", VALUELIST = ",1,2");

/// 医療機関コード
Property MedInstCode As %String [ InitialExpression = "1311234567" ];

/// 患者ID
Property PatientId As %String;

Property Address As FHIRTemplate.DataType.Address;

Property MaritalStatus As FHIRTemplate.DataType.CodeableConcept;

Parameter ProfileURI = "http://jpfhir.jp/fhir/eClinicalSummary/StructureDefinition/JP_Patient_eClinicalSummary";

}
