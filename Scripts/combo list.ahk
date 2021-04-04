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
thirdpartylistOutFile := "..\" fileName " - Third-Party Blocklist.txt"


bigList := ""
whitelistOutText := ""
regexOutText := ""
ipOutText := ""
thirdpartyOutText := ""
outArray := []
outTextArray := []


Loop, Files, % comboListDir "\*.txt"
{
	if (A_LoopFileName = "The Big List.txt")
		continue
	
	bigList .= FileToVar(A_LoopFilePath)
	
	if (A_Index > 1)
		Sort, bigList, U
}

Loop, Parse, bigList, `n, `r
{
	if (StartsWith(A_LoopField, "@@"))
		whitelistOutText .= A_LoopField "`n"
	else if (StartsWith(A_LoopField, "/"))
		regexOutText .= A_LoopField "`n"
	else if (IsIPEntry(A_LoopField))
		ipOutText .= A_LoopField "`n"
	else if (InStr(A_LoopField, "^$") && InStr(A_LoopField, "third-party"))
		thirdpartyOutText .= A_LoopField "`n"
	else {
		outTextArray.Push(A_LoopField)
		
		if (outTextArray.Length() = 300000) {
			outArray.Push(outTextArray)
			outTextArray := []
		}
	}
}

outArray.Push(outTextArray)
outTextArray := ""

FileDelete, % whitelistOutFile
FileAppend, % whitelistOutText, % whitelistOutFile
whitelistOutText := ""

FileDelete, % regexOutFile
FileAppend, % regexOutText, % regexOutFile
regexOutText := ""

FileDelete, % iplistOutFile
FileAppend, % ipOutText, % iplistOutFile
ipOutText := ""

FileDelete, % thirdpartylistOutFile
FileAppend, % thirdpartyOutText, % thirdpartylistOutFile
thirdpartyOutText := ""

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
