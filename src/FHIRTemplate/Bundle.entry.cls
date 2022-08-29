/// Bundle Entry
/// Bundle内でリソースを保持する
Class FHIRTemplate.Bundle.entry Extends FHIRTemplate.ResourceBase
{

/// JSON出力する際のテンプレート
/// JSONの値の文字列に#(..プロパティ名)#または#(..#パラメータ名)#を指定することで
/// プロパティの値をJSON形式で出力できます。
/// プロパティの型がJSONTemplate.Baseを継承したクラスの場合、
/// そのクラスのテンプレートからJSON出力します。
XData Template [ MimeType = application/json ]
{
{
	"fullUrl": "urn:uuid:#(..ResourceId)#",
	"resource": "#($this)#",
	"request": {
		"method": "#(..requestMethod)#",
		"url": "#(..requestUrl)#"
	}
}
}

Property requestMethod As %String;

Property requestUrl As %String;

}
