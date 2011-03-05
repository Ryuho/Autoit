#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------



Func PauseApp()
	ConsoleWrite(@CRLF & "Paused..." & @CRLF)
	HotKeySet("{TAB}", "main")
	while 1
		Sleep(1000)
	WEnd
EndFunc

Func ExitApp()
	ConsoleWrite(@CRLF & "Exiting App." & @CRLF)
	Exit
EndFunc

; zoom 144%
; 343x350
; first drawable spot 1122, 659
; thin pen button 996, 713
; color button 1039, 901
; color select (click twice) 1269, 876
; color OK button 1289, 916

Func PixelWaitColor ($x, $y, $color, $waitMilSec)
	;ConsoleWrite("checking @ (" & $x & "," & $y & ") for " & $color & @CRLF);
	For $loop = 0 To $waitMilSec
		$tempColor = Hex(PixelGetColor($x, $y),6)
		ConsoleWrite("checking @ (" & $x & "," & $y & ") for " & $color & " | " & $tempColor & @CRLF);
		If ($tempColor == $color) Then
			Return 0
		EndIf
		Sleep(1)
	Next
	Exit
EndFunc

Func selectThinPen ()
	MouseClick("left", 996, 713, 1,0)
EndFunc

Func selectColor ($val)
	MouseClick("left", 1039, 901, 1,0)
	PixelWaitColor(1103, 719,"0B333C",100)
	MouseClick("left", 1269, 876, 2,0)
	PixelWaitColor(1252, 873,"000000",100)
	Send($val)
	PixelWaitColor(1248, 743,$val,100)
	MouseClick("left", 1289, 916, 1,0)
	PixelWaitColor(1013, 901,"0B333C",100)
EndFunc


Func main ()
	HotKeySet("{TAB}", "PauseApp")
	HotKeySet("{ESCAPE}", "ExitApp")

	;selectThinPen ()
	Sleep(200)

	For $tempX = 2156 To 2385 Step 10
		For $tempY = 592 To 821 Step 10
			$tempColor = Hex(PixelGetColor($tempX, $tempY),6)
			selectColor ($tempColor)
			MouseClick("left", 1123 - 2156 + $tempX, 659 - 592 + $tempY, 1,0)
		Next
	Next
EndFunc



main ()