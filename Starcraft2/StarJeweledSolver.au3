#include-once
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Constant Variables----------------------------------------------------------------------------
Global Const $startXValue = 1278
Global Const $startYValue = 150

Global Const $gridNumber = 8
Global const $gridIncrementValue = 80

; Global Variables----------------------------------------------------------------------------
Global  $arr[$gridNumber][$gridNumber]

Global $strategy = 5
Global $unitCycle = 0

;Hotkey Functions-------------------------------------------------------------------------0
Func toggleUnitCreation()
	If $strategy == 6 Then
		$strategy = 0
		ConsoleWrite("spawn strategy now: " & $strategy & @CRLF)
	Else
		$strategy += 1
		ConsoleWrite("spawn strategy now: " & $strategy & @CRLF)
	EndIf
	$unitCycle = 0
EndFunc


; Functions----------------------------------------------------------------------------

Func pixelTest($x, $y, $color, $message)
	If PixelGetColor($x,$y) == $color Then
		Return True
	Else
		If $message <> "" Then
			ConsoleWrite($message & "| (" & $x & "," & $y & "): " & Hex($color,6) & " != " & Hex(PixelGetColor($x,$y),6) & @CRLF )
		EndIf
		Return False
	EndIf
EndFunc

Func getColorKind($color)
	Switch $color
		Case 'D4D5D6' ;Black
			return "Bla"
		Case '3F5B6B' ;Blue
			return "Blu"
		Case 'A29683' ;Green
			return "Gre"
		Case 'A19683' ;Green
			return "Gre"
		Case 'AC260A' ;Red
			Return "Red"
		Case 'AB260A' ;Red
			return "Red"
		Case '7F265E' ;Purple
			return "Pur"
		Case 'D3AA32' ;Yellow
			return "Yel"
		Case 'D3AB32' ; Yellow
			return "Yel"
		Case Else
			return "---"
	EndSwitch
EndFunc

Func swapArr($x1, $y1, $x2, $y2 )
	;ConsoleWrite("Swapping: (" & $x1 & "," & $y1  & ") with (" & $x2 & "," & $y2  & ")" & @CRLF)
	;ConsoleWrite("Swapping: " & $arr[$x1][$y1] & " with " & $arr[$x2][$y2] & @CRLF)
	Local $swapVal = $arr[$x1][$y1]
	$arr[$x1][$y1] = $arr[$x2][$y2]
	$arr[$x2][$y2] = $swapVal
EndFunc

Func calcCombo()
	Local $answer = 0
	Local $inARow = 1
	Local $prevCol = ""
	For $y = 0 To ($gridNumber-1)
		For $x = 0 To ($gridNumber-1)
			$currCol = $arr[$x][$y]
			If $currCol == "---" Then
				ContinueLoop
			EndIf
			If $prevCol == $currCol Then
				$inARow += 1
			EndIf

			If $prevCol <> $currCol Or $x == ($gridNumber-1) Then
				If $inARow >= 3 Then
					;ConsoleWrite("combo found @(" & $x & "," & $y & ") of " & $inARow & " points" & @CRLF)
					$answer += $inARow
				EndIf
				$inARow = 1
				$prevCol = $currCol
			EndIf
		Next
		$inARow = 1
		$prevCol = ""
	Next

	For $x = 0 To ($gridNumber-1)
		For $y = 0 To ($gridNumber-1)
			$currCol = $arr[$x][$y]
			If $currCol == "---" Then
				ContinueLoop
			EndIf
			If $prevCol == $currCol Then
				$inARow += 1
			EndIf
			If $prevCol <> $currCol Or $y == ($gridNumber-1) Then
				If $inARow >= 3 Then
					;ConsoleWrite("combo found @(" & $x & "," & $y & ") of " & $inARow & " points" & @CRLF)
					$answer += $inARow
				EndIf
				$inARow = 1
				$prevCol = $currCol
			EndIf
		Next
		$inARow = 1
		$prevCol = ""
	Next

	Return $answer
