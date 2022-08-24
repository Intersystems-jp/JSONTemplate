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
    "type": [
      {
      "system": "urn:iso-astm:E1762-95:2013",
      "code": "1.2.840.10065.1.12.1.1"
      }
    ],
    "when": "#(..signatureDate)#",
    "who": "#(..attester(FHIRTemplate.Reference))#",
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

/// バンドルリソース
Property resource As list Of Resource;

/// 署名時刻
Property signatureDate As FHIRTemplate.DataType.TimeStamp;

/// 文書法的責任者
Property attester As FHIRTemplate.Practitioner;

/// 署名データ
Property signatureData As %String;

/// 証明書データ
/// 秘密鍵の証明書ファイルの内容
Property CertificateData As %String;

/// FHIRドキュメントの作成
ClassMethod CreateFHIRDocument(composition As Composition, attester As Practitioner = "") As Bundle
{
  set obj=..%New()
  set obj.type="document"
  set obj.timeStamp = $now()
  
  // bundleリソース管理クラスのインスタンスを取得
  set br=##class(FHIRTemplate.Util.BundleResource).%New()
  
  // 指定されたCompositionリソースから関連するリソースを取得
  do composition.GetResources(br)


  // 文書法的責任者が指定されていればそのリソースも登録
  if $isobject(attester) {
    set obj.attester=attester
    do br.AddResource(attester)
  }

  // 取得した関連リソースをBundleに登録
  do br.ExportResources(obj.resource)

  quit obj
}

/// ダイナミックオブジェクトへの出力
Method OutputToDynamicObject(ByRef obj As %DynamicAbstractObject) As %Status
{
  set ret=$$$OK
  try {

    // CertificateDataに証明書があれば、署名を追加する
    if ..CertificateData'="" {
      set ..signatureData=""
      set ..signatureDate=$ztimestamp
    }

    set obj=..Process($this,.ret)
    quit:$$$ISERR(ret)

    // CertificateDataに証明書があれば、署名を追加する
    if ..CertificateData'="" {
    	Set body=obj.%ToJSON()
    	Set body=$zcvt(body,"O","UTF8")
	    Set b64body=$$$BASE64URLENCODE(body)

	    Set b64header=$$$BASE64URLENCODE("{""typ"":""JWT"",""alg"":""RS256""}")

      set ret=##class(%OAuth2.JWK).RSAJWKtoASN1(..CertificateData,.privateKey)

    	Set sig=$SYSTEM.Encryption.RSASHASign(256,b64header_"."_b64body,privateKey)
    	If (sig="") {
    		Set ret=$$$ERROR($$$OAuth2RSASignatureError,$SYSTEM.Encryption.RSAGetLastError())
		    Quit
	    }
    	Set b64sig=$$$BASE64URLENCODE(sig)

      // 署名データの登録
	    set obj.signature.data=b64header_".."_b64sig
    }	
  } catch err {
    set ret=err.AsStatus()
  }
  if $$$ISERR(ret) {
    set obj=""
  }
  quit ret
}

}
