Class FHIRTemplate.DataType.Age Extends FHIRTemplate.DataType.Quantity
{

Parameter CodeSystem = "http://unitsofmeasure.org";

Property code As %String(DISPLAYLIST = ",minutes,hours,days,weeks,months,years", VALUELIST = ",min,h,d,wk,mo,a");

}
