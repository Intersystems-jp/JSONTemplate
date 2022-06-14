Class FHIRTest.PatientTest
{

ClassMethod Test1()
{
    #dim obj as FHIRTemplate.Patient
    set obj=##class(FHIRTemplate.Patient).%New()
    set obj.ProfileURI="http://jpfhir.jp/fhir/eClinicalSummary/StructureDefinition/JP_Patient_eClinicalSummary"
    set obj.PatientId="11122"
    set obj.LastName="鈴木",obj.FirstName="喜朗"
    set obj.LastNameKana="スズキ",obj.FirstNameKana="ヨシロウ"
    set obj.DOB=$zdateh("1952-09-13",3)
    set obj.Gender=1
    set obj.Address={
        "line":"堂島2-1-31 京阪堂島ビル 4F",
        "city":"大阪市北区",
        "state":"大阪府",
        "postalCode":"530-0003"}
    set obj.Phone="06-4797-3388"
    set ret=obj.OutputToFile("c:\temp\patient.json")
    if $$$ISOK(ret) {
        use 0 write "正常終了",!
    } else {
        use 0 write "エラー発生",!
        do $SYSTEM.OBJ.DisplayError(ret)
    }
}

}
