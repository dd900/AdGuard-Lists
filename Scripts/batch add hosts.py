from requests.adapters import HTTPAdapter
from requests.packages.urllib3.poolmanager import PoolManager
import ssl
import requests
import json

## CHANGE HERE ##
# ip address of AdGuard Home
# "http(s)://<adguardHomeIp:<port>"
host = "http://192.168.1.201:80"
# user name
userName = "x"
# password
password = "x"

urls = [
"https://raw.githubusercontent.com/dd900/AdGuard-Lists/master/DD900%20AGH%20Combo%20List%20(1).txt",
"https://raw.githubusercontent.com/dd900/AdGuard-Lists/master/DD900%20AGH%20Combo%20List%20(2).txt",
"https://raw.githubusercontent.com/dd900/AdGuard-Lists/master/DD900%20AGH%20Combo%20List%20(3).txt",
"https://raw.githubusercontent.com/dd900/AdGuard-Lists/master/DD900%20AGH%20Combo%20List%20(4).txt",
"https://raw.githubusercontent.com/dd900/AdGuard-Lists/master/DD900%20AGH%20Combo%20List%20(5).txt",
"https://raw.githubusercontent.com/dd900/AdGuard-Lists/master/DD900%20AGH%20Combo%20List%20(6).txt",
"https://raw.githubusercontent.com/dd900/AdGuard-Lists/master/DD900%20AGH%20Combo%20List%20(7).txt",
"https://raw.githubusercontent.com/dd900/AdGuard-Lists/master/DD900%20AGH%20Combo%20List%20-%20IP%20Blocklist.txt",
"https://raw.githubusercontent.com/dd900/AdGuard-Lists/master/DD900%20AGH%20Combo%20List%20-%20Regex%20Blocklist.txt"
]

names = [
"DD900 AGH Combo List (1)",
"DD900 AGH Combo List (2)",
"DD900 AGH Combo List (3)",
"DD900 AGH Combo List (4)",
"DD900 AGH Combo List (5)",
"DD900 AGH Combo List (6)",
"DD900 AGH Combo List (7)",
"DD900 AGH Combo List - IP Blocklist",
"DD900 AGH Combo List - Regex Blocklist"
]

############ End Edits #################

# Open TLSv1 Adapter
class MyAdapter(HTTPAdapter):
    def init_poolmanager(self, connections, maxsize, block=False):
        self.poolmanager = PoolManager(num_pools=connections,
                                       maxsize=maxsize,
                                       block=block,
                                       ssl_version=ssl.PROTOCOL_TLSv1)

headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101 Firefox/52.0'}     

s = requests.Session()
s.mount(host, MyAdapter())
x = s.post(host + "/control/login", json.dumps({"name": userName, "password" : password}), headers=headers )
print(x.text)

for i, u in enumerate(urls):
	filterObj = json.dumps({'url':u, "name":names[i],"whitelist":False})
	print(filterObj)
	x = s.post(host + "/control/filtering/add_url", data = filterObj, headers=headers)
	print(x.text)

# help from 
# https://stackoverflow.com/questions/30946370/using-requests-to-login-to-a-website-that-has-javascript-login-form
# https://stackoverflow.com/questions/33818206/python-login-into-a-website-with-javascript-form