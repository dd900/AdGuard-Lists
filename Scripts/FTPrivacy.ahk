SetBatchLines, -1
FileEncoding, UTF-8-RAW


ini := A_ScriptDir "\combo list.ini"
outFile := "..\Combo Lists\FTPrivacy.txt"
outText := ""


Loop, Parse, % IniRead(ini, "ftprivacy"), `n, `r
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
		
		if (name_url[1] = "xiaomi.regex" || name_url[1] = "smartphone.regex" || name_url[1] = "whitelist.crypto" || name_url[1] = "whitelist.false.positive") {
			if (!StartsWith(entry, "@@") && !StartsWith(entry, "||") && !StartsWith(entry, "/"))
				continue
			
			entry := InStr(entry, "#") ? StrSplit(entry, "#")[1] : entry
			entry := InStr(entry, "^|") ? Trim(StrReplace(entry, "^|", "^")) : Trim(entry)
		} else
			entry := InStr(entry, "#") ? "||" Trim(StrSplit(entry, "#")[1]) "^" : "||" Trim(entry) "^"
		
		if (!entry || entry = "||^")
			continue
		
		outText .= entry "`n"
	}
}

Sort, outText, U
FileDelete, % outFile
FileAppend, % outText, % outFile
ExitApp
