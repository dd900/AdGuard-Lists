﻿SetBatchLines, -1
FileEncoding, UTF-8-RAW


ini := A_ScriptDir "\combo list.ini"
outFile := "C:\Users\Too DementiaNull\Documents\GitHub\adblock\Combo Lists\DandelionSprout.txt"
outText := ""


Loop, Parse, % IniRead(ini, "DandelionSprout"), `n, `r
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
		
		if (name_url[1] = "AntiMalware") {
			if (StartsWith(entry, "@@") || StartsWith(entry, "||") || StartsWith(entry, "/"))
				entry := InStr(entry, "#") ? Trim(StrSplit(entry, "#")[1]) : Trim(entry)
			else
				entry := InStr(entry, "#") ? "||" Trim(StrSplit(entry, "#")[1]) "^" : "||" Trim(entry) "^"
		}
		
		if (name_url[1] = "GameConsoleList" || name_url[1] = "CompilationList" || name_url[1] = "CompilationList.Notifications") {
			if (!StartsWith(entry, "@@") && !StartsWith(entry, "||"))
				continue
			
			entry := InStr(entry, "#") ? Trim(StrSplit(entry, "#")[1]) : Trim(entry)
		}
		
		if (name_url[1] = "CompilationList.IP")
			entry := InStr(entry, "#") ? "||" Trim(StrSplit(entry, "#")[1]) "^" : "||" Trim(entry) "^"
		
		if (InStr(entry, "^^"))
			entry := StrReplace(entry, "^^", "^")
		
		if (InStr(entry, "|^"))
			entry := StrReplace(entry, "|^", "^")
		
		if (StartsWith(entry, "|||"))
			entry := StrReplace(entry, "|||", "||")­­­­­­­­­­­­­­­
		
		if (StartsWith(entry, "@@http"))
			entry := StrReplace(entry, "@@http", "@@||http")
		
		if (StartsWith(entry, "@@:"))
			entry := StrReplace(entry, "@@:", "@@||:")
		
		if (StartsWith(entry, "@@."))
			entry := StrReplace(entry, "@@.", "@@||*.")
		
		if (StartsWith(entry, "@@www"))
			entry := StrReplace(entry, "@@www", "@@||www")
		
		if (!entry || entry = "||^" || entry = "||​*^" || entry = "||­*^")
			continue
		
		if (entry = "/socket.io/?" || entry = "/scan-update-and-protect-your-browser.html" || entry = "/bitcoinrevolution/lp.php^")
			continue
		
		outText .= entry "`n"
	}
}

Sort, outText, U
FileDelete, % outFile
FileAppend, % outText, % outFile
ExitApp