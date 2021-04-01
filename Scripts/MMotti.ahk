SetBatchLines, -1
FileEncoding, UTF-8-RAW


ini := A_ScriptDir "\combo list.ini"
outFile := "..\Combo Lists\MMotti.txt"
outText := ""


Loop, Parse, % IniRead(ini, "MMotti"), `n, `r
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
		
		if (name_url[1] != "whitelist.pihole" && (StartsWith(entry, "@@") || StartsWith(entry, "||") || StartsWith(entry, "/")))
			entry := Trim(entry)
		else if (name_url[1] = "whitelist.pihole")
			entry := "@@||" Trim(entry) "^"
		else
			continue
		
		if (!entry || entry = "||^")
			continue
		
		outText .= entry "`n"
	}
}

Sort, outText, U
FileDelete, % outFile
FileAppend, % outText, % outFile
ExitApp
