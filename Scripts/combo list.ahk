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
theBigCleanListFile := comboListDir "\The Big Clean List.txt"
crapFile := comboListDir "\Crap.txt"
regexOutFile := "..\" fileName " - Regex Blocklist.txt"
whitelistOutFile := "..\" fileName " - Whitelist.txt"
iplistOutFile := "..\" fileName " - IP Blocklist.txt"
thirdpartylistOutFile := "..\" fileName " - Third-Party Blocklist.txt"
asm := CLR_CompileC#(FileToVar(cs), "System.dll | System.Linq.dll | System.Collections.dll | System.Core.dll")
filter := CLR_CreateObject(asm, "Filter")


wwwList := ""
bigList := ""
crapList := ""
whitelistOutText := ""
regexOutText := ""
ipOutText := ""
thirdpartyOutText := ""
outArray := []
outTextArray := []
outTextArrayIndex := 1
tldObj := {}


doNotCopyList := Distinct(UrlToVar(IniRead(ini, "InUse", "oisd")), UrlToVar(IniRead(ini, "InUse", "energized")))
doNotCopyList := Distinct(doNotCopyList, UrlToVar(IniRead(ini, "InUse", "abl")))
doNotCopyList := Distinct(doNotCopyList, UrlToVar(IniRead(ini, "InUse", "adguard")))
doNotCopyList := Distinct(doNotCopyList, FileToVar("..\AdGuard_DNS_Blocklist.txt"))
doNotCopyList := Distinct(doNotCopyList, FileToVar("..\AdGuard_DNS_Whitelist.txt"))
doNotCopyList := Distinct(doNotCopyList, crapText := FileToVar(crapFile))

Loop, Files, % comboListDir "\*.txt"
{
	if (A_LoopFileName = "The Big List.txt" || A_LoopFileName = "The Big Clean List.txt" || A_LoopFileName = "Crap.txt")
		continue
	
	bigList .= FileToVar(A_LoopFilePath)
}

Sort, bigList, U
FileDelete, % theBigListFile
FileAppend, % bigList, % theBigListFile

bigList := filter.FilterList(bigList, doNotCopyList)
doNotCopyList := ""

Loop, Parse, bigList, `n, `r
{
	if (StartsWith(A_LoopField, "||www.")) {
		crapList .= A_LoopField "`n"
		wwwList .= StrReplace(A_LoopField, "||www.", "||") "`n"
	}
}

bigList := Distinct(bigList, wwwList)
wwwList := ""

if (crapList != "") {
	FileDelete, % crapFile
	FileAppend, % Distinct(crapText, crapList), % crapFile
	crapText := crapList := ""
}

Loop, Parse, bigList, `n, `r
{
	if (StartsWith(A_LoopField, "@@") && EndsWith(A_LoopField, "^"))
		whitelistOutText .= A_LoopField "`n"
	else if (StartsWith(A_LoopField, "/"))
		regexOutText .= A_LoopField "`n"
	else if (IsIPEntry(A_LoopField))
		ipOutText .= A_LoopField "`n"
	else if (InStr(A_LoopField, "^$") && InStr(A_LoopField, "third-party"))
		thirdpartyOutText .= StrReplace(A_LoopField, StrSplit(A_LoopField, "$")[2], "third-party,script,popup") "`n"
	else if (StartsWith(A_LoopField, "||") && EndsWith(A_LoopField, "^")) {
		urlArray := StrSplit(A_LoopField, ".", "|^")
		urlArrayLength := urlArray.Length()
		
		if (urlArrayLength = 2) {
			
		}
	
		/*
		_l := _Array.Length()
		if (_l > 1) {
			tld := _Array[_l - 1] "." _Array[_l]
		
			if (!tldObj.HasKey(tld))
				tldObj[tld] := []
		}
	
		tldObj[tld].Push(A_LoopField)
		*/
		
		outTextArray[outTextArrayIndex] := A_LoopField
		
		if (outTextArrayIndex = 300000) {
			outArray.Push(outTextArray)
			outTextArray := []
			outTextArrayIndex := 1
		} else
			outTextArrayIndex += 1
	} else {
		crapList .= A_LoopField "`n"
		continue
	}
}

outArray.Push(outTextArray)
_l := outTextArray.Length()
outTextArray := ""
bigList := ""

FileDelete, % whitelistOutFile
if (whitelistOutText != "") {
	FileAppend, % whitelistOutText, % whitelistOutFile
	whitelistOutText := ""
}

FileDelete, % regexOutFile
if (regexOutText != "") {
	FileAppend, % regexOutText, % regexOutFile
	regexOutText := ""
}

FileDelete, % iplistOutFile
if (ipOutText != "") {
	FileAppend, % ipOutText, % iplistOutFile
	ipOutText := ""
}

if (thirdpartyOutText != "") {
	Sort, thirdpartyOutText, U
	FileDelete, % thirdpartylistOutFile
	FileAppend, % thirdpartyOutText, % thirdpartylistOutFile
	thirdpartyOutText := ""
}

/*
for key, arr in tldObj {
	if (arr.Length() < 100) {
		tldObj.Delete(key)
		continue
	}

	outText := ""
	outFile := tldListDir "\" fileName " (" key ").txt"

	for i, v in arr
		outText .= v "`n"
	
	FileDelete, % outFile
	FileAppend, % outText, % outFile
	tldObj.Delete(key)
}
*/

FileDelete, % theBigCleanListFile

for index, arr in outArray {
	outText := ""
	outFile := "..\" fileName " (" index ").txt"

	for i, v in arr
		outText .= v "`n"
	
	FileDelete, % outFile
	FileAppend, % outText, % outFile
	FileAppend, % outText, % theBigCleanListFile
	outArray[index] := ""
}

ExitApp


Distinct(list1, list2) {
	list := list1
	list .= list2
	Sort, list, U
	return list
}

ComArray() {
	arr := ComObjArray(8, 2)
	arr[0] := "string 1"
	arr[1] := "string 2"
	param := COM_Parameter(0x2008, ComObjValue(arr))
}

COM_Parameter(typ, prm := "", nam := "")
{
	Return	IsObject(prm)?prm:Object("typ_",typ,"prm_",prm,"nam_",nam)
}