class window.Count
	_limit = 0
	_currentCount = 0
	_countValue = 1
	_keyname = ''
	_counter = {}
	
	# Constructor
	constructor: (args)->
		_keyname = args.keyname
		_limit = args.limit
		_counter = new cjs.DOMElement(document.getElementById(args.counterId))
		_counter.x = 0
		_counter.y = 0

		args.stage.addChild _counter
		
		localData = localStorage.getItem _keyname
		if localData
			localDataObj = JSON.parse localData
			_currentCount = localDataObj.count
		
		updateCounter.call @

	# Private
	clear = ->
		_currentCount = 0
		localStorage.removeItem _keyname
		updateCounter.call @
		
	save = (n)->
		_currentCount += n
		localData = {}
		localData.count = _currentCount
		localData.timestamp = new Date().getTime()
		localDataJson = JSON.stringify localData
		try
			localStorage.setItem _keyname, localDataJson
		catch error
			console.log error

	updateCounter = ->
		tmpStr = _currentCount.fillZero 3
		_counter.htmlElement.innerHTML = tmpStr

	# Public
	countUp: (n)->
		save.call @, n
		updateCounter.call @

	getCurrentCount: ->
		_currentCount

	getCountValue: ->
		_countValue

	setCountValue: (n)->
		_countValue = n

	clearCount: ->
		clear.call @