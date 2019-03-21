#include <Array.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <Date.au3>

Global Const $hFileOpen = FileOpen(@ScriptDir & "\log.txt", $FO_OVERWRITE)
Global Const $hFileOpenErrors = FileOpen(@ScriptDir & "\errors.txt", $FO_OVERWRITE)

Global $title = "Käsipääte - Juha Tenhunen - INVENTAARI TOYPAP - TILAUS"
Global $titleError = "Virhe"
Local $aInput = FileReadToArray(@ScriptDir & "\test.csv")
ConsoleWrite("Started" & @CRLF)
WinWaitActive($title)
ConsoleWrite("Correct windows has been found" & @CRLF)
Sleep(5000)
For $i = 0 to UBound($aInput) - 1

	WinWaitActive($title)
	$tp_code = StringSplit($aInput[$i],",")[1]
	$amount = StringSplit($aInput[$i],",")[2]
	Send($tp_code)
	Sleep(100)
	WinWaitActive($title)
	Send("{ENTER}")
	Sleep(500)
	If WinActive($titleError) Then
		ConsoleWrite(_NowTime() & " Ei Löytynyt: " & $tp_code & " " & $amount& @CRLF)
		FileWrite($hFileOpen,_NowTime() & " Ei Löytynyt: " & $tp_code & " " & $amount& @CRLF)
		FileWrite($hFileOpenErrors,_NowTime() & " Ei Löytynyt: " & $tp_code & " " & $amount& @CRLF)
		WinWaitActive($titleError)
		Send("{ENTER}")
		Sleep(500)
	Else
		Sleep(5000)
		WinWaitActive($title)
		Send($amount)
		Sleep(100)
		WinWaitActive($title)
		Send("{ENTER}")
		ConsoleWrite(_NowTime() & " Kirjattu: " & $tp_code & " " & $amount & @CRLF)
		FileWrite($hFileOpen,_NowTime() & " Kirjattu: "& $tp_code & " " & $amount  & @CRLF)
		While(WinActivate($titleError) == 0 And WinActive($title))
			Sleep(100)
			Send("88888888{ENTER}")
		WEnd
		If(WinActive($titleError)) Then
			Send("{ENTER}")
		EndIf
	EndIf
Next

FileWrite($hFileOpen, _NowTime() & " process completed" & @CRLF)
FileClose($hFileOpen)
FileClose($hFileOpenErrors)
