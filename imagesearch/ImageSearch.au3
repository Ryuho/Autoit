#include-once
#AutoIt3Wrapper_UseX64=n

Func findImage($left, $top, $right, $bottom, $fileName, $tolorance)
	Local $answer[2] = [-1,-1]

	Local $findimage = $fileName

	If FileExists($findimage) == 0 Then
		ConsoleWrite("The file: " & $findimage & " does not exist!" & @CRLF)
		Return $answer
	EndIf

	If $tolorance > 0 Then
		$findimage = "*" & "transblack" & " " & "*" & $tolorance & " " & $findimage
	EndIf

	Local $result = DllCall("D:\System\autoit\imagesearch\ImageSearchDLL.dll", "str", "ImageSearch", "int", $left, "int", $top, "int", $right, "int", $bottom, "str", $findImage)

	If @error Then
		ConsoleWrite("DllCall to ImageSearchDLL.dll resulted in error!" & @CRLF)
	EndIf

	If IsArray($result) And Not @error And $result[0] <> 0 Then
		;_ArrayDisplay($result)
		Local $array = StringSplit($result[0],"|")

		Local $x=Int(Number($array[2]))
		Local $y=Int(Number($array[3]))
		$answer[0]=$x + Int(Number($array[4])/2)
		$answer[1]=$y + Int(Number($array[5])/2)

		;ConsoleWrite("found! (" & $x & "," & $y & ")" & @CRLF)
		Return $answer
	Else
		 Return $answer
	EndIf
EndFunc

