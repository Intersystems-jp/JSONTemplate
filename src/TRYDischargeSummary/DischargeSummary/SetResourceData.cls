Class DischargeSummary.SetResourceData
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

/// 全体設定
///     diagnosis プロパティに　Conditionを入れる
///     hospitalizationOrginプロパティ に Organization入れる
ClassMethod Encounter(in As %DynamicObject, ByRef encounter As FHIRTemplate.Encounter) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set encounter=##class(FHIRTemplate.Encounter).%New()
        //Encounter.identifier.value
        set encounter.encounterId=in.EncounterNumber
        //Encounter.classHistory.class
        set encounter.class=##class(FHIRCustom.Coding.ActCode).GetByCode("IMP")
        //Encounter.period
        set period=##class(FHIRTemplate.DataType.Period).%New()
        set period.start=$ZDATEH(in.StartDate,3)
        set period.end=$ZDATEH(in.EndDate,3)
        set encounter.period=period
        //Encounter.length
        set length=##class(FHIRTemplate.DataType.Duration).%New()
        set length.value=+$system.SQL.Functions.DATEDIFF("dd",in.StartDate,in.EndDate)
        set length.unit="日"
        set length.code="d"
        set encounter.length=length
        //Encounter.reasonCode
        set reasonCode=##class(FHIRCustom.CodeableConcept.ByomeiCode).GetByCode(in.ReasonCode)
        do encounter.reasonCode.Insert(reasonCode)
        //Encounter.hospitalization.admitSource
        //set encounter.admitSource=##class(FHIRCustom.CodeableConcept.AdmitSource).GetByCode(1)
        set encounter.admitSource=1 // 家庭からの入院
        //Encounter.hospitalizationdischargeDisposition
        //set encounter.dischargeDisposition=##class(FHIRCustom.CodeableConcept.DischargeCode).GetByCode(1)
        set encounter.dischargeDisposition=1  //"1;傷病が治癒・軽快"
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod Patient(in As %DynamicObject, ByRef patient As FHIRTemplate.Patient) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set patient=##class(FHIRTemplate.Patient).%New(in)
        set patient.Gender=$select(in.Gender="Male":1,1:2)
        set address=##class(FHIRTemplate.DataType.Address).%New(in)
        set patient.Address=address
        /*
        set patient=##class(FHIRTemplate.Patient).%New()
     
        set address=##class(FHIRTemplate.DataType.Address).%New()
        set address.postalCode=in.postalCode
        set address.text=in.text
        set patient.Address=address
        set patient.DOB=in.DOB
        set patient.Gender=$select(in.Gender="Male":1,1:2)
        set patient.PatientId=in.PatientNumber
        set patient.LastName=in.LastName
        set patient.FirstName=in.FirstName
        set patient.LastNameKana=in.LastNameKana
        set patient.FirstNameKana=in.FirstNameKana
        set patient.Phone=in.Phone
        */
        
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod Doctor(in As %DynamicObject, ByRef practitioner As FHIRTemplate.Practitioner) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set practitioner=##class(FHIRTemplate.Practitioner).%New(in)
        /*
        set practitioner=##class(FHIRTemplate.Practitioner).%New()
        set practitioner.FirstName=in.FirstName
        set practitioner.LastName=in.LastName
        set practitioner.FirstNameKana=in.FirstNameKana
        set practitioner.LastNameKana=in.LastNameKana
        */
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod Organization(in As %DynamicObject, ByRef organization As FHIRTemplate.Organization) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set organization=##class(FHIRTemplate.Organization).%New()
        set textDiv=##class(FHIRTemplate.DataType.Narrative).%New()
        set textDiv.status="generated"
        set textDiv.div="<div xmlns='http://www.w3.org/1999/xhtml'>テスト組織です</div>"
        set organization.textDiv=textDiv
        set organization.prefNum=in.PrefCode
        set organization.tensuCode=in.Code
        set organization.hokenNum7=in.InsuranceNum7
        set organization.hokenNum10=in.InsuranceNum10
        set organization.hospitalName=in.HospitalName
        set organization.phone=in.Phone
        set organization.addressText=in.Pref_in.City_in.Street
        set organization.addressZip=in.Zip
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod MedicationRequest(in As %DynamicObject, ByRef medicationrequest As FHIRTemplate.MedicationRequest) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set medicationrequest=##class(FHIRTemplate.MedicationRequest).%New()
        set medicationrequest.TextDiv="<div xmlns='http://www.w3.org/1999/xhtml'>退院後に飲んでもらうお薬です</div>"
        set medicationrequest.AuthoredOn=$ZDATETIMEH(in.MedicationOrderDate,3)
        set MedicationCodeableConcept=##class(FHIRTemplate.DataType.CodeableConcept).%New()
        //Hot9のコードを入れる
        set MedicationCodeableConcept.system="urn:oid:1.2.392.200119.4.403.1"
        set MedicationCodeableConcept.code=in.MedicationCode
        set MedicationCodeableConcept.display=in.MedicationName
        set medicationrequest.MedicationCodeableConcept=MedicationCodeableConcept
        set DosageInstructionPeriod=##class(FHIRTemplate.DataType.PeriodNoEnd).%New()
        set DosageInstructionPeriod.start=in.StartDate
        set medicationrequest.DosageInstructionPeriod=DosageInstructionPeriod
        set DosageInstructionDuration=##class(FHIRTemplate.DataType.Duration).%New()
        set DosageInstructionDuration.value=+in.Period
        set DosageInstructionDuration.unit="日"
        set DosageInstructionDuration.code="d"
        set medicationrequest.DosageInstructionDuration=DosageInstructionDuration
        set medicationrequest.TimingEvent=in.StartDate  //開始日と一緒にしている
        set TimingRepetDuration=##class(FHIRTemplate.DataType.Duration).%New()
        set TimingRepetDuration.value=+in.Period
        set TimingRepetDuration.unit="日"
        set TimingRepetDuration.code="d"
        set medicationrequest.TimingRepetDuration=TimingRepetDuration
        set TimingCode=##class(FHIRTemplate.DataType.CodeableConcept).%New()
        set TimingCode.system=medicationrequest.#TimingCodeSystem
        set TimingCode.code="1012040400000000"
        set TimingCode.display=in.Route_"・1日"_in.DailyNumOfTimes_"回食後"
        set medicationrequest.TimingCode=TimingCode
        set Route=##class(FHIRTemplate.DataType.CodeableConcept).%New()
        set Route.system=medicationrequest.#RouteSystem
        set Route.code="PO"
        set Route.display=in.Route
        set medicationrequest.Route=Route
        set method=##class(FHIRTemplate.DataType.CodeableConcept).%New()
        set method.system=medicationrequest.#MethodSystem
        set method.code=1
        set method.display="内服"
        set DoseAndRateType=##class(FHIRTemplate.DataType.CodeableConcept).%New()
        set DoseAndRateType.system=medicationrequest.#DoseAndRateTypeSystem
        set DoseAndRateType.code="1"
        set DoseAndRateType.display="製剤量"
        set medicationrequest.DoseAndRateType=DoseAndRateType
        set DoseQuantity=##class(FHIRTemplate.DataType.SimpleQuantity).%New()
        set DoseQuantity.value=+in.SingleDose
        set DoseQuantity.unit=in.Unit
        set DoseQuantity.system="urn:oid:1.2.392.100495.20.2.101"
        set DoseQuantity.code="TAB"
        set medicationrequest.DoseQuantity=DoseQuantity
        set RateRatio=##class(FHIRTemplate.DataType.Quantity).%New()
        set RateRatio.value=+in.DailyAmount
        set RateRatio.unit=in.Unit
        set RateRatio.code="TAB"
        set medicationrequest.RateRatio=RateRatio
        set Denominator=##class(FHIRTemplate.DataType.Quantity).%New()
        set Denominator.value=1
        set Denominator.unit="日"
        set Denominator.code="d"
        set medicationrequest.Denominator=Denominator
        /*
        set DispenseRequestValueCodeableConcept=##class(FHIRTemplate.DataType.CodeableConcept).%New()
        set DispenseRequestValueCodeableConcept.system=medicationrequest.#DispenseRequestValueCodeableConceptSystem
        set DispenseRequestValueCodeableConcept.code="c"
        set DispenseRequestValueCodeableConcept.display="粉砕指示"
        set medicationrequest.DispenseRequestValueCodeableConcept=DispenseRequestValueCodeableConcept
        */
        set DispenseRequestQuantity=##class(FHIRTemplate.DataType.SimpleQuantity).%New()
        set DispenseRequestQuantity.value=+in.TotalAmountDispence
        set DispenseRequestQuantity.unit="錠"
        set DispenseRequestQuantity.system=medicationrequest.#DispenceRequestQuantitySystem
        set DispenseRequestQuantity.code="TAB"
        set medicationrequest.DispenseRequestQuantity=DispenseRequestQuantity
        set ExpectedSupplyDuration=##class(FHIRTemplate.DataType.Duration).%New()
        set ExpectedSupplyDuration.value=+in.TotalDaysDispence
        set ExpectedSupplyDuration.unit="日"
        set ExpectedSupplyDuration.code="d"
        set medicationrequest.ExpectedSupplyDuration=ExpectedSupplyDuration
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod AllergyIntolerance(in As %DynamicObject, ByRef allergy As FHIRTemplate.AllergyIntolerance) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set allergy=##class(FHIRTemplate.AllergyIntolerance).%New()
        set allergy.TextDiv="<div xmlns='http://www.w3.org/1999/xhtml'>申告されたアレルギーです</div>"
        set allergy.IdentifierValue=in.AllergyNumber
        /*
        //以下コード利用時は、ClinicalStatusのタイプを FHIRTemplate.DataType.CodeableConceptに変更すること
        set ClinicalStatus=##class(FHIRTemplate.DataType.CodeableConcept).%New()
        set ClinicalStatus.system="http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical"
        set ClinicalStatus.code=in.State
        set ClinicalStatus.display=$select(in.State="active":"現存",in.State="inactive":"非現存",in.State="resolved":"解消",1:"")
        set allergy.ClinicalStatus=ClinicalStatus
        */
        set allergy.ClinicalStatus=in.State
        
        /*
        //以下コード利用時は、VerificationlStatusのタイプを FHIRTemplate.DataType.CodeableConceptに変更すること
        set VerificationStatus=##class(FHIRTemplate.DataType.CodeableConcept).%New()
        set VerificationStatus.system="http://terminology.hl7.org/CodeSystem/allergyintolerance-verification"
        set vs=in.ConfirmedState
        set VerificationStatus.code=vs
        set VerificationStatus.display=$select(vs="unconfirmed":"未確認",vs="confirmed":"確認済",vs="refuted":"否定",vs="entered-in-error":"エラー",1:"")
        set allergy.VerificationStatus=VerificationStatus
        */
        set allergy.VerificationStatus=in.ConfirmedState
        
        set allergy.Type=in.Type
        set allergy.Category=in.Category
        set allergy.Criticality=in.Criticality
        set Code=##class(FHIRTemplate.DataType.CodeableConcept).%New()
        set Code.system="http://jpfhir.jp/fhir/AllergyIntolerance/CodeSystem/allergy-substance"
        set Code.code="J7F7111190"  //適当なコード
        set Code.display=in.AllergyName
        set allergy.Code=Code
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod CarePlan(in As %DynamicObject, ByRef careplan As FHIRTemplate.CarePlan) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set careplan=##class(FHIRTemplate.CarePlan).%New()
        set careplan.TextDiv="<div xmlns='http://www.w3.org/1999/xhtml'>こんな計画です</div>"
        set careplan.IdentifierValue=in.CareNumber
        set careplan.Status="active"
        set careplan.Intent="plan"
        set category=##class(FHIRTemplate.DataType.CodeableConcept).%New()
        set category.system=careplan.#CategorySystem
        set category.code="736285004"
        set category.display=$piece(careplan.#CategoryDisplay,",",1)
        set careplan.Category=category
        set careplan.Description=in.Details
        set careplan.CreationTime=$ZDATETIMEH(in.StartDate,3)
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod Condition(in As %DynamicObject, ByRef condition As FHIRTemplate.Condition) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
    set condition=##class(FHIRTemplate.Condition).%New()
    set textDiv=##class(FHIRTemplate.DataType.Narrative).%New()
    set textDiv.status="generated"
    set textDiv.div="<div xmlns='http://www.w3.org/1999/xhtml'>こんな状況でした</div>"
    set condition.textDiv=textDiv
    set condition.patientStatusValue="1311234567-2020-00123456"
    set condition.clinicalStatus=in.Status
    //set clinicalstatus=##class(FHIRCustom.CodeableConcept.ClinicalStatus).GetByCode(in.Status)
    //set condition.clinicalStatus=clinicalstatus
    //set verificationStatus=##class(FHIRCustom.CodeableConcept.VerificationStatus).GetByCode(in.VerificationStatus)
    set condition.verificationStatus=in.VerificationStatus

    //set code=##class(FHIRCustom.CodeableConcept.ByomeiCode).GetByCode(in.Code)
    set condition.code=in.Code
    set condition.recordedDate=$ZDATEH(in.RecordedDate,3)
    /*
    set bodysite=##class(FHIRTemplate.DataType.CodeableConcept).%New()
    set bodysite.system="urn:oid:1.2.392.200119.4.201.5"
    set bodysite.code="1244"
    set bodysite.display="腹部"
    set condition.BodySite=bodysite
    */

    /*
    set age=##class(FHIRTemplate.DataType.Age).%New()
    set age.value=10
    set age.unit="歳"
    set age.code="a"
    set condition.Age=age
    */
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod Composition(ByRef composition As FHIRTemplate.Composition) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set composition=##class(FHIRTemplate.Composition).%New()
        set composition.docVer="1.0"
        set composition.docId="1311234567-2020-00123456"
        set composition.status=1
        set composition.docType="18842-5" // 退院時サマリ
        set composition.docCategory="18842-5" // 退院時サマリ
        set composition.title="退院時サマリー"
        set composition.date=$H
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

}
