#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#AutoIt3Wrapper_UseX64=n
#include <D:\System\autoit\imagesearch\ImageSearch.au3>
#include <StarJeweledSolver.au3>

;Functions--------------------------------------------------------------------

Func relogin()
	MouseClick("left",251, 1150)
	Sleep(2000)
	MouseClick("left",947, 661)
	Sleep(2000)
	MouseClick("left",947, 661)
	Sleep(1000)
	Send("yurina22")
	Sleep(500)
	MouseClick("left",963, 798)
	Sleep(2000)
	MouseClick("left",963, 798)
	Sleep(2000)
EndFunc

Func joinNewGame()
	ConsoleWrite("joining new game..." & @CRLF);
	$tempWaitSeconds = 0

	; wait for the menu to come up
	While PixelGetColor(476, 73) <> 0xBBFFFE
		Sleep(1000)
		$tempWaitSeconds += 1
		If $tempWaitSeconds >= 60 Then
			relogin()
			Return
		EndIf
	WEnd

	;click on multiPlayer
	MouseClick("left", 558, 92)
	While PixelGetColor(1408, 900) <> 0xB4FDFF
		Sleep(1000)
		$tempWaitSeconds += 1
		If $tempWaitSeconds >= 60 Then
			relogin()
			Return
		EndIf
	WEnd

	;click on join a game
	MouseClick("left", 1408, 900)
	While PixelGetColor(393, 535) <> 0x1263EE
		Sleep(1000)
		$tempWaitSeconds += 1
		If $tempWaitSeconds >= 60 Then
			relogin()
			Return
		EndIf
	WEnd

	;select StarJeweled
	MouseClick("left", 393, 535)
	While PixelGetColor(353, 1027) <> 0xAF6605
		Sleep(1000)
		$tempWaitSeconds += 1
		If $tempWaitSeconds >= 60 Then
			relogin()
			Return
		EndIf
	WEnd

	;click on Join Game
	MouseClick("left", 353, 1027)
	While PixelGetColor(255, 310) <> 0xC1FFFF
		Sleep(1000)
		$tempWaitSeconds += 1
		If $tempWaitSeconds >= 60 Then
			relogin()
			Return
		EndIf
	WEnd
	ConsoleWrite("joined a game!" & @CRLF);
	gameLobby()
EndFunc

Func gameLobby()
	ConsoleWrite("handling game lobby..." & @CRLF);
	$tempWaitSeconds = 0
	; 4th spot filled = 648, 688
	For $tempWaitSeconds = 0 To 60
		If PixelGetColor(647, 430) == 0x014690 Then
			ConsoleWrite("waiting for player 1..." & @CRLF);
		ElseIf PixelGetColor(647, 496) == 0x014690 Then
			ConsoleWrite("waiting for player 2..." & @CRLF);
		ElseIf PixelGetColor(647, 615) == 0x014690 Then
			ConsoleWrite("waiting for player 3..." & @CRLF);
		ElseIf PixelGetColor(647, 681) == 0x014690 Then
			ConsoleWrite("waiting for player 4..." & @CRLF);
		Else
			ConsoleWrite("yay full house!" & @CRLF);
			MouseClick("left", 540, 1025)
			If gameState() <> "gameLobby" Then
				Return
			EndIf
		EndIf
		Sleep(1000)
	Next
	ConsoleWrite("waited for 60 seconds, quitting and starting over" & @CRLF);
	MouseClick("left", 725, 1033)
EndFunc

Func detectPlayerColor()
	ConsoleWrite("detecting player color..." & @CRLF);
	Local $resultX = 0
	Local $resultY = 0

	;first position...
	If PixelGetColor(339, 429) == 0xFFFFFF And PixelGetColor(354, 434) == 0xF2F5F9 And PixelGetColor(366, 434) == 0xE9EFF5 And PixelGetColor(378, 429) == 0xFAFCFD And PixelGetColor(397, 442) == 0xFAFBFD Then
			$color = Hex(PixelGetColor(853, 432),6)
			ConsoleWrite("got color yayyy: " & $color & @CRLF);
		Return $color
	EndIf
	If PixelGetColor(339, 495) == 0xFFFFFF And PixelGetColor(354, 500) == 0xF2F5F9 And PixelGetColor(366, 500) == 0xE9EFF5 And PixelGetColor(378, 495) == 0xFAFCFD And PixelGetColor(397, 508) == 0xFAFBFD Then
			$color = Hex(PixelGetColor(853, 498),6)
			ConsoleWrite("got color yayyy: " & $color & @CRLF);
		Return $color
	EndIf
	If PixelGetColor(339, 495) == 0xFFFFFF And PixelGetColor(354, 500) == 0xF2F5F9 And PixelGetColor(366, 500) == 0xE9EFF5 And PixelGetColor(378, 495) == 0xFAFCFD And PixelGetColor(397, 508) == 0xFAFBFD Then
			$color = Hex(PixelGetColor(853, 498),6)
			ConsoleWrite("got color yayyy: " & $color & @CRLF);
		Return $color
	EndIf

EndFunc

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

; main----------------------------------------------------------------------------
Func main()
	ConsoleWrite("Running main" & @CRLF)
	HotKeySet("{TAB}", "PauseApp")
	HotKeySet("{ESCAPE}", "ExitApp")



	While 1
		Switch (gameState())
			Case "gameWon" ; won a game
				ConsoleWrite("won! quitting. " & @CRLF)
				MouseClick("left", 950,916)
				joinNewGame()
			Case "gameLost" ; lost a game
				ConsoleWrite("lost! quitting. " & @CRLF)
				MouseClick("left", 950,916)
				joinNewGame()
			Case "mainMenu" ; main menu
				joinNewGame()
			Case "theGame" ; playing the game
				playTheGame()
			Case "gameLobby" ; game lobby
				gameLobby()
			Case "---" ; something else?
				ConsoleWrite("wtf man:" & @CRLF);
				Sleep(1000)
		EndSwitch
	WEnd
EndFunc



main()