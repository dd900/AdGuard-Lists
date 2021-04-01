FixEntry(entry) {
	if (InStr(entry, "^^"))
		entry := StrReplace(entry, "^^", "^")
	
	if (InStr(entry, "^|"))
		entry := StrReplace(entry, "^|", "^")
	
	if (InStr(entry, "|||") = 1)
		entry := StrReplace(entry, "|||", "||")
	
	if (InStr(entry, "@@http") = 1)
		entry := StrReplace(entry, "@@http", "@@||http")
	
	if (InStr(entry, "@@:") = 1)
		entry := StrReplace(entry, "@@:", "@@||:")
	
	if (InStr(entry, "@@.") = 1)
		entry := StrReplace(entry, "@@.", "@@||*.")
	
	if (InStr(entry, "||.") = 1)
		entry := StrReplace(entry, "||.", "||*.")
	
	if (InStr(entry, "@@www") = 1)
		entry := StrReplace(entry, "@@www", "@@||www")
	
	return entry
}