EndFunc

Func removeCombos()
	Local $tempArr[$gridNumber][$gridNumber]
	Local $inARow = 1
    Local $prevCol = ""
	For $y = 0 To ($gridNumber-1)
		For $x = 0 To ($gridNumber-1)
			$currCol = $arr[$x][$y]
			If $currCol == "---" Then
				ContinueLoop
			EndIf
			If $prevCol == $currCol Then
				$inARow += 1
			EndIf

			If $prevCol <> $currCol Or $x == ($gridNumber-1) Then
				If $inARow >= 3 Then
					For $tempX = $x-$inARow To $x-1
						;ConsoleWrite("deleted " & $arr[$tempX][$y] & @CRLF)
						$tempArr[$tempX][$y] = -1
					Next
				EndIf
				$inARow = 1
				$prevCol = $currCol
			EndIf
		Next
		$inARow = 1
		$prevCol = ""
	Next

	For $x = 0 To ($gridNumber-1)
		For $y = 0 To ($gridNumber-1)
			$currCol = $arr[$x][$y]
			If $currCol == "---" Then
				ContinueLoop
			EndIf
			If $prevCol == $currCol Then
				$inARow += 1
			EndIf

			If $prevCol <> $currCol Or $x == ($gridNumber-1) Then
				If $inARow >= 3 Then
					;ConsoleWrite("in a row:" & $inARow & @CRLF)
					For $tempY = $y-$inARow To $y-1
						;ConsoleWrite("coord:(" & $tempY & "," & $y & ")" & @CRLF)
						;ConsoleWrite("deleted" & $arr[$x][$tempY] & @CRLF)
						$tempArr[$x][$tempY] = -1
					Next
				EndIf
				$inARow = 1
				$prevCol = $currCol
			EndIf
		Next
		$inARow = 1
		$prevCol = ""
	Next

	For $x = 0 To ($gridNumber-1)
		For $y = 0 To ($gridNumber-1)
			If $tempArr[$x][$y] == -1 Then
				$arr[$x][$y] = "---"
			EndIf
		Next
	Next

	Return
EndFunc

Func fallDownJewels()
	$needMore = False

	While needToFallDown()
		For $x = 0 To ($gridNumber-1)
			For $y = 0 To ($gridNumber-1)
				If $arr[$x][$y] == "---" And $y <> 0 Then
					For $tempY = $y To 1 Step -1
						swapArr($x,$tempY,$x,$tempY-1)
					Next
				EndIf
			Next
		Next
	WEnd
	Return
EndFunc

Func needToFallDown()
	Local $answer = False

	For $x = 0 To ($gridNumber-1)
		For $y = 0 To ($gridNumber-1)
			If $arr[$x][$y] == "---" Then
				;ConsoleWrite("got ---:(" & $x & "," & $y & ")" & @CRLF)
				For $tempY = $y To 0 Step -1
					If $arr[$x][$tempY] <> "---" Then
						$answer = True
					EndIf
				Next
			EndIf
		Next
	Next

	Return $answer
EndFunc

