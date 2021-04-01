IsIPEntry(entry) {
	out := 0
	entry := StrReplace(StrReplace(entry, "||", ""), "^", "")
	entrySplit := StrSplit(entry, ".")
	
	if (entrySplit.Length() < 3 || entrySplit.Length() > 4)
		return out
	
	Loop, % entrySplit.Length()
	{
		var := entrySplit[A_Index]
		
		if (A_Index = 1 || A_Index = 2) {
			if var is not Integer
			{
				out := 0
				break
			}
		} else {
			if var is not Integer
			{
				if (var != "*") {
					out := 0
					break
				}
			}
		}
		
		out := 1
	}
	
	return out
}