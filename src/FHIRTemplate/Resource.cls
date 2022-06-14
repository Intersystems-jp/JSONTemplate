/// 患者リソース
Class FHIRTemplate.Resource Extends (FHIRTemplate.ResourceBase, FHIRTemplate.Bundle.entry)
{

/// JSON出力する際のテンプレート)
/// JSONの値の文字列に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
XData Template [ MimeType = application/json ]
{
{
  "resourceType": "#(..#ResourceType)#",
  "meta": {
    "profile": ["#(..#Profile)#"]
  }
}
}

Parameter ResourceType = "Resource";

Parameter Profile;

Method GetResources(br As FHIRTemplate.Util.BundleResource) As %Integer
{
  // 自分自身を登録
  quit br.AddResource($this)
}

}
