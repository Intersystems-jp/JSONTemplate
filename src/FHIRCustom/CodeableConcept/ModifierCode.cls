/// MEDIS標準病名マスターの修飾語交換用コード
Class FHIRCustom.CodeableConcept.ModifierCode Extends FHIRTemplate.DataType.CodeableConceptBase
{

Parameter CodeSystem = "urn:oid:1.2.392.200119.4.201.5";

/// コードからインスタンスを取得
ClassMethod GetByCode(code As %String) As FHIRCustom.CodeableConcept.ModifierCode
{
        set display=""
        &SQL(SELECT Name INTO :display FROM FHIRCustom_DB.ModifierCode WHERE code = :code)
        if SQLCODE=0 {
                set obj=..%New()
                set obj.code=code
                set obj.display=display
                quit obj
        }
        quit ""
}

}
