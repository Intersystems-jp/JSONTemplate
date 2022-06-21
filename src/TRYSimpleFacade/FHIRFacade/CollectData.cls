Class FHIRFacade.CollectData
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
    set sql="SELECT JSON_OBJECT('PatientId':PID, 'FirstName':Given, 'LastName':Family, 'FirstNameKana':GivenKana, 'LastNameKana':FamilyKana, 'DOB':DOB, 'Phone':Tel, 'Gender':Gender,'postalCode':Zip,'state':Pref,'city':City,'line':Address) As json FROM ISJHospital.Patient where PID=?"
    //Observation
    set sql="SELECT JSON_OBJECT('code':LabTestCode, 'display':LabTestText, 'value':Value, 'unit':Unit, 'EffectiveDateTime':LabTestDateTime) as json FROM ISJHospital.Observation WHERE PID=?"
}

}
