Class FHIRTemplate.DataType.TimeStamp Extends %DataType [ ClassType = datatype, ClientDataType = TIMESTAMP, OdbcType = TIMESTAMP, SqlCategory = TIMESTAMP ]
{

/// 出力フォーマット
/// 1 ... YYYY-MM-DDTHH:MM:SS+timezone
/// 2 ... YYYY-MM-DDTHH:MM:SSZ
/// 3 ... YYYY-MM-DD
/// 4 ... YYYY-MM-DDTHH:MM:SS.nnn+timezone
Parameter FORMAT = 1;

ClassMethod LogicalToDisplay(%val) As %String [ CodeMode = generator, ServerOnly = 1 ]
{
	If ($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"XMLENABLED",$$$cPARAMdefault) || $$$comMemberKeyGet(%class,$$$cCLASSparameter,"%JSONENABLED",$$$cPARAMdefault) {
         if ..#FORMAT=2 {
            $$$GENERATE(" quit $zdatetime(%val,3,7)")
        } elseif ..#FORMAT=3 {
            $$$GENERATE(" quit $zdate(%val,3)")
        } elseif ..#FORMAT=4 {
            $$$GENERATE(" quit $zdatetime(%val,3,5,3)")
        } else {
            $$$GENERATE(" quit $zdatetime(%val,3,5)")
        }
    }
}

}
