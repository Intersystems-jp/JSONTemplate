Class FHIRFacade.REST Extends %CSP.REST
{

Parameter CONTENTTYPE = "application/json";

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/test" Method="GET" Call="Test" Cors="true"/>
<Route Url="/Patient/:pid" Method="GET" Call="GetPatient" Cors="true"/>
<Route Url="/Patient/:pid/everything" Method="GET" Call="GetPatientEverything" Cors="true"/>
</Routes>
}

ClassMethod Test() As %Status
{
    set message={}
    set message.TestMessage="エンドポイント正確に設定されています"
    do message.%ToJSON()
    return $$$OK
}

ClassMethod GetPatient(pid As %String) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set input={}
        set input.PID=pid
        $$$ThrowOnError(##class(FHIRFacade.BuildResource).Patient(input,.patient,.quickstreamid))
        do patient.%ToJSON()
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

ClassMethod GetPatientEverything(pid As %String) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set input={}
        set input.PID=pid
        $$$ThrowOnError(##class(FHIRFacade.BuildResource).Bundle(input,.bundle,.quickstreamid))
        do bundle.%ToJSON()
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

}
