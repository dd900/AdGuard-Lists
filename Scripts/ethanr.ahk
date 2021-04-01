SetBatchLines, -1
FileEncoding, UTF-8-RAW


ini := ".\combo list.ini"
outFile := "..\Combo Lists\ethanr.txt"
outText := ""


Loop, Parse, % IniRead(ini, "ethanr"), `n, `r
{
	name_url := StrSplit(A_LoopField, "=")
	string := UrlToVar(Trim(name_url[2]))
	
	if (!string)
		continue
	
	index1 := A_Index
	
	Loop, Parse, string, `n, `r
	{
		entry := A_LoopField
		Menu, Tray, Tip, % index1 "`n" A_Index "`n" entry
		
		if (!entry || StartsWith(entry, "//") || StartsWith(entry, "#") || StartsWith(entry, "!"))
			continue
		
		if (InStr(entry, "127.0.0.1  localhost"))
			continue
			
		if (StartsWith(entry, "127.0.0.1"))
			entry := StrReplace(entry, "127.0.0.1", "")
		
		if (InStr(entry, "#"))
			entry := StrSplit(entry, "#")[1]
		
		if (InStr(entry, "(SSL)"))
			entry := StrReplace(entry, "(SSL)", "")
		
		entry := "||" Trim(entry) "^"
		
		if (!entry || entry = "||^")
			continue
		
		outText .= entry "`n"
	}
}

Sort, outText, U
FileDelete, % outFile
FileAppend, % outText, % outFile
ExitApp
