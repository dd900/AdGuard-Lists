#MaxMem 256
SetBatchLines, -1
FileEncoding, UTF-8-RAW


ini := A_ScriptDir "\combo list.ini"
outFile := "..\Combo Lists\anudeep.txt"
outText := ""


Loop, Parse, % IniRead(ini, "anudeep"), `n, `r
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
		
		entry := InStr(entry, "#") ? StrSplit(entry, "#")[1] : entry
		
		if (name_url[1] = "whitelist")
			entry := "@@||" Trim(entry) "^"
		else if (name_url[1] != "whitelist" && StartsWith(entry, "0.0.0.0"))
			entry := FixEntry("||" Trim(StrReplace(entry, "0.0.0.0", "")) "^")
		else
			continue
		
		if (!entry || entry = "||^" || entry = "@@||^")
			continue
			
		outText .= entry "`n"
	}
}

Sort, outText, U
FileDelete, % outFile
FileAppend, % outText, % outFile
ExitApp
