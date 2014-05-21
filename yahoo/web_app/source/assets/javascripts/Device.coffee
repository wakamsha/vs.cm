class window.Device
	_baseW = 320 * 2
	_baseH_40 = 444 * 2	# 4inch
	_baseH_35 = 356 * 2	# 3.5inch
	_displayOffset = 16
	_ratio = 1
	_stageW = 0
	_stageH = 0
	_isLongScale = true
	_ua = window.navigator.userAgent.toLowerCase()
	_scale = 1
	_isUnsupportedDevice = true
	_aspect = []

	constructor: ->
		_ratio = if window.devicePixelRatio then window.devicePixelRatio else 1

		_baseW = _baseW / _ratio
		_baseH_40 = _baseH_40 / _ratio
		_baseH_35 = _baseH_35 / _ratio

		initAspect.call @

		if _ua.indexOf('phone') > 0 or _ua.indexOf('ipad') > 0 or _ua.indexOf('ipod') > 0 or _ua.indexOf('android') > 0
			_isUnsupportedDevice = false

		if window.innerHeight > window.innerWidth
			_stageH = window.innerHeight
			_stageW = window.innerWidth
		else
			_stageH = window.innerHeight
			scaleFactor = _baseH_40 / _stageH
			_stageW = _baseW / scaleFactor

		_stageW -= _displayOffset * 2
		_stageH = _stageW / 3 * 2

		if getAspect.call(@).indexOf(3) > -1 and !_isUnsupportedDevice and window.innerHeight > window.innerWidth
			_isLongScale = false

		initScale.call @

	# private
	initAspect = ->
		w = window.screen.width
		h = window.screen.height
		for i in [Math.min(w,h)..0] by -1
			if w%i == 0 and h%i == 0
				_aspect.push(w / i)
				_aspect.push(h / i)
				break
		@

	initScale = ->
		ratio_40 = _baseH_40 / _baseW
		ratio_35 = _baseH_35 / _baseW
		ratio_stage = _stageH / _stageW
		if Math.abs(ratio_stage - ratio_40) < Math.abs(ratio_stage - ratio_35)
			_scale = Math.min(_stageW / _baseW, _stageH / _baseH_40)
		else
			_scale = Math.min(_stageW / _baseW, _stageH / _baseH_35)
		@


	# public
	getAspect = ->
		_aspect

	getRatio: ->
		_ratio

	getStageSize: ->
		stageSize =
			height: _stageH
			width: _stageW

	getScale: ->
		_scale

	isLongScale: ->
		_isLongScale

	isUnsupportedDevice: ->
		_isUnsupportedDevice