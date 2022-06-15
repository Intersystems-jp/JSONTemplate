/// 患者リソース
Class FHIRTemplate.Bundle Extends FHIRTemplate.Resource
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
  "resourceType": "#(..#ResourceType)#",
  "meta": {
    "profile": [ "#(..#Profile)#" ]
  },
  "type": "#(..type)#",
  "timestamp": "#(..timeStamp)#",
  "entry": [
    "#(..resource(FHIRTemplate.Bundle.entry))#"
      ],
  "signature": {
    "type": {
      "system": "urn:iso-astm:E1762-95:2013",
      "code": "1.2.840.10065.1.12.1.1"
    },
    "when": "#(..signatureDate)#",
    "who": "#(..attester)#",
    "data": "#(..signatureData)#"
  }
  }
}

Parameter ResourceType = "Bundle";

Parameter Profile = "jpfhir.jp/fhir/eDischargeSummary/StructureDefinition/JP_Bundle_eDischargeSummary";

/// bundleタイプ
Property type As %String;

/// 作成時刻
Property timeStamp As FHIRTemplate.DataType.TimeStamp;

Property resource As list Of Resource;

/// 署名時刻
Property signatureDate As FHIRTemplate.DataType.TimeStamp;

/// 文書法的責任者
Property attester As FHIRTemplate.Practitioner;

/// 署名データ
Property signatureData As %String;

/// FHIRドキュメントの作成
ClassMethod CreateFHIRDocument(composition As Composition, attester As Practitioner = "") As Bundle
{
  set obj=..%New()
  set obj.type="document"
  set obj.timeStamp = $now()
  
  // bundleリソース管理クラスのインスタンスを取得
  set br=##class(FHIRTemplate.Util.BundleResource).%New()

  // 文書法的責任者が指定されていればそのリソースも登録
  if $isobject(attester) {
    set obj.attester=attester
    do br.AddResource(attester)
  }

  // 指定されたCompositionリソースから関連するリソースを取得
  do composition.GetResources(br)

  // 取得した関連リソースをBundleに登録
  do br.ExportResources(obj.resource)
  quit obj
}

}