Func getBestMove()
	Local $bestScore = 0
	Local $currScore = 0
	Local $swapVal = ""
	Local $answer[2][2] =  [[0, 0], [0, 0]]
	For $y = 0 To ($gridNumber-1)
		For $x = 0 To ($gridNumber-1)
			If $arr[$x][$y] == "---" Then
				ContinueLoop
			EndIf
			;if not left most, move left and see the score
			If $x >= 1 Then
				swapArr($x,$y,$x-1,$y)
				$currScore = calcCombo()
				If $bestScore < $currScore Then
					$bestScore = $currScore
					$answer[0][0] = $x
					$answer[0][1] = $y
					$answer[1][0] = $x-1
					$answer[1][1] = $y
					;ConsoleWrite("BestMove(" & $arr[$x][$y] & "): left->(" & $x & "," & $y & ") with score of " & $currScore & @CRLF)
				EndIf
				swapArr($x,$y,$x-1,$y)
			EndIf

			;if not top most, move up and see the score
			If $y >= 1 Then
				swapArr($x,$y,$x,$y-1)
				$currScore = calcCombo()
				If $bestScore < $currScore Then
					$bestScore = $currScore
					$answer[0][0] = $x
					$answer[0][1] = $y
					$answer[1][0] = $x
					$answer[1][1] = $y-1
					;ConsoleWrite("BestMove(" & $arr[$x][$y] & "): up->(" & $x & "," & $y & ") with score of " & $currScore & @CRLF)
				EndIf
				swapArr($x,$y,$x,$y-1)
			EndIf

			;if not right most, move right and see the score
			If $x < $gridNumber-1 Then
				swapArr($x,$y,$x+1,$y)
				$currScore = calcCombo()
				If $bestScore < $currScore Then
					$bestScore = $currScore
					$answer[0][0] = $x
					$answer[0][1] = $y
					$answer[1][0] = $x+1
					$answer[1][1] = $y
					;ConsoleWrite("BestMove(" & $arr[$x][$y] & "): right->(" & $x & "," & $y & ") with score of " & $currScore & @CRLF)
				EndIf
				swapArr($x,$y,$x+1,$y)
			EndIf

			;if not bottom most, move bottom and see the score
			If $y < $gridNumber-1 Then
				swapArr($x,$y,$x,$y+1)
				$currScore = calcCombo()
				If $bestScore < $currScore Then
					$bestScore = $currScore
					$answer[0][0] = $x
					$answer[0][1] = $y
					$answer[1][0] = $x
					$answer[1][1] = $y+1
					;ConsoleWrite("BestMove(" & $arr[$x][$y] & "): bottom->(" & $x & "," & $y & ") with score of " & $currScore & @CRLF)
				EndIf
				swapArr($x,$y,$x,$y+1)
			EndIf
		Next
	Next

	If $bestScore == 0 Then
		$answer[0][0] = -1
		$answer[0][1] = -1
		$answer[1][0] = -1
		$answer[1][1] = -1
		Return $answer
	EndIf

	;ConsoleWrite("BestMove(" & $arr[$answer[0][0]][$answer[0][1]] & ") @ (" & $answer[0][0] & "," & $answer[0][1] & ")  to (" & $answer[1][0] & "," & $answer[1][1] & ") " & "with score of " & $bestScore & @CRLF)
	Return $answer
EndFunc

Func getJeweles()
	;ConsoleWrite("getting jeweles..." & @CRLF)
	Local $answer = 0
	Local $xPix = $startXValue
	Local $yPix = $startYValue
	For $yGrid = 0 To ($gridNumber-1)
		For $xGrid = 0 To ($gridNumber-1)
			$arr[$xGrid][$yGrid] = getColorKind(Hex(PixelGetColor( $xPix , $yPix ), 6))
			$xPix += $gridIncrementValue
			If $arr[$xGrid][$yGrid] <> "---" Then
				$answer += 1
			EndIf
		Next
		$yPix += $gridIncrementValue
		$xGrid = 0
		$xPix = $startXValue
	Next
	Return $answer
EndFunc

Func printJeweles()
	;ConsoleWrite("printJeweles:" & @CRLF)
	For $yGrid = 0 To ($gridNumber-1)
		For $xGrid = 0 To ($gridNumber-1)
			ConsoleWrite($arr[$xGrid][$yGrid] & " ")
		Next
		ConsoleWrite(@CRLF)
	Next
EndFunc

