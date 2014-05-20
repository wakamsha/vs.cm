class window.Socket
	_isConnected = false
	_pooledCount = 0
	_isMeasuring = false
	_url = ''
	_interval = 0
	_httpResuest = {}

	# Constructor
	constructor: (args)->
		_url = args.url
		_interval = args.interval
		_httpResuest = new XMLHttpRequest()
		_httpResuest.open 'GET', _url, true
		_httpResuest.send()
		_httpResuest.onreadystatechange = resultHandler

	# private
	resultHandler = (e)->
		



