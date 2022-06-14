Class FHIRCustom.Coding.JLAC10Code Extends FHIRTemplate.DataType.CodingBase
{

Parameter CodeSystem = "http://jpfhir.jp/fhir/eCheckup/CodeSystem/jlac10";

/// コードからインスタンスを取得
ClassMethod GetByCode(code As %String) As JLAC10Code
{
        set display=""
        &SQL(SELECT Name INTO :display FROM FHIRMaster.JLAC10Code WHERE code = :code)
        if SQLCODE=0 {
                set obj=..%New()
                set obj.display=display
                quit obj
        }
        quit ""
}

}
