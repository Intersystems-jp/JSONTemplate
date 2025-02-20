Class JSONTest.NumberTest Extends JSONTemplate.Base
{

Property Num1 As %Integer;

Property Num2 As %Decimal;

Property Num21 As %Decimal(SCALE = 3);

Property Num3 As %Numeric;

Property Num31 As %Numeric(SCALE = 3);

Property Num32 As %Numeric(SCALE = "");

Property Num4 As %Float;

Property Num41 As %Float(SCALE = 3);

Property Num5 As %Double;

Property Num51 As %Double(SCALE = 3);

Property b As %Boolean;

Property Str As %String;

/// JSON出力する際のテンプレート
XData Template [ MimeType = application/json ]
{
{
    "strData":"#(..Str)#",
    "intData":"#(..Num1)#",
    "decimal":"#(..Num21)#",
    "decimalDataList":["#(..Num2)#","#(..Num21)#"],
    "numData":["#(..Num3)#","#(..Num31)#","#(..Num32)#"],
    "floatData":["#(..Num4)#","#(..Num41)#"],
    "doubleData":["#(..Num5)#","#(..Num51)#"]
}
}

ClassMethod test1()
{
    write "--- display 123",!
    do ..displayNumbers(123)
    write "--- display 123.4567",!
    do ..displayNumbers(123.4567)
    write "--- display -123.4567",!
    do ..displayNumbers(-123.4567)
}

ClassMethod displayNumbers(num)
{
    set obj=..%New()
    set obj.Num1=num
    set obj.Num2=num,obj.Num21=num
    set obj.Num3=num,obj.Num31=num,obj.Num32=num
    set obj.Num4=num,obj.Num41=num
    set obj.Num5=num,obj.Num51=num
    do obj.OutputToDevice()
}

}
