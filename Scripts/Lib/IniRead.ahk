IniRead(file, section:="", key:="", default:="") {
	IniRead, out, % file, % section, % key, % default
	return out
}