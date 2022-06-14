Class FHIRTest.BundleTest
{

ClassMethod Test1()
{
    //#dim obj as FHIRTemplate.Bundle
    //set obj=##class(FHIRTemplate.Bundle).%New()
    //set obj.TimeStamp=$horolog

    #dim cobj as FHIRTemplate.Composition
    set cobj=##class(FHIRTemplate.Composition).%New()
    set cobj.docId="11112222"
    set cobj.docVer="1.0"
    set cobj.status=1
    set cobj.docType="18842-5" // 退院時サマリ
    set cobj.docCategory="18842-5" // 退院時サマリ

    set cobj.subject=..CreatePatient()
    set cobj.encounter=..CreateEncounter(cobj.subject)

    // 文書作成者
    set cobj.author=..CreateAuthor()
    set cobj.authorOrg=..CreateAuthorOrg()
    set cobj.custodian=cobj.authorOrg

    // セクション定義
    set sec300=##class(FHIRTemplate.Composition.section).%New()
    set sec300.title="構造情報",sec300.code=300,sec300.textDiv="こんな状況でした"
    do cobj.section.Insert(sec300)
    set sec322=##class(FHIRTemplate.Composition.section).%New()
    set sec322.title="入院詳細",sec322.code=322,sec322.textDiv="入院時の状況"
    do sec322.entry.Insert(cobj.encounter)
    do cobj.section.Insert(sec322)
    set sec342=##class(FHIRTemplate.Composition.section).%New()
    set sec342.title="入院時診断",sec342.code=342,sec342.textDiv="入院時の診断内容"
    do sec342.entry.Insert(..CreateCondition(cobj.subject,cobj.encounter))
    do cobj.section.Insert(sec342)

    set bundle=##class(FHIRTemplate.Bundle).CreateFHIRDocument(cobj)
    set ret=bundle.OutputToFile("c:\temp\bundle-test.json")
    if $$$ISOK(ret) {
        use 0 write "正常終了",!
    }else {
        use 0 write "エラー発生",!
        do $SYSTEM.OBJ.DisplayError(ret)
    }
}

ClassMethod CreatePatient() As FHIRTemplate.Patient
{
    #dim obj as FHIRTemplate.Patient
    set obj=##class(FHIRTemplate.Patient).%New()
    
    set obj.PatientId="11122"
    set obj.LastName="皆本",obj.FirstName="稔彦"
    set obj.LastNameKana="ミナモト",obj.FirstNameKana="トシヒコ"
    set obj.DOB=$zdateh("1968-10-02",3)
    set obj.Gender=1
    set obj.Address={"postalCode":"5300003","text":"大阪府大阪市北区堂島2-1-31"}
    set obj.Phone="06-4797-3388"
    quit obj
}

/// 入院情報
ClassMethod CreateEncounter(patient As FHIRTemplate.Patient) As FHIRTemplate.Encounter
{
    #dim obj as FHIRTemplate.Encounter
    set obj=##class(FHIRTemplate.Encounter).%New()
    set obj.encounterId="1311234567-2020-001234562022040200005"
    set obj.class="IMP"
    set obj.period={"startTime":($zdateh("2020-09-01",3)),"endTime":($zdateh("2020-09-18",3))}
    set obj.length={"value":7,"unit":"日","code":"d"}
    do obj.reasonCode.Insert(##class(FHIRCustom.CodeableConcept.ByomeiCode).GetByCode("B0EF"))
    set obj.admitSource=1 // 家庭からの入院

    set diag=##class(FHIRTemplate.Encounter.diagnosis).%New()
    set diag.condition=..CreateCondition(patient,obj)
    set diag.role="AD"
    set diag.rank=1
    do obj.diagnosis.Insert(diag)

    quit obj
}

/// 文書作成者
ClassMethod CreateAuthor() As FHIRTemplate.Practitioner
{
    #dim obj as FHIRTemplate.Practitioner
    set obj=##class(FHIRTemplate.Practitioner).%New()

    set obj.LastName="神奈川",obj.FirstName="花子"
    set obj.LastNameKana="カナガワ",obj.FirstNameKana="ハナコ"
    quit obj
}

/// 文書作成医療機関
ClassMethod CreateAuthorOrg() As FHIRTemplate.Practitioner
{
    #dim obj as FHIRTemplate.Organization
    set obj=##class(FHIRTemplate.Organization).%New()

    set obj.textDiv={"status":"generated","div":"文書作成医療機関"}
    set obj.prefNum="13" //都道府県番号
    set obj.tensuCode="1"
    set obj.hokenNum7="1234567"
    set obj.hokenNum10="1234567890"
    set obj.hospitalName="厚生労働省第一病院"
    set obj.phone="0120-012-0123"
    set obj.addressText="神奈川県横浜市港区１－２－３"
    set obj.addressZip="111-2222"
    return obj
}

ClassMethod CreateCondition(patient As FHIRTemplate.Patient, encounter As FHIRTemplate.Encounter) As FHIRTemplate.Condition
{
    set condition=##class(FHIRTemplate.Condition).%New()
    set condition.textDiv={"status":"additional","div":"こんな状況でした"}
    set condition.patientStatusValue="1311234567-2020-00123456"
    set condition.clinicalStatus="active"
    set condition.verificationStatus="provisional"
    set condition.code="B0EF"
    set condition.bodySite="1244"
    set condition.subject=patient,condition.encounter=encounter
    set condition.age={"value":10,"unit":"歳","code":"a"}
    set condition.recordedDate=$zdateh("2020-09-01",3)
    return condition
}

}
