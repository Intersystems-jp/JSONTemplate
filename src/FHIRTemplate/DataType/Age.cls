Class FHIRTemplate.DataType.Age Extends FHIRTemplate.DataType.Quantity
{

Parameter CodeSystem = "http://unitsofmeasure.org";

Property code As %String(VALUELIST = ",min,h,d,wk,mo,a");

}
