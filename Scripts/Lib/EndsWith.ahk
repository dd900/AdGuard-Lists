EndsWith(string, value, chars := 1) {
	return SubStr(string, 1 - chars) = value
}