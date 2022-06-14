Class FHIRTemplate.Encounter.diagnosis Extends JSONTemplate.Base
{

/// reasonCode.coding.0.systemが記入できる場合コードで。MEDIS：標準病名マスター病名交換用コードが例にある（urn:oid:1.2.392.200119.4.101.6）
/// Conditionリソース
Property condition As FHIRTemplate.Condition;

Property role As %String;

Property rank As %Integer [ InitialExpression = 1 ];

/// 固定値にしたもの
/// meta.profile/status/class以下/diagnosis.use.coding/diagnosis.rank
XData Template [ MimeType = application/json ]
{
{
            "condition": "#(..condition(FHIRTemplate.Reference))#",
            "use":{
                "coding":[
                    "#(..role(FHIRCustom.Coding.DiagnosisRoleCode))#"
                ]
            },
            "rank":"#(..rank)#"
        }
}

}
