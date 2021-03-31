UrlToVar(url) {
	try {
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", url, false)
		whr.Send()
		whr.WaitForResponse()
		out := whr.ResponseText
	} catch {
		out := ""
	}
	
	whr := ""
	return out
}