/// セクション
///  CompositionリソースのSection部分
Class FHIRTemplate.Composition.section Extends JSONTemplate.Base
{

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
  "title": "#(..title)#",
  "code": "#(..code(FHIRCustom.CodeableConcept.DocSectionCode))#",
  "text": {
    "status":"additional",
    "div":"#(..textDiv)#"
  },
  "entry":[
    "#(..entry(FHIRTemplate.Reference))#"
  ],
  "section":[
    "#(..section)#"
  ]
}
}

Property status As %Integer(DISPLAYLIST = ",generated,extensions,additional,empty", VALUELIST = ",3,2,1,0");

Property textDiv As %String(MAXLEN = "");

Property title As %String;

Property code As %String;

Property entry As list Of FHIRTemplate.Resource;

Property date As FHIRTemplate.DataType.TimeStamp(FORMAT = 1);

Property section As list Of FHIRTemplate.Composition.section;

/// セクションの作成
ClassMethod CreateSection(code As %String, title As %String = "", ByRef sc As %Status) As section
{
  set sc=$$$OK
  set obj=..%New()
  set obj.code=##class(FHIRCustom.CodeableConcept.DocSectionCode).GetByCode(code)
  set obj.title=$select(title'="":title,1:obj.code.display)
  quit obj
}

/// リソースの取得
Method GetResources(br As FHIRTemplate.Util.BundleResource) As %Integer
{
  set key="" for {
    set entry=..entry.GetNext(.key)
    quit:key=""

    do entry.GetResources(br)
  }
  set key="" for {
    set section=..section.GetNext(.key)
    quit:key=""

    do section.GetResources(br)
  }
}

}
