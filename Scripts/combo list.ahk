#MaxMem 256
SetBatchLines, -1
FileEncoding, UTF-8-RAW


ini := A_ScriptDir "\combo list.ini"
comboListDir := "..\Combo Lists"
fileName := "DD900 AGH Combo List"
theBigListFile := comboListDir "\The Big List.txt"
regexOutFile := "..\" fileName " - Regex Blocklist.txt"
whitelistOutFile := "..\" fileName " - Whitelist.txt"
iplistOutFile := "..\" fileName " - IP Blocklist.txt"


bigList := ""
whitelistOutText := ""
regexOutText := ""
ipOutText := ""
outArray := []
outTextArray := []


Loop, Files, % A_ScriptDir "\*.ahk"
{
	if (A_LoopFileName = "combo list.ahk")
		continue
	
	Menu, Tray, Tip, % "Running:`n" A_LoopFilePath
	RunWait, %A_ScriptDir%\AHK.exe "%A_LoopFilePath%"
}

Loop, Files, % comboListDir "\*.txt"
{
	if (A_LoopFileName = "The Big List.txt")
		continue
	
	Menu, Tray, Tip, % "Building:`n" A_LoopFilePath
	bigList .= FileToVar(A_LoopFilePath)
	
	if (A_Index > 1)
		Sort, bigList, U
}

Loop, Parse, bigList, `n, `r
{
	Menu, Tray, Tip, % "Parsing:`n" A_LoopField
	
	if (StartsWith(A_LoopField, "@@"))
		whitelistOutText .= A_LoopField "`n"
	else if (StartsWith(A_LoopField, "/"))
		regexOutText .= A_LoopField "`n"
	else if (IsIPEntry(A_LoopField))
		ipOutText .= A_LoopField "`n"
	else {
		outTextArray.Push(A_LoopField)
		
		if (outTextArray.Length() = 300000) {
			outArray.Push(outTextArray)
			outTextArray := []
		}
	}
}

outArray.Push(outTextArray)
Menu, Tray, Tip, Creating Files

FileDelete, % whitelistOutFile
FileAppend, % whitelistOutText, % whitelistOutFile
whitelistOutText := ""

FileDelete, % regexOutFile
FileAppend, % regexOutText, % regexOutFile
regexOutText := ""

FileDelete, % iplistOutFile
FileAppend, % ipOutText, % iplistOutFile
ipOutText := ""

FileDelete, % theBigListFile
FileAppend, % bigList, % theBigListFile
bigList := ""

for index, arr in outArray {
	outText := ""
	outFile := "..\" fileName " (" index ").txt"

	for i, v in arr
		outText .= v "`n"
	
	FileDelete, % outFile
	FileAppend, % outText, % outFile
}

ExitApp
