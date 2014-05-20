class window.SocketIO extends EventObserver
	_httpRequest = null
	_interval = 0
	_isConnected = false
	_isMeasuring = false
	_pooledCount = 0
	_s = null
	_url = ''
	_self = null
	_voteTarget = ''
	@segmentData = null

	# constructor
	constructor: (args)->
		_url = args.url
		_interval = args.interval
		_httpRequest = new XMLHttpRequest()
		_httpRequest.open 'GET', _url, true
		# _httpRequest.setRequestHeader 'Cache-Control', 'no-cache'
		# _httpRequest.setRequestHeader 'Content-Type', 'text/plain'
		# _httpRequest.responseType = 'text'
		# _httpRequest.withCredentials = true
		_httpRequest.onreadystatechange = resultHandler
		_httpRequest.send()

		_self = @

	# private
	resultHandler = (event)->
		if (event.currentTarget.readyState == 4) and (event.currentTarget.status == 200)
			unless _httpRequest.responseText then return
			if _isConnected then return
			connectTo.call @, _httpRequest.responseText
		else if (event.currentTarget.readyState == 4) and (event.currentTarget.status == 0)
			_httpRequest.abort()
			if _isConnected then return
			setTimeout ->
				_httpRequest.open 'GET', _url, true
				_httpRequest.send()
				console.log 'host接続再試行1'
			, 300

	myRetry = ->
		_s = null
		setTimeout ->
			_httpRequest.open 'GET', _url, true
			_httpRequest.send()
			console.log 'host接続再試行2'
		, 300

	getRTID = ->
		cookieMap = {}
		if document.cookie
			cookies = document.cookie.split ";"
			for cookie, i in cookies
				kv = cookie.split "="
				key = kv[0]
				cookieMap[ key.trim() ] = kv[1]
		rtid = if "rt" of cookieMap then cookieMap["rt"] else "-1"
		console.log rtid
		rtid

	connectTo = (hostname)->
		if _s and _s.socket.connected then return
		# _s = io.connect "ws://#{hostname}",
		_s = io.connect "http://#{hostname}",
			"reconnect": false
			"auto connect": false
			"connect timeout": 5000
		_s.redoTransports = true
		_s.socket.redoTransports = true

		_s.on 'segment', (data)->
			_self.segmentData = data
			_voteTarget = data.vote_target
			_self.publish 'segment.get'

		_s.on 'connecting', ->
			console.log '接続中・・・'

		_s.on 'connect', ->
			_s.emit 'join',  {room: 'segment'}
			_s.emit 'setup', { rtid: getRTID.call _self}
			_s.emit 'cards', null
			_isConnected = true
			console.log '接続'

		_s.on 'disconnect', ->
			_s.removeAllListeners()
			_isConnected = false
			console.log '切断'
			myRetry.call _self

		_s.on 'error', (data)->
			_s.removeAllListeners()
			_isConnected = false
			console.log 'エラー'
			myRetry.call _self
		
		_s.socket.connect()

	emitVote = ->
		if _s == null then return
		_isMeasuring = true
		setTimeout ->
			if navigator.onLine
				_s.emit 'vote',
					room: _voteTarget
					count: _pooledCount
					tm: new Date() / 1000
				_pooledCount = 0
			_isMeasuring = false
			@
		, _interval + 200 + (Math.random()*300)>>0

	# public
	vote: (value)->
		_pooledCount += value
		if _isMeasuring then return
		emitVote.call @

	getCard: (cardId)->
		_s.emit 'card', cardId
