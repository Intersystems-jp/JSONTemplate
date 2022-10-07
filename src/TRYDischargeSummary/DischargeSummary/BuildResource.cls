Class DischargeSummary.BuildResource
{

Parameter OrganizationNumber = "Org001";

ClassMethod Test(dir As %String = "", ByRef json As %DynamicObject)
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set input={}
        set input.PatientNumber="P0003"
        set input.DoctorNumber="DC001"
        set input.EncounterNumber="EN0003"
        set input.MedicationOrderNumber="ORD003"
        set fname=##class(%File).NormalizeDirectory(dir)_"DischargeSummary-bundle.json"
        $$$ThrowOnError(..Bundle(input,.json,fname))
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

/// 退院時サマリー用Bundleリソース作成＋検証
/// 
/// 第1引数：サマリー作成の条件セット（JSONのダイナミックオブジェクト）
///     サンプルで使用するJSONオブジェクトのプロパティは以下の通り
///     PatientNumber,DoctorNumber,EncounterNumber,MedicationOrderNumber
/// 第2引数：参照渡し　作成したBundleリソース（JSONのダイナミックオブジェクト）
/// 第3引数：参照渡し　QuickStreamに保存した時のIDが返る
/// 
/// メモ：サンプルではSQLで取得した情報の1件目のみを使用しています
ClassMethod Bundle(input As %DynamicObject, ByRef json As %DynamicObject, fname As %String) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        //Patient情報取得
        set sql="SELECT JSON_OBJECT('PatientId':PatientNumber, 'FirstName':FirstName, 'LastName':LastName, 'FirstNameKana':FirstNameKana, 'LastNameKana':LastNameKana, 'DOB':DOB, 'postalCode':Zip, 'text':Address, 'Phone':Tel, 'Gender':Gender) As json FROM ISJ.Patient where PatientNumber=?"
        $$$ThrowOnError(##class(DischargeSummary.CollectData).RunQuery(sql,.rset,input.PatientNumber))
        $$$ThrowOnError(##class(DischargeSummary.SetResourceData).Patient(rset.%Get(0),.patient))
        kill rset

        //Encounter情報取得
        set sql="SELECT JSON_OBJECT('EncounterNumber':EncounterNumber,'DoctorNumber':DoctorNumber, 'PatientNumber':PatientNumber,'StartDate':StartDate,'EndDate':EndDate,'ReasonSystem':ReasonSystem,'ReasonCode':ReasonCode,'Reason':Reason) as json FROM ISJ.Encounter where EncounterNumber=?"
        $$$ThrowOnError(##class(DischargeSummary.CollectData).RunQuery(sql,.rset,input.EncounterNumber))
        $$$ThrowOnError(##class(DischargeSummary.SetResourceData).Encounter(rset.%Get(0),.encounter))
        kill rset

        //Doctor情報取得
        set sql="SELECT JSON_OBJECT('DoctorNumber':DoctorNumber,'FirstName':FirstName,'LastName':LastName,'FirstNameKana':FirstNameKana,'LastNameKana':LastNameKana) as json FROM ISJ.Doctor WHERE DoctorNumber=?"
        $$$ThrowOnError(##class(DischargeSummary.CollectData).RunQuery(sql,.rset,input.DoctorNumber))
        $$$ThrowOnError(##class(DischargeSummary.SetResourceData).Doctor(rset.%Get(0),.practitioner))
        kill rset
    
        //Organization情報取得
        set sql="SELECT JSON_OBJECT('OrgNumber':OrgNumber,'HospitalName':HospitalName,'PrefCode':LTRIM(STR(PrefCode,2)),'Zip':Zip,'Pref':Pref,'City':City,'Street':Street,'Phone':Phone,'Code':STR(Code,1),'InsuranceNum7':STR(InsuranceNum7,7),'InsuranceNum10':STR(InsuranceNum10,10)) as json FROM ISJ.Organization WHERE OrgNumber=?"
        $$$ThrowOnError(##class(DischargeSummary.CollectData).RunQuery(sql,.rset,..#OrganizationNumber))
        $$$ThrowOnError(##class(DischargeSummary.SetResourceData).Organization(rset.%Get(0),.organization))
        kill rset

        //MedicationRequest情報取得
        set sql="SELECT JSON_OBJECT('OrderNumber':OrderNumber,'PatientNumber':PatientNumber,'DoctorNumber':DoctorNumber,'Category':Category,'UnitCode':UnitCode,'Unit':Unit,'SingleDose':SingleDose,'DailyAmount':DailyAmount,'DailyNumOfTimes':DailyNumOfTimes,'MedicationOrderDate':MedicationOrderDate,'TotalAmountDispence':TotalAmountDispence,'TotalDaysDispence':TotalDaysDispence,'MedicationCode':LTRIM(STR(MedicationCode)),'MedicationName':MedicationName,'Period':Period,'StartDate':StartDate,'RouteCode':RouteCode,'Route':Route) as json FROM ISJ.MedicationRequest where OrderNumber=?"
        $$$ThrowOnError(##class(DischargeSummary.CollectData).RunQuery(sql,.rset,input.MedicationOrderNumber))
        $$$ThrowOnError(##class(DischargeSummary.SetResourceData).MedicationRequest(rset.%Get(0),.medicationrequest))
        kill rset

        //Condition情報取得
        set sql="SELECT JSON_OBJECT('ConditionNumber':ConditionNumber,'EncounterNumber':EncounterNumber,'PatientNumber':PatientNumber,'DoctorNumber':DoctorNumber,'Text':Text,'Code':Code,'Status':Status,'VelificationStatus':VelificationStatus,'RecordedDate':RecordedDate) as json FROM ISJ.Condition WHERE EncounterNumber=?"
        $$$ThrowOnError(##class(DischargeSummary.CollectData).RunQuery(sql,.rset,input.EncounterNumber))
        $$$ThrowOnError(##class(DischargeSummary.SetResourceData).Condition(rset.%Get(0),.condition))
        kill rset

        //Allergy情報取得
        set sql="SELECT JSON_OBJECT('AllergyNumber':AllergyNumber,'PatientNumber':PatientNumber,'DoctorNumber':DoctorNumber,'State':State,'ConfirmedState':ConfirmedState,'Type':Type,'Category':Category,'Criticality':Criticality,'Code':Code,'AllergyName':AllergyName) as json FROM ISJ.Allergy WHERE PatientNumber=?"
        $$$ThrowOnError(##class(DischargeSummary.CollectData).RunQuery(sql,.rset,input.PatientNumber))
        $$$ThrowOnError(##class(DischargeSummary.SetResourceData).AllergyIntolerance(rset.%Get(0),.allergy))
        kill rset

        //CarePlan情報取得
        set sql="SELECT JSON_OBJECT('PatientNumber':PatientNumber,'EncounterNumber':EncounterNumber,'DoctorNumber':DoctorNumber,'CareNumber':CareNumber,'StartDate':StartDate,'Details':Details) as json FROM ISJ.CarePlan Where EncounterNumber=?"
        $$$ThrowOnError(##class(DischargeSummary.CollectData).RunQuery(sql,.rset,input.EncounterNumber))
        $$$ThrowOnError(##class(DischargeSummary.SetResourceData).CarePlan(rset.%Get(0),.careplan))
        kill rset

        /*　リファレンスを設定する */ 

        /*
        Encounter referenceの設定
            Condision: DiagnosisCondition
            Organization: HospitalizationOrigin
        */
        //set encounter.diagnosisCondition=condition
        set encounter.hospitalizationOrigin=organization
        
        /*
        Condition reference の設定
            subject: Patientリソース
            encounter: Encounterリソース
            evidence: Encounterリソース
        */
        set condition.subject=patient
        set condition.encounter=encounter
        set evidence=##class(FHIRCustom.Evidence).%New()
        set evidence.code=encounter.reasonCode.GetAt(1)
        set evidence.detail=encounter
        do condition.evidence.Insert(evidence)

        /*
        CarePlan referenceの設定
            subject: Patientリソース
            encounter: Encounterリソース
            author: Practitionerリソース
        */
        set careplan.Patient=patient
        set careplan.Encounter=encounter
        set careplan.Practitioner=practitioner

        /*
        MedicationRequest reference の設定
            subject: Patient リソース
        */
        set medicationrequest.Patient=patient

        /*
        AllertyIntolerance referenceの設定
        */
        set allergy.Patient=patient
        set allergy.Encounter=encounter       


        //Composition作成
        //$$$ThrowOnError(##class(DischargeSummary.SetResourceData).Composition(.composition))
        set composition=##class(FHIRTemplate.Composition).%New()
        set composition.docVer="1.0"
        set composition.docId="1311234567-2020-00123456"
        set composition.status=1
        set composition.docType="18842-5" // 退院時サマリ
        set composition.docCategory="18842-5" // 退院時サマリ
        set composition.title="退院時サマリー"
        set composition.date=$H
        set composition.subject=patient
        set composition.encounter=encounter
        set composition.author=practitioner
        set composition.custodian=organization

        //Compositionのセクション作成
        // セクション定義
        set sec300=##class(FHIRTemplate.Composition.section).%New()
        set sec300.title="構造情報",sec300.code=300,sec300.textDiv="<div xmlns=""http://www.w3.org/1999/xhtml"">こんな状況でした</div>"
        do composition.section.Insert(sec300)
        set sec322=##class(FHIRTemplate.Composition.section).%New()
        set sec322.title="入院詳細",sec322.code=322,sec322.textDiv="<div xmlns=""http://www.w3.org/1999/xhtml"">入院時の状況</div>"
        do sec322.entry.Insert(composition.encounter)
        do sec300.section.Insert(sec322)        
        set sec342=##class(FHIRTemplate.Composition.section).%New()
        set sec342.title="入院時診断",sec342.code=342,sec342.textDiv="<div xmlns=""http://www.w3.org/1999/xhtml"">入院時の診断内容</div>"
        do sec342.entry.Insert(condition)
        do sec300.section.Insert(sec342) 
        
        set sec510=##class(FHIRTemplate.Composition.section).%New()
        set sec510.title="アレルギー・不耐性反応",sec510.code=510,sec510.textDiv="<div xmlns=""http://www.w3.org/1999/xhtml"">アレルギー情報です</div>"
        do sec510.entry.Insert(allergy)
        do sec300.section.Insert(sec510)
        set sec352=##class(FHIRTemplate.Composition.section).%New()
        set sec352.title="入院時主訴",sec352.code=352,sec352.textDiv="<div xmlns=""http://www.w3.org/1999/xhtml"">入院時主訴です。</div>"
        do sec352.entry.Insert(condition)
        do sec300.section.Insert(sec352)
        set sec312=##class(FHIRTemplate.Composition.section).%New()
        set sec312.title="入院理由",sec312.code=312,sec312.textDiv="<div xmlns=""http://www.w3.org/1999/xhtml"">入院理由です。</div>"
        do sec312.entry.Insert(encounter)
        do sec300.section.Insert(sec312)
        set sec362=##class(FHIRTemplate.Composition.section).%New()
        set sec362.title="入院時現病歴",sec362.code=362,sec362.textDiv="<div xmlns=""http://www.w3.org/1999/xhtml"">入院時現病歴です。</div>"
        do sec362.entry.Insert(condition)
        do sec300.section.Insert(sec362)
        set sec324=##class(FHIRTemplate.Composition.section).%New()
        set sec324.title="退院時詳細",sec324.code=324,sec324.textDiv="<div xmlns=""http://www.w3.org/1999/xhtml"">退院時詳細です。</div>"
        do sec324.entry.Insert(encounter)
        do sec300.section.Insert(sec324)
        set sec444=##class(FHIRTemplate.Composition.section).%New()
        set sec444.title="退院時投薬指示",sec444.code=444,sec444.textDiv="<div xmlns=""http://www.w3.org/1999/xhtml"">退院時投薬指示です。</div>"
        do sec444.entry.Insert(medicationrequest)
        do sec300.section.Insert(sec444)
        set sec424=##class(FHIRTemplate.Composition.section).%New()
        set sec424.title="退院時方針指示",sec424.code=424,sec424.textDiv="<div xmlns=""http://www.w3.org/1999/xhtml"">退院時方針指示です。</div>"
        do sec424.entry.Insert(careplan)
        do sec300.section.Insert(sec424)

        // FHIRドキュメントの作成（Bundle作成）
        set bundle=##class(FHIRTemplate.Bundle).CreateFHIRDocument(composition,practitioner)
        
        /*
        // bundleへの追加
        set bundle.Composition=composition
        set bundle.Patient=patient
        set bundle.Practitioner=practitioner
        set bundle.Organization=organization
        set bundle.Encounter=encounter
        set bundle.Condition=condition
        set bundle.CarePlan=careplan
        set bundle.MedicationRequest=medicationrequest
        set bundle.AllergyIntolerance=allergy
        */
        //set bundle.When=$Horolog
        //set bundle.PractitionerResourceId=practitioner.ResourceId

        set bundle.signatureDate=$Horolog
        /*
        //以下DBに仮登録したい場合利用
        //QuickStreamに作成したBundleリソースを保存
        set bundleQS=##class(HS.SDA3.QuickStream).%New()
        set QuickStreamId=bundleQS.%Id()
        $$$ThrowOnError(bundle.OutputToStream(bundleQS))
        //検証実行のため、QuickStreamに保存したBundleリソースをJSONのダイナミックオブジェクトに変換
        set json={}.%FromJSON(bundleQS)
        */
        //ファイル出力
        $$$ThrowOnError(bundle.OutputToFile(fname))
        $$$ThrowOnError(bundle.OutputToDynamicObject(.json))
        //検証実行
        $$$ThrowOnError(##class(DischargeSummary.SetResourceData).Validate(json))
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

}
