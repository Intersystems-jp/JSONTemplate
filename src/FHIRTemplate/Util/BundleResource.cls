Class FHIRTemplate.Util.BundleResource Extends %RegisteredObject
{

Property Resource [ MultiDimensional ];

/// リソースの追加
/// 引数にしていされたリソースを追加します。
/// 戻り値 1:追加 0:既に登録されている　<0:エラー
Method AddResource(resource As FHIRTemplate.Resource) As %Boolean
{
    if '$isobject(resource) {
        quit -1
    }
        set resourceid = resource.ResourceId
        if '$data(..Resource("rindex",resourceid)) {
            set rid=$increment(..Resource("resource"))
            set ..Resource("resource",rid)=resource
            set ..Resource("rindex",resourceid)=rid
            quit 1
        }
        quit 0
}

Method ExportResources(resources As %ListOfObjects) As %Status
{
        set rid="" for {
            set rid=$order(..Resource("resource",rid),1,res)
            quit:rid=""

            do resources.Insert(res)
        }
        quit $$$OK
}

}
