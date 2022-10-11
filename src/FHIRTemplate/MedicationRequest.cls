Class FHIRTemplate.MedicationRequest Extends FHIRTemplate.Resource
{

Parameter ResourceType = "MedicationRequest";

Parameter TimingCodeSystem = "urn:oid:1.2.392.200250.2.2.20";

Parameter RouteSystem = "http://jpfhir.jp/fhir/ePrescription/CodeSystem/route-codes";

Parameter MethodSystem = "urn:oid:1.2.392.200250.2.2.20.30";

Parameter DoseAndRateTypeSystem = "urn:oid:1.2.392.100495.20.2.22";

Parameter DispenseRequestValueCodeableConceptSystem = "urn:oid:1.2.392.200250.2.2.30.10";

Parameter DispenceRequestQuantitySystem = "urn:oid:1.2.392.200119.4.403.1";

Property TextDiv As %String(MAXLEN = 10000);

Property MedicationCodeableConcept As FHIRTemplate.DataType.CodeableConcept;

Property AuthoredOn As FHIRTemplate.DataType.TimeStamp;

/// Patient
Property Patient As FHIRTemplate.Patient;

Property DosageInstructionPeriod As FHIRTemplate.DataType.PeriodNoEnd;

Property DosageInstructionDuration As FHIRTemplate.DataType.Duration;

/// YYYY-MM-DD
Property TimingEvent As %String;

Property TimingRepetDuration As FHIRTemplate.DataType.Duration;

Property TimingCode As FHIRTemplate.DataType.CodeableConcept;

Property Route As FHIRTemplate.DataType.CodeableConcept;

Property Method As FHIRTemplate.DataType.CodeableConcept;

Property DoseAndRateType As FHIRTemplate.DataType.CodeableConcept;

Property DoseQuantity As FHIRTemplate.DataType.SimpleQuantity;

Property RateRatio As FHIRTemplate.DataType.Quantity;

Property Denominator As FHIRTemplate.DataType.Quantity;

Property DispenseRequestValueCodeableConcept As FHIRTemplate.DataType.CodeableConcept;

Property DispenseRequestQuantity As FHIRTemplate.DataType.SimpleQuantity;

Property ExpectedSupplyDuration As FHIRTemplate.DataType.Duration;

XData Template [ MimeType = application/json ]
{
{
    "resourceType":"#(..#ResourceType)#",
    "meta":{
        "profile":["http://jpfhir.jp/fhir/ePrescription/StructureDefinition/JP_MedicationRequest_ePrescription"]
    },
    "text":{
        "status":"generated",
        "div":"#(..TextDiv)#"
    },
    "identifier":[
        {
            "system":"urn:oid:1.2.392.100495.20.3.81",
            "value":"1"
        },
        {
            "system":"urn:oid:1.2.392.100495.20.3.82",
            "value":"1"
        }
    ],
    "status":"completed",
    "intent":"order",
    "medicationCodeableConcept":"#(..MedicationCodeableConcept(FHIRTemplate.DataType.CodeableConcept))#",
    "subject":"#(..Patient(FHIRTemplate.Reference))#",
    "authoredOn":"#(..AuthoredOn)#",
    "dosageInstruction": [
        {
        "extension": [
            {
                "url":"http://jpfhir.jp/fhir/core/Extension/StructureDefinition/JP_MedicationRequest_DosageInstruction_PeriodOfUse",
                "valuePeriod": "#(..DosageInstructionPeriod(FHIRTemplate.DataType.PeriodNoEnd))#"
            },
            {
                "url":"http://jpfhir.jp/fhir/core/Extension/StructureDefinition/JP_MedicationRequest_DosageInstruction_UsageDuration",
                "valueDuration":"#(..DosageInstructionDuration(FHIRTemplate.DataType.Duration))#"
            }
        ],
        "text": "内服・経口・１日２回朝夕食後 １回２錠 7日分",
        "timing": {
            "event":["#(..TimingEvent)#"],
            "repeat":{
                "boundsDuration":"#(..TimingRepetDuration(FHIRTemplate.DataType.Duration))#"
            },
            "code": "#(..TimingCode(FHIRTemplate.DataType.CodeableConcept))#"
        },
        "route": "#(..Route(FHIRTemplate.DataType.CodeableConcept))#",
        "method":"#(..Method(FHIRTemplate.DataType.CodeableConcept))#",
        "doseAndRate": [
            {
                "type":"#(..DoseAndRateType(FHIRTemplate.DataType.CodeableConcept))#",
                "doseQuantity": "#(..DoseQuantity(FHIRTemplate.DataType.SimpleQuantity))#",
                "rateRatio": {
                    "numerator":"#(..RateRatio(FHIRTemplate.DataType.Quantity))#",
                    "denominator": "#(..Denominator(FHIRTemplate.DataType.Quantity))#"
                }        
            }
        ]
        }
    ],
    "dispenseRequest":{
        "extension":[
            {
                "url":"http://jpfhir.jp/fhir/core/Extension/StructureDefinition/JP_MedicationRequest_DispenseRequest_InstructionForDispense",
                "valueCodeableConcept":"#(..DispenseRequestValueCodeableConcept(FHIRTemplate.DataType.CodeableConcept))#"
            }
        ],
        "quantity":"#(..DispenseRequestQuantity(FHIRTemplate.DataType.SimpleQuantity))#",
        "expectedSupplyDuration": "#(..ExpectedSupplyDuration(FHIRTemplate.DataType.Duration))#"            
    }
}
}

Method GetResources(br As FHIRTemplate.Util.BundleResource) As %Integer
{
    // 自分自身を登録
    set ret=##super(br)
    quit:ret<1 ret // 既に登録されていれば終了

    //関連リソースの取り込み
    do:$isobject(..Patient) ..Patient.GetResources(br)
}

}
