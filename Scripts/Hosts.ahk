#MaxMem 256
SetBatchLines, -1
FileEncoding, UTF-8-RAW


ini := A_ScriptDir "\combo list.ini"
outFile := "..\Combo Lists\HostLists.txt"
outText := ""


Loop, Parse, % IniRead(ini, "0.0.0.0"), `n, `r
{
	name_url := StrSplit(A_LoopField, "=")
	string := UrlToVar(Trim(name_url[2]))
	
	if (!string)
		continue
	
	index1 := A_Index
	
	Loop, Parse, string, `n, `r
	{
		entry := A_LoopField
				
		if (!entry || StartsWith(entry, "//") || StartsWith(entry, "#") || StartsWith(entry, "!") || !StartsWith(entry, "0.0.0.0"))
				continue
		
		entry := StrReplace(entry, "0.0.0.0", "")
		entry := InStr(entry, "#") 
			? FixEntry("||" Trim(StrSplit(entry, "#")[1]) "^")
			: FixEntry("||" Trim(entry) "^")
			
		if (!entry || entry = "||^")
			continue
			
		outText .= entry "`n"
	}
	
	if (index1 > 1)
		Sort, outText, U
}

Loop, Parse, % IniRead(ini, "127.0.0.1"), `n, `r
{
	name_url := StrSplit(A_LoopField, "=")
	string := UrlToVar(Trim(name_url[2]))
	
	if (!string)
		continue
	
	index1 := A_Index
	
	Loop, Parse, string, `n, `r
	{
		entry := A_LoopField
				
		if (!entry || StartsWith(entry, "//") || StartsWith(entry, "#") || StartsWith(entry, "!") || !StartsWith(entry, "127.0.0.1"))
				continue
		
		if (InStr(entry, "127.0.0.1 localhost"))
			continue
		
		entry := StrReplace(entry, "127.0.0.1", "")
		entry := InStr(entry, "#") 
			? FixEntry("||" Trim(StrSplit(entry, "#")[1]) "^")
			: FixEntry("||" Trim(entry) "^")
			
		if (!entry || entry = "||^")
			continue
			
		outText .= entry "`n"
	}
	
	if (index1 > 1)
		Sort, outText, U
}

if (index1 < 2)
	Sort, outText, U

FileDelete, % outFile
FileAppend, % outText, % outFile
ExitApp
