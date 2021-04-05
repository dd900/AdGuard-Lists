#MaxMem 256
#Include <CLR>
SetBatchLines, -1
FileEncoding, UTF-8-RAW


ini := A_ScriptDir "\combo list.ini"
cs := A_ScriptDir "\Filter.cs"
comboListDir := "..\Combo Lists"
tldListDir := "..\TLD Lists"
fileName := "DD900 AGH Combo List"
theBigListFile := comboListDir "\The Big List.txt"
regexOutFile := "..\" fileName " - Regex Blocklist.txt"
whitelistOutFile := "..\" fileName " - Whitelist.txt"
iplistOutFile := "..\" fileName " - IP Blocklist.txt"
thirdpartylistOutFile := "..\" fileName " - Third-Party Blocklist.txt"
C# := FileToVar(cs)
asm := CLR_CompileC#(C#, "System.dll | System.Linq.dll | System.Collections.dll | System.Core.dll")
filter := CLR_CreateObject(asm, "Filter")


doNotCopyList := ""
bigList := ""
whitelistOutText := ""
regexOutText := ""
ipOutText := ""
thirdpartyOutText := ""
outArray := []
outTextArray := []
tldObj := {}


doNotCopyList .= UrlToVar("https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt")
doNotCopyList .= UrlToVar("https://raw.githubusercontent.com/dd900/AdGuard-Lists/master/AdGuard_DNS_Blocklist.txt")
Sort, doNotCopyList, U
doNotCopyList .= UrlToVar("https://abp.oisd.nl/")
Sort, doNotCopyList, U
doNotCopyList .= UrlToVar("https://abl.arapurayil.com/filters/main.txt")
Sort, doNotCopyList, U
doNotCopyList .= UrlToVar("https://block.energized.pro/basic/formats/filter")
Sort, doNotCopyList, U

Loop, Files, % comboListDir "\*.txt"
{
	if (A_LoopFileName = "The Big List.txt")
		continue
	
	bigList .= FileToVar(A_LoopFilePath)
	
	if (A_Index > 1)
		Sort, bigList, U
}

bigList := filter.FilterList(bigList, doNotCopyList)
doNotCopyList := ""

Loop, Parse, bigList, `n, `r
{
	if (StartsWith(A_LoopField, "@@"))
		whitelistOutText .= A_LoopField "`n"
	else if (StartsWith(A_LoopField, "/"))
		regexOutText .= A_LoopField "`n"
	else if (IsIPEntry(A_LoopField))
		ipOutText .= A_LoopField "`n"
	else if (InStr(A_LoopField, "^$") && InStr(A_LoopField, "third-party"))
		thirdpartyOutText .= StrReplace(A_LoopField, StrSplit(A_LoopField, "$")[2], "third-party,script,popup") "`n"
	else {
		if (!StartsWith(A_LoopField, "||") || !EndsWith(A_LoopField, "^"))
			continue
		
		_Array := StrSplit(A_LoopField, ".", "|^")
		tld := _Array[_Array.Length()]
		
		if (!tldObj.HasKey(tld))
			tldObj[tld] := []
	
		tldObj[tld].Push(A_LoopField)
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

Sort, thirdpartyOutText, U
FileDelete, % thirdpartylistOutFile
FileAppend, % thirdpartyOutText, % thirdpartylistOutFile
thirdpartyOutText := ""

FileDelete, % theBigListFile
FileAppend, % bigList, % theBigListFile
bigList := ""

for key, arr in tldObj {
	outText := ""
	outFile := tldListDir "\" fileName " (" key ").txt"

	for i, v in arr
		outText .= v "`n"
	
	FileDelete, % outFile
	FileAppend, % outText, % outFile
}

for index, arr in outArray {
	outText := ""
	outFile := "..\" fileName " (" index ").txt"

	for i, v in arr
		outText .= v "`n"
	
	FileDelete, % outFile
	FileAppend, % outText, % outFile
}

ExitApp
