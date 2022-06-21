/// 患者リソース
Class FHIRTemplate.Practitioner Extends Resource
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
  "text": "#(..text)#",
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
      "text": "#(..LastNameKana)#　#(..FirstNameKana)# ",
      "family": "#(..LastNameKana)#",
      "given": [
        "#(..FirstNameKana)#"
      ]
    }
  ]  
}
}

Parameter ResourceType = "Practitioner";

Parameter Profile = "http://jpfhir.jp/fhir/eClinicalSummary/StructureDefinition/JP_Practitioner_eClinicalSummary_author";

Property LastName As %String;

Property FirstName As %String;

Property LastNameKana As %String;

Property FirstNameKana As %String;

Property text As FHIRTemplate.DataType.Narrative;

}