Func gameState()
	;ConsoleWrite("getting game state..." & @CRLF);

	If pixelTest(820, 242, 0x12FF12, "") And pixelTest(837, 265, 0x12FF12, "")  And pixelTest(851, 238, 0x12FF12, "")  Then
		ConsoleWrite("yay all the check for gameWon passed!" & @CRLF)
		Return "gameWon"
	EndIf

	If pixelTest(834, 237, 0xFF0000, "")  And pixelTest(834, 268, 0xFF0000, "") And pixelTest(1070, 268, 0xFF0000, "") And pixelTest(1085, 242, 0xFF0000, "") Then
		Return "gameLost"
	EndIf

	If pixelTest(255, 311, 0xC1FFFF, "") And pixelTest(574, 329, 0xC1FFFF, "") And pixelTest(433, 329, 0xC1FFFF, "") Then
		; game lobby
		Return "gameLobby"
	EndIf

	If (pixelTest(543, 151, 0x00C1FF, "") And pixelTest(299, 151, 0x00C1FF, "")) Or (pixelTest(543, 151, 0xFFFFFF, "") And pixelTest(299, 151, 0x00C1FF, "")) Then
		return "mainMenu"
	EndIf

	; playing the game
	If getJeweles() >= 32 Then
		Return "theGame"
	EndIf

	Return "---"
EndFunc

Func playTheGame()
	; setup hotkey options

	;{NUMPAD0} = disable unit creation
	HotKeySet("{NUMPAD0}", "toggleUnitCreation")

	ConsoleWrite("playing the game: gameState=" & gameState() &  @CRLF);

	Local $answer[2][2]

	While 1
		If gameState() == "gameWon" Then
			ExitLoop
		ElseIf gameState() == "gameLost" Then
			ExitLoop
		EndIf
		;ConsoleWrite("Main loop====================" & @CRLF)
		;get Jeweles information from the screen
		$validJems = getJeweles()
		If $validJems <= 32 Then
			sleep(1000)
			ContinueLoop
		EndIf
		;printJeweles()

		;get the best move you can make in a single turn
		$answer = getBestMove()

		If $answer[0][0] <> -1 Then
			;calculate the position the screen needs to click
			$clickFromX = $startXValue + $gridIncrementValue*$answer[0][0]
			$clickFromY = $startYValue + $gridIncrementValue*$answer[0][1]
			$clickToX = $startXValue + $gridIncrementValue*$answer[1][0]
			$clickToY = $startYValue + $gridIncrementValue*$answer[1][1]

			;actually click them
			MouseClick ( "left", $clickFromX , $clickFromY, 1, 0 )
			MouseClick( "left", $clickToX, $clickToY, 1, 0 )
			swapArr($answer[0][0],$answer[0][1],$answer[1][0],$answer[1][1])
			removeCombos()
			;printJeweles()
			fallDownJewels()
			;printJeweles()
		EndIf

		If PixelGetColor(493, 360) == 0x00BB00 And PixelGetColor(636, 340) == 0x00BB00 And PixelGetColor(819, 347) == 0x00BB00 Then
			ConsoleWrite("won a round." & @CRLF)
			Sleep(3000)
			pickRealStrat()
		EndIf

		summonUnits()
	WEnd

	Return
EndFunc

Func pickRealStrat()
	$strategy = Random(5, 6, 1)
EndFunc

Func pickCheesyStrat()
	$strategy = Random(1, 4, 1)
EndFunc

