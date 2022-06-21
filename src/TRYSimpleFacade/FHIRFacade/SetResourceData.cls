Class FHIRFacade.SetResourceData
{

ClassMethod Validate(in As %DynamicObject) As %Status
{
	#dim ex As %Exception.AbstractException
	set tSC=$$$OK
	try {
		set schema = ##class(HS.FHIRServer.Schema).LoadSchema("HL7v40")
		set resourceValidator = ##class(HS.FHIRServer.Util.ResourceValidator).%New(schema)
		do resourceValidator.ValidateResource(in) 
	}catch ex {
		set tSC=ex.AsStatus()
	}
	quit tSC
}

ClassMethod Patient(in As %DynamicObject, ByRef patient As FHIRTemplate.Patient) As %Status
{
    /*
    ＜演習＞
    Patientリソースのインスタンスを生成しデータをセットします。
    */
    set patient=##class(FHIRTemplate.Patient).%New(in)
    
    //住所情報をセットします
    set address=##class(FHIRTemplate.DataType.Address).%New(in)
    set patient.Address=address

    //genderをFHIRリソースの形式に変換します（以下の行のコメントを外します）
    set patient.Gender=$select(patient.Gender="Male":1,1:2)
    return $$$OK
}

ClassMethod ObservationBodyMeasurement(in As %DynamicObject, ByRef observation As FHIRCustom.ObservationBodyMeasurement) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        // Observationリソースのインスタンスを生成します。
        set observation=##class(FHIRCustom.ObservationBodyMeasurement).%New()
        //　Codeプロパティに A) か　B)　の方法を利用して値を割り当てます

        // A)　CodeableConceptのタイプのCodeを作成します。（以下複数行のコメントを外します）
        /*
        //手動で値を割り当てる方法
        set code=##class(FHIRCustom.CodeableConcept.BodyMeasurementCode).%New()
        set code.code=in.code
        set code.display=in.display
        */

        // B)　CodeableConceptのタイプのCodeに、マスターから情報を取得して割り当てる（以下1行コメントを外します）
        set code=##class(FHIRCustom.CodeableConcept.BodyMeasurementCode).GetByCode(in.display,in.unit)      
        set observation.Code=code
        // EffectiveDateTimeに値を設定する
        set observation.EffectiveDateTime=$ZDATETIMEH(in.EffectiveDateTime,3)
        // valueQuantityの値を設定する
        set valueQuantity=##class(FHIRTemplate.DataType.Quantity).%New()
        set valueQuantity.value=+in.value
        set valueQuantity.unit=in.unit
        set valueQuantity.code=code.code
        set observation.ValueQuantity=valueQuantity
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

}
