/// DischargeSummaryの文書作成医療機関情報の仕様で作成
Class FHIRTemplate.Organization Extends Resource
{

Parameter ResourceType = "Organization";

Property textDiv As FHIRTemplate.DataType.Narrative;

/// Extentionのidentifier.valueIdentifier.value
Property prefNum As %String;

/// 点数コード　1:医科,3:歯科
Property tensuCode As %String(VALUELIST = ",1,3");

/// 保険医療機関番号7桁
Property hokenNum7 As %String(MAXLEN = 7, MINLEN = 7);

/// 保険医療機関番号10桁
Property hokenNum10 As %String(MAXLEN = 10, MINLEN = 10);

/// 医療機関名称
Property hospitalName As %String(MAXLEN = 100);

/// 医療機関連絡先
Property phone As %String;

/// 医療機関住所
Property addressText As %String;

/// 医療機関郵便番号
Property addressZip As %String;

XData Template [ MimeType = application/json ]
{
{
    "resourceType": "#(..#ResourceType)#",
    "meta": {
        "profile": ["http://jpfhir.jp/fhir/eClinicalSummary/StructureDefinition/JP_Organization_eClinicalSummary_issuer"]
    },
    "text": "#(..textDiv)#",
    "extension":[
        {
            "url":"http://jpfhir.jp/fhir/core/Extension/StructureDefinition/JP_Organization_PrefectureNo",
            "valueIdentifier":{
                "system":"urn:oid:1.2.392.100495.20.3.21",
                "value":"#(..prefNum)#"
            }
        },
        {
            "url":"http://jpfhir.jp/fhir/core/Extension/StructureDefinition/JP_Organization_InsuranceOrganizationCategory",
            "valueIdentifier":{
                "system":"urn:oid:1.2.392.100495.20.3.22",
                "value":"#(..tensuCode)#"
            }            
        },
        {
            "url":"http://jpfhir.jp/fhir/core/Extension/StructureDefinition/JP_Organization_InsuranceOrganizationNo",
            "valueIdentifier":{
                "system":"urn:oid:1.2.392.100495.20.3.23",
                "value":"#(..hokenNum7)#"
            }            
        }
    ],
    "identifier": [
        {
            "system": "http://jpfhir.jp/fhir/Common/CodeSystem/insurance-medical-nstitution-no",
            "value":"#(..hokenNum10)#"
        }
    ],
    "type": [
        {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/organization-type",
                    "code": "prov",
                    "display": "#(..hospitalName)#"
                }
            ]
        }
    ],
    "name": "#(..hospitalName)#",
    "telecom": [
        {
            "system": "phone",
            "value": "#(..phone)#"
        }
    ],
    "address": [
        {
            "text":"#(..addressText)#",
            "postalCode": "#(..addressZip)#",
            "country": "JP"
        }
    ]
}
}

}
