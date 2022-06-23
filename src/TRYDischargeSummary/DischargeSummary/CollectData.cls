/// 退院時サマリー用データ収集クラス
Class DischargeSummary.CollectData
{

/// SQL実行用メソッド
/// SQLの引数は第3引数（可変長の引数で指定可能）
ClassMethod RunQuery(sql As %String(MAXLEN=1000), ByRef result As %DynamicObject, p1... As %String) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set stmt=##class(%SQL.Statement).%New()
        set stmt.%SelectMode=1  //ODBC形式選択
        $$$ThrowOnError(stmt.%Prepare(sql))
        //パラメータが2つ以上の場合（p1にサブスクリプトがある場合）
        if $data(p1)=11 {
            set rset=stmt.%Execute(p1...)
        }
        else {
            set rset=stmt.%Execute(p1)
        }
        //行移動しながらダイナミックオブジェクトを作る
        set result=[]
        while rset.%Next() {
            set record={}.%FromJSON(rset.%Get("json"))
            do result.%Push(record)
        }
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod SQLDummy()
{
    //Patient
    set sql="SELECT JSON_OBJECT('PatientId':PatientNumber, 'FirstName':FirstName, 'LastName':LastName, 'FirstNameKana':FirstNameKana, 'LastNameKana':LastNameKana, 'DOB':DOB, 'postalCode':Zip, 'text':Address, 'Phone':Tel, 'Gender':Gender) As json FROM ISJ.Patient where PatientNumber=?"
    //Encounter
    set sql="SELECT JSON_OBJECT('EncounterNumber':EncounterNumber,'DoctorNumber':DoctorNumber, 'PatientNumber':PatientNumber,'StartDate':StartDate,'EndDate':EndDate,'ReasonSystem':ReasonSystem,'ReasonCode':ReasonCode,'Reason':Reason) as json FROM ISJ.Encounter where EncounterNumber=? and DoctorNumber=?"
    set sql="SELECT JSON_OBJECT('EncounterNumber':EncounterNumber,'DoctorNumber':DoctorNumber, 'PatientNumber':PatientNumber,'StartDate':StartDate,'EndDate':EndDate,'ReasonSystem':ReasonSystem,'ReasonCode':ReasonCode,'Reason':Reason) as json FROM ISJ.Encounter where EncounterNumber=?"
    //Allergy
    set sql="SELECT JSON_OBJECT('AllergyNumber':AllergyNumber,'PatientNumber':PatientNumber,'DoctorNumber':DoctorNumber,'State':State,'ConfirmedState':ConfirmedState,'Type':Type,'Category':Category,'Criticality':Criticality,'Code':Code,'AllergyName':AllergyName) as json FROM ISJ.Allergy WHERE PatientNumber=?"
    //CarePlan
    set sql="SELECT JSON_OBJECT('PatientNumber':PatientNumber,'EncounterNumber':EncounterNumber,'DoctorNumber':DoctorNumber,'CareNumber':CareNumber,'StartDate':StartDate,'Details':Details) as json FROM ISJ.CarePlan Where EncounterNumber=?"
    //Condition
    set sql="SELECT JSON_OBJECT('ConditionNumber':ConditionNumber,'EncounterNumber':EncounterNumber,'PatientNumber':PatientNumber,'DoctorNumber':DoctorNumber,'Text':Text,'Code':Code,'Status':Status,'VelificationStatus':VelificationStatus,'RecordedDate':RecordedDate) as json FROM ISJ.Condition WHERE EncounterNumber=?"
    //Doctor
    set sql="SELECT JSON_OBJECT('DoctorNumber':DoctorNumber,'FirstName':FirstName,'LastName':LastName,'FirstNameKana':FirstNameKana,'LastNameKana':LastNameKana) as json FROM ISJ.Doctor WHERE DoctorNumber=?"
    //MedicationRequest
    set sql="SELECT JSON_OBJECT('OrderNumber':OrderNumber,'PatientNumber':PatientNumber,'DoctorNumber':DoctorNumber,'Category':Category,'UnitCode':UnitCode,'Unit':Unit,'SingleDose':SingleDose,'DailyAmount':DailyAmount,'DailyNumOfTimes':DailyNumOfTimes,'MedicationOrderDate':MedicationOrderDate,'TotalAmountDispence':TotalAmountDispence,'TotalDaysDispence':TotalDaysDispence,'MedicationCode':LTRIM(STR(MedicationCode)),'MedicationName':MedicationName,'Period':Period,'StartDate':StartDate,'RouteCode':RouteCode,'Route':Route) as json FROM ISJ.MedicationRequest where OrderNumber=?"
    //Organization
    set sql="SELECT JSON_OBJECT('OrgNumber':OrgNumber,'HospitalName':HospitalName,'PrefCode':LTRIM(STR(PrefCode,2)),'Zip':Zip,'Pref':Pref,'City':City,'Street':Street,'Phone':Phone,'Code':STR(Code,1),'InsuranceNum7':STR(InsuranceNum7,7),'InsuranceNum10':STR(InsuranceNum10,10)) as json FROM ISJ.Organization WHERE OrgNumber=?"
}

}
