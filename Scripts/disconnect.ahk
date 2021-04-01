SetBatchLines, -1
FileEncoding, UTF-8-RAW


ini := ".\combo list.ini"
outFile := "..\Combo Lists\Disconnect.txt"
outText := ""


Loop, Parse, % IniRead(ini, "disconnect"), `n, `r
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
		
		if (!entry || StartsWith(entry, "//") || StartsWith(entry, "#") || StartsWith(entry, "!") || StartsWith(entry, "("))
			continue
		
		if (InStr(entry, "Malvertising list by Disconnect") || InStr(entry, "Malware list by Disconnect"))
			continue
		
		entry := InStr(entry, "#") ? "||" Trim(StrSplit(entry, "#")[1]) "^" : "||" Trim(entry) "^"
			
		if (!entry || entry = "||^")
			continue
			
		outText .= entry "`n"
	}
}

Sort, outText, U
FileDelete, % outFile
FileAppend, % headerText outText, % outFile
ExitApp
