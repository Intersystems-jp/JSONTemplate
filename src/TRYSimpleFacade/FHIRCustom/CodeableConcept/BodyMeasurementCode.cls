Class FHIRCustom.CodeableConcept.BodyMeasurementCode Extends FHIRTemplate.DataType.CodeableConceptBase
{

Parameter CodeSystem = "urn:oid:1.2.392.200119.4.801";

/// コードからインスタンスを取得
ClassMethod GetByCode(name As %String, unit As %String) As FHIRCustom.CodeableConcept.BodyMeasurementCode
{
        set display=""
        &SQL(SELECT Code INTO :code FROM FHIRCustom_DB.BodyMeasurementCode WHERE Name = :name & Unit = :unit)
        if SQLCODE=0 {
                set obj=..%New()
                set obj.code=code
                set obj.display=name
                quit obj
        }
        quit ""
}

}
