/// 文書タイプ
Class FHIRCustom.CodeableConcept.DocType Extends FHIRTemplate.DataType.CodeableConceptBase
{

Parameter CodeSystem = "http://jpfhir.jp/fhir/Common/CodeSystem/doc-typecodes";

/// コードからインスタンスを取得
ClassMethod GetByCode(code As %String) As FHIRTemplate.DataType.CodeableConceptBase
{
    set obj=..%New()
    if code="18842-5" {
        set obj.code=code
        set obj.display="退院時サマリー"
    } else {
        set obj.code="57133-1"
        set obj.display="診療情報提供書"
    }
    quit obj
}

}
