#AutoIt3Wrapper_UseX64=n
#include <D:\System\autoit\imagesearch\ImageSearch.au3>


;global vars
$numOfPatterns = 35
Global $patternUseage[$numOfPatterns + 1]



; Hotkey Functions----------------------------------------------------------------------------
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

Func clearUsage()
	ConsoleWrite(@CRLF & "Cleared Usage" & @CRLF)
	For $loop = 0 To $numOfPatterns
		$patternUseage[$loop] = 0
	Next
EndFunc

Func PrintUsage()
	For $loop = 0 To $numOfPatterns
		ConsoleWrite($loop & " = " & $patternUseage[$loop] & @CRLF)
	Next
EndFunc

; main----------------------------------------------------------------------------
Func main()
	ConsoleWrite("Running main" & @CRLF)
	HotKeySet("{TAB}", "PauseApp")
	HotKeySet("{ESCAPE}", "ExitApp")
	HotKeySet("{NUMPADADD}", "PrintUsage")
	HotKeySet("{NUMPADSUB}", "clearUsage")

	$fileSuffix = "images\generic\colosus"

	While 1
		$loop = 1
		While 1
			$loopFile = $fileSuffix & $loop & ".png"
			If FileExists($loopFile) == 0 Then
				ConsoleWrite("$loopFile= " & $loopFile & @CRLF)
				ExitLoop
			EndIf
			$searchResult = findImage(0, 0, @DesktopWidth, @DesktopHeight, $loopFile, 10)
			If $searchResult[0] <> -1 Then
				ConsoleWrite("Using " & $loop & ": " & $searchResult[0] & ", "& $searchResult[1] & @CRLF)
				MouseMove($searchResult[0],$searchResult[1],0)
				$patternUseage[$loop] = $patternUseage[$loop] + 1
			EndIf
			$loop = $loop +1
		WEnd
		$loop = 1
	WEnd

EndFunc

clearUsage()
main()