from urllib import request
from urllib.request import Request, urlopen
from urllib.error import URLError

def main():
	req = Request("https://www.oceanswift.net/am.html")
	try:
		response = urlopen(req)		
	except URLError as e:
		if hasattr(e, 'reason'):
			print('We failed to reach a server.')
			print('Reason: ', e.reason)
			print('Error code: ', e.code)
		elif hasattr(e, 'code'):
			print('The server couldn\'t fulfill the request.')
			print('Error code: ', e.code)
		else:
			print("everything is fine")

if __name__ == "__main__":
    main()