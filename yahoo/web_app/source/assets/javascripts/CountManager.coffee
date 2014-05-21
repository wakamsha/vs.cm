class window.CountManager extends createjs.Container

	_keyName = ''
	_countValue = 1
	_currentCount = 0
	_countsTooBigLimit = 0
	_counter = null
	_color = '#000'
	_fontFamily = 'Conv_UQ_0, sans-serif'
	_fontSize = '160px'
	_stage = null

	constructor: (args)->
		@initialize()
		_keyName = args.keyName
		_countValue = args.countValue
		_stage = args.stage

		localData = localStorage.getItem _keyName
		if localData
			localDataObj = JSON.parse localData
			_currentCount = localDataObj.count

		createBackground.call @, args.backgroundImage
		createCounter.call @
		updateCounter.call @

	# private
	clear = ->
		_currentCount = 0
		localStorage.removeItem _keyName
		updateCounter.call @

	save = ->
		localData = {}
		localData.count = _currentCount
		localData.timestamp = new Date().getTime()
		localDataJson = JSON.stringify localData
		try
			localStorage.setItem _keyName, localDataJson
		catch error
			console.log error

	createBackground = (img)->
		bmp = new createjs.Bitmap img
		bmp.regX = bmp.image.width
		bmp.x = _stage.canvas.width - 20
		bmp.y = 24
		_stage.addChild bmp
		@

	createCounter = ->
		_counter = new createjs.Text '', "bold #{_fontSize} #{_fontFamily}", _color
		_counter.textAlign = 'right'
		_counter.x = _stage.canvas.width - 40
		_counter.y = 50
		@addChild _counter

	updateCounter = ->
		tmpStr = _currentCount.fillZero 3
		_counter.text = tmpStr


	# public
	incrementCount: (n)->
		_currentCount += n
		save.call @
		updateCounter.call @

	getCurrentCount: ->
		_currentCount

	getCountValue: ->
		_countValue

	setCountValue: (n)->
		_countValue = n

	clearCount: ->
		clear.call @