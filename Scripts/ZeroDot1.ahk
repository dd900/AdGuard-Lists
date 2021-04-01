#MaxMem 256
SetBatchLines, -1
FileEncoding, UTF-8-RAW


ini := A_ScriptDir "\combo list.ini"
outFile := "..\Combo Lists\ZeroDot1.txt"
outText := ""


Loop, Parse, % IniRead(ini, "ZeroDot1"), `n, `r
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
		
		if (name_url[1] = "hosts.browser" && StartsWith(entry, "0.0.0.0")) {
			entry := StrReplace(entry, "0.0.0.0", "")
			entry := InStr(entry, "#") ? "||" Trim(StrSplit(entry, "#")[1]) "^" : "||" Trim(entry) "^"
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
