#MaxMem 256
SetBatchLines, -1
FileEncoding, UTF-8-RAW


ini := A_ScriptDir "\combo list.ini"
outFile := "..\Combo Lists\AdGuardFormatLists.txt"
outText := ""


Loop, Parse, % IniRead(ini, "AG"), `n, `r
{
	name_url := StrSplit(A_LoopField, "=")
	string := UrlToVar(Trim(name_url[2]))
	
	if (!string)
		continue
	
	index1 := A_Index
	
	Loop, Parse, string, `n, `r
	{
		entry := A_LoopField
				
		if (!entry || StartsWith(entry, "//") || StartsWith(entry, "#") || StartsWith(entry, "!"))
			continue
		
		if (!StartsWith(entry, "@@") && !StartsWith(entry, "||") && !StartsWith(entry, "/"))
			continue
		
		entry := InStr(entry, "#") ? Trim(StrSplit(entry, "#")[1]) : Trim(entry)
		
		if (StartsWith(entry, "@@redditmedia.com"))
			entry := StrReplace(entry, "@@redditmedia.com", "@@||redditmedia.com")
		
		if (!entry || entry = "||^")
			continue
		
		outText .= entry "`n"
	}
	
	if (index1 > 1)
		Sort, outText, U
}

FileDelete, % outFile
FileAppend, % outText, % outFile
ExitApp
