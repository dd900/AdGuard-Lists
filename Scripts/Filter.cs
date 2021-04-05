using System;
using System.Linq;
using System.Collections;

class Filter
{
	public string FilterList(string list1, string list2)
	{
		var l1 = list1.Replace("\r", "").Split(new char[] { '\n' }, StringSplitOptions.RemoveEmptyEntries).ToList();
		var l2 = list2.Replace("\r", "").Split(new char[] { '\n' }, StringSplitOptions.RemoveEmptyEntries).ToList();

		var l3 = l1.Except(l2);

		return string.Join("\n", l3);
	}
}