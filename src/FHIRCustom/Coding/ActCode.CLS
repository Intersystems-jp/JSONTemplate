/// 入院外来分類
Class FHIRCustome.Coding.ActCode Extends FHIRTemplate.DataType.CodingBase
{

Parameter CodeSystem = "http://terminology.hl7.org/CodeSystem/v3-ActCode";

/// コードからインスタンスを取得
ClassMethod GetByCode(code As %String) As FHIRTemplate.DataType.CodingBase
{
    set obj=..%New()
    if code="IMP" {
        set obj.code=code
        set obj.display="入院"
    } else {
        set obj.code="AMB"
        set obj.display="外来"
    }
    quit obj
}

}
