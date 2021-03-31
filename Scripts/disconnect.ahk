SetBatchLines, -1
FileEncoding, UTF-8-RAW

ini := A_ScriptDir "\combo list.ini"
outFile := "C:\Users\Too DementiaNull\Documents\GitHub\adblock\Legacy\Disconnect.Me.txt"
headerText := "# Disconnect.Me Legacy Compilation List for AdGuard Home by Dustin Davidson`n# Credit to: Disconnect.Me`n`n`n"
outText := ""
hostFiles := []

Loop, Parse, % IniRead(ini, "disconnect"), `n, `r
	hostFiles.Push(Trim(StrSplit(A_LoopField, "=")[2]))

for index, url in hostFiles {
	for i, v in GetDomains(url) {
		if (InStr(v, "#"))
			entry := "||" Trim(StrSplit(v, "#")[1]) "^"
		else
			entry := "||" v "^"
		
		if (!InStr(outText, entry))
			outText .= entry "`n"
	}
}

FileDelete, % outFile
FileAppend, % headerText outText, % outFile
ExitApp

GetDomains(url) {
	out := []
	string := UrlToVar(url)
	
	Loop, Parse, string, `n, `r
	{
		if (InStr(A_LoopField, "Malvertising list by Disconnect") || InStr(A_LoopField, "Malware list by Disconnect"))
			continue
		
		if (A_LoopField != "" && !InStr(A_LoopField, "#") = 1 && !InStr(A_LoopField, "!") = 1 && !InStr(A_LoopField, "(") = 1)
			out.Push(Trim(A_LoopField))
	}
	
	return out
}