Func summonUnits()
	If $strategy == 0 Then
		;do not spawn anything
	ElseIf $strategy == 1 Then
		; zealot rush with 1000 energy
		If PixelGetColor(1881, 792) <> 0x000000 Then
			For $temp = 0 To 100
				Send("q")
				Sleep(10)
			Next
			pickRealStrat()
		EndIf
	ElseIf $strategy == 2 Then
		;pickRealStrat()
	ElseIf $strategy == 3 Then
		;pickRealStrat()
	ElseIf $strategy == 4 Then
		;pickRealStrat()
	ElseIf $strategy == 5 Then
		If $unitCycle == 0 And spawnUnit("Colossus") Then
			$unitCycle += 1
		ElseIf $unitCycle == 1 And spawnUnit("Ghost") Then
			$unitCycle += 1
		ElseIf $unitCycle == 2 And spawnUnit("Ghost") Then
			$unitCycle += 1
		ElseIf $unitCycle == 3 And spawnUnit("Hydralisk") Then
			$unitCycle += 1
		ElseIf $unitCycle == 4 And spawnUnit("Tank") Then
			$unitCycle = 0
		EndIf
		If Random(0,1) <= 0.5 Then
			;pickCheesyStrat()
		EndIf
	ElseIf $strategy == 6 Then
		If $unitCycle == 0 And spawnUnit("Roach") Then
			$unitCycle += 1
		ElseIf $unitCycle == 1 And spawnUnit("Roach") Then
			$unitCycle += 1
		ElseIf $unitCycle == 2 And spawnUnit("Ultralisk") Then
			$unitCycle += 1
		ElseIf $unitCycle == 3 And spawnUnit("Hydralisk") Then
			$unitCycle += 1
		ElseIf $unitCycle == 4 And spawnUnit("Hydralisk") Then
			$unitCycle = 0
		EndIf
		If Random(0,1) <= 0.5 Then
			;pickCheesyStrat()
		EndIf
	EndIf

EndFunc

Func spawnUnit($unit)
	If $unit == "Zealot" Then
		If PixelGetColor(1396, 890) == 0xEEEEEE Then
			ConsoleWrite("spawned Zealot" &  @CRLF)
			Send("q")
			Sleep(500)
			Return True
		Else
			Return False
		EndIf
	ElseIf $unit == "Roach" Then
		If PixelGetColor(1387, 972) == 0xF6EEE6 Then
			ConsoleWrite("spawned Roach" &  @CRLF)
			Send("a")
			Sleep(500)
			Return True
		Else
			Return False
		EndIf
	ElseIf $unit == "Hydralisk" Then
		If PixelGetColor(1475, 914) == 0x9B784D Then
			ConsoleWrite("spawned Hydralisk" &  @CRLF)
			Send("w")
			Sleep(500)
			Return True
		Else
			Return False
		EndIf
	ElseIf $unit == "Ghost" Then
		If PixelGetColor(1469, 977) == 0xE6FAFE Then
			ConsoleWrite("spawned Ghost" &  @CRLF)
			Send("s")
			Sleep(500)
			Return True
		Else
			Return False
		EndIf
	ElseIf $unit == "Mutalisk" Then
		If PixelGetColor(1553, 900) == 0xF6EECD Then
			ConsoleWrite("spawned Mutalisk" &  @CRLF)
			Send("e")
			Sleep(500)
			Return True
		Else
			Return False
		EndIf
	ElseIf $unit == "Banshee" Then
		If PixelGetColor(1557, 983) == 0xF6F6F6 Then
			ConsoleWrite("spawned Banshee" &  @CRLF)
			Send("d")
			Sleep(500)
			Return True
		Else
			Return False
		EndIf
	ElseIf $unit == "Tank" Then
		If PixelGetColor(1630, 907) == 0xF6F6EE Then
			ConsoleWrite("spawned Tank" &  @CRLF)
			Send("r")
			Sleep(500)
			Return True
		Else
			Return False
		EndIf
	ElseIf $unit == "Immortal" Then
		If PixelGetColor(1609, 975) == 0xF6FAEE Then
			ConsoleWrite("spawned Immortal" &  @CRLF)
			Send("f")
			Sleep(500)
			Return True
		Else
			Return False
		EndIf
	ElseIf $unit == "Colossus" Then
		If PixelGetColor(1681, 889) == 0xB09E70 Then
			ConsoleWrite("spawned Colossus" &  @CRLF)
			Send("t")
			Sleep(500)
			Return True
		Else
			Return False
		EndIf
	ElseIf $unit == "Ultralisk" Then
		If PixelGetColor(1688, 964) == 0xF6EAD5 Then
			ConsoleWrite("spawned Ultralisk" &  @CRLF)
			Send("g")
			Sleep(500)
			Return True
		Else
			Return False
		EndIf
	Else
		ConsoleWrite("ERROR, this should never happen!" & @CRLF);
	EndIf
	Return False
EndFunc