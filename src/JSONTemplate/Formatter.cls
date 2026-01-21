Class JSONTemplate.Formatter Extends %JSON.Formatter
{

/// Internal method to actually do the formatting
Method FormatInternal(input, ByRef export As %String, toDevice As %Boolean) [ Internal ]
{
	Set sc=$$$OK
	Try {
		// If writing to current device then we need to clear our string buffer for each iteraation of loop
		If toDevice Set export=""

		// initialize indentation
		Set indent=..Indent
		If indent {
			Set lineTerminator=..LineTerminator
			Set indentChars=..IndentChars
			Set indentLength=$length(indentChars)
		} Else {
			Set lineTerminator=""
			Set indentChars=""
			Set indentLength=0
		}
		Set currentIndent=""
		
		// If a JSON string, then convert to dynamic object or array before formatting
		If $isobject(input),input.%IsA("%Library.DynamicAbstractObject") {
			// Already a dynamic object
			Set currentContainer=input
		} Else {
			// A JSON stream or string
			Set currentContainer=##class(%Library.DynamicAbstractObject).%FromJSON(input)
		}

		// Initialize loop variables
		Set stackCount=0
		Set currentType=$select(currentContainer.%IsA("%Library.DynamicObject"):"object",1:"array")
		Set currentIterator=currentContainer.%GetIterator()
		Set sep=""
		// Push stack
		Set iteratorStack(stackCount)=currentIterator
		Set containerStack(stackCount)=currentContainer
		Set typeStack(stackCount)=currentType
		Set stackCount=stackCount+1
		
		// Start output of object or array
		Set export=export_$select(currentType="object":"{",1:"[")
		If indent {
			Set currentIndent=currentIndent_indentChars
		}
				
		// Main loop to walk tree without using recursion
		For {
			// Finish up for this value and prepare for next
			Set currentIteratorIsObject=currentIterator.%IsA("%Iterator.Object")
			If currentIterator.%GetNext(.key,.current) {
				// There is another value in this object or array.
				Set currentType=$$$JSONGetTypeOf(currentContainer,key)
				// Output , and indentation
				Set export=export_sep
				If indent Set export=export_lineTerminator_currentIndent
				Set sep=","

			} Else {
				// There are no more values in this array or object
				// Output closing } or ] with indentation
    			If indent {
	    			Set currentIndent=$extract(currentIndent,1,*-indentLength)
	    			Set export=export_lineTerminator_currentIndent
    			}
				Set export=export_$select(currentIteratorIsObject:"}",1:"]")
				
				// Pop stack to make containing object or array the current object or array.
				Set stackCount=stackCount-1
				If stackCount=0 Quit
				Set currentIterator=iteratorStack(stackCount)
				Set currentContainer=containerStack(stackCount)
				Set currentType=typeStack(stackCount)
				Set sep=","
				
				// Get next value at previous level
				Continue
			}

			// If this is an object, then output next field name.
			If currentIteratorIsObject {
				Set export=export_""""_$zcvt(key,"O","JSON")_""":"
			}

			// Stack processing for object and array values
			If (currentType="object") || (currentType="array") {
				// Push stack
				Set iteratorStack(stackCount)=currentIterator
				Set containerStack(stackCount)=currentContainer
				Set typeStack(stackCount)=currentType
				Set sep=""
				Set stackCount=stackCount+1
				
				// Setup for loop over object values
				Set currentIterator=current.%GetIterator()
				Set currentContainer=current
				
				// Start output of object or array
				Set export=export_$select(currentType="object":"{",1:"[")
				If indent {
					Set currentIndent=currentIndent_indentChars
					If lineTerminator="" Set lineTerminator=..LineTerminator
				}
				
			// Output of string
			} ElseIf currentType="string" {
                // $c(0)があればダブルクオートをつけない
                if $extract(current)=$c(0) {
    				Set export=export_$zcvt($extract(current,2,*),"O","JSON")
                } else {
    				Set export=export_""""_$zcvt(current,"O","JSON")_""""
                }

			// Output of boolean
			} ElseIf currentType="boolean" {
				Set export=export_$select(current:"true",1:"false")

			// Output null
			} ElseIf currentType="null" {
				Set export=export_"null"

			// Output of number
			} Else {
				If $extract(current)="." Set current="0"_current
				If $extract(current,1,2)="-." Set current="-0."_$extract(current,3,*)
				Set export=export_current
			}
			
			// If writing to current device then write buffer and clear our string buffer for each iteraation of loop
			If toDevice {
				Write export
				Set export=""
			}
		}
		
		// Write the remainder
		If toDevice,export'="" {
			Write export
		}

	} Catch ex {
		Set sc=ex.AsStatus()
	}

	Quit sc
}

}
