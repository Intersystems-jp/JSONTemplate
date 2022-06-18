Class FHIRFacade.BuildResource
{

ClassMethod Test(ByRef json As %DynamicObject)
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set input={}
        set input.PID="498374"
        $$$ThrowOnError(..Bundle(input,.json,.streamid))
        //write streamid
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod Patient(input As %DynamicObject, ByRef json As %DynamicObject, ByRef QuickStreamId As %String) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        /*
        ＜演習＞
        Patientリソース用データ取得のためのSQLを記述します。
        患者を特定する患者番号が第1引数にダイナミックオブジェクトとして渡される予定です。
         SELECTのWHEREに記述する条件（PID=xxxx）の引数は置き換え文字として ? を使用できます。
        */
        set sql="SELECT JSON_OBJECT('PatientId':PID, 'FirstName':Given, 'LastName':Family, 'FirstNameKana':GivenKana, 'LastNameKana':FamilyKana, 'DOB':DOB, 'PostalCode':Zip, 'Address':Pref||City||Address, 'Phone':Tel, 'Gender':Gender) As json FROM ISJHospital.Patient where PID=?"

        /*
        第1引数は組み立てたSQL文、第2引数は検索結果のダイナミックオブジェクトが設定されます。
        第3引数はSELECTの入力引数（条件）を指定します。
        */
        $$$ThrowOnError(##class(FHIRFacade.CollectData).RunQuery(sql,.rset,input.PID))
        
        //指定した患者が存在しない時はエラーメッセージを作成し、CATCHへ移動します
        if rset.%Size()=0 {
            throw ##class(%Exception.General).%New(5001,"指定の患者ID："_input.PID_"の患者は存在しません")
        }

        /*
        第1引数に検索結果のダイナミックオブジェクトを指定します。
        第2引数は参照渡しで、呼び出し先で作成したPatientリソースのダイナミックオブジェクトが設定されます。
        */
        $$$ThrowOnError(##class(FHIRFacade.SetResourceData).Patient(rset.%Get(0),.patient))
        kill rset
        
        //サンプルデータの性別の形式がFHIRリソースに合わないため、変更しています。
        set patient.Gender=$select(patient.Gender="Male":1,1:2)

        /*
        //以下DBに一旦保存したい場合の方法
        //QuickStreamに作成したPatientリソースを保存します。
        set patientQS=##class(HS.SDA3.QuickStream).%New()
        set QuickStreamId=patientQS.%Id()
        //作成したBundleリソースをストリームにコピー
        $$$ThrowOnError(patient.OutputToStream(patientQS))
        //検証実行のため、QuickStreamに保存したBundleリソースをJSONのダイナミックオブジェクトに変換
        set json={}.%FromJSON(patientQS)
        */
        
        //patientインスタンスをダイナミックオブジェクトに出力
        $$$ThrowOnError(patient.OutputToDynamicObject(.json))
        //検証実行
        $$$ThrowOnError(##class(FHIRFacade.SetResourceData).Validate(json))
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod Bundle(input As %DynamicObject, ByRef json As %DynamicObject, ByRef QuickStreamId As %String) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        /*
        ＜演習＞
        Bundleのインスタンスを生成します（以下の1行コメントを外します）
        */
        set bundle=##class(FHIRCustom.BundlePatientObservation).%New()

        //Patient情報取得
        set sql="SELECT JSON_OBJECT('PatientId':PID, 'FirstName':Given, 'LastName':Family, 'FirstNameKana':GivenKana, 'LastNameKana':FamilyKana, 'DOB':DOB, 'PostalCode':Zip, 'Address':Pref||City||Address, 'Phone':Tel, 'Gender':Gender) As json FROM ISJHospital.Patient where PID=?"
        $$$ThrowOnError(##class(FHIRFacade.CollectData).RunQuery(sql,.rset,input.PID))
        if rset.%Size()=0 {
            throw ##class(%Exception.General).%New(5001,"指定の患者ID："_input.PID_"の患者は存在しません")
        }
        $$$ThrowOnError(##class(FHIRFacade.SetResourceData).Patient(rset.%Get(0),.patient))
        kill rset

        //BundleにPatientリソースを割り当てる
        do bundle.resource.Insert(patient)

        kill rset
        /*
        ＜演習＞
        Observationリソース用データ取得のためのSQLを記述します。
        指定された患者番号に紐づくObservationを取得したいので、患者番号を含むダイナミックオブジェクトを第1引数に渡す予定です。
        SELECTのWHEREに記述する条件（PID=xxxx）の引数は置き換え文字として ? を使用できます。
        */
        set sql="SELECT JSON_OBJECT('code':LabTestCode, 'display':LabTestText, 'value':Value, 'unit':Unit, 'EffectiveDateTime':LabTestDateTime) as json FROM ISJHospital.Observation WHERE PID=?"

        /*
        第1引数に検索結果のダイナミックオブジェクトを指定します。
        第2引数は参照渡しで、呼び出し先で作成したOvservationリソースのダイナミックオブジェクトが設定されます。
        */
        $$$ThrowOnError(##class(FHIRFacade.CollectData).RunQuery(sql,.rset,input.PID))

        //件数を取得
        set observationcount=rset.%Size()

        //検索結果分のObservationリソースを作成し、Bundleに追加しています（JSON配列は0番からスタート）
        for i=0:1:(observationcount-1) {
            $$$ThrowOnError(##class(FHIRFacade.SetResourceData).ObservationBodyMeasurement(rset.%Get(i),.observation))
            //Patientのリファレンスを登録
            set observation.Patient=patient
            //BundleにObservationリソース割り当てる
            do bundle.resource.Insert(observation)
            kill observation
        }

        //Bundleに検索結果数を登録します。
        set bundle.Total=observationcount+1  // +1 はPatientリソース数を追加

        /*
        //以下DBに一旦保存したい場合の方法
        //QuickStreamに作成したBundleリソースを保存
        set bundleQS=##class(HS.SDA3.QuickStream).%New()
        set QuickStreamId=bundleQS.%Id()
        $$$ThrowOnError(bundle.OutputToStream(bundleQS))
        //検証実行のため、QuickStreamに保存したBundleリソースをJSONのダイナミックオブジェクトに変換
        set json={}.%FromJSON(bundleQS)
        */

        //作成したbundleインスタンスをダイナミックオブジェクトに出力
        $$$ThrowOnError(bundle.OutputToDynamicObject(.json))
        //検証実行
        $$$ThrowOnError(##class(FHIRFacade.SetResourceData).Validate(json))

    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

}
