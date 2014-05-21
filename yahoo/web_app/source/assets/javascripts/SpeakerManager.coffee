class window.SpeakerManager
	_baseURL = './assets/images/speakers/'
	_currentVoteTarget = ''
	_queue = null
	_scale = 1
	_speakersData = null
	_stage = null
	_x = 0
	_y = 0

	_speaker = null

	constructor: (args)->
		_scale = args.scale
		_speakersData = args.speakersData
		_stage = args.stage
		_x = args.x
		_y = args.y

		_queue = new createjs.LoadQueue true
		_queue.addEventListener 'complete', handleLoadComplete


	# private
	handleLoadComplete = (event)->
		_speaker = new Speaker
			img: _queue.getResult 'speaker'
			name: _speakersData[_currentVoteTarget].name
			scale: _scale
			x: _x
			y: _y
			width: _stage.canvas.width - _x * 2

		_stage.addChild _speaker
		@

	# public
	updateSpeaker: (currentVoteTarget)->
		_currentVoteTarget = currentVoteTarget
		fileName = _speakersData[_currentVoteTarget].src
		manifest = [
			{ id: 'speaker', src: _baseURL + fileName }
		]
		_queue.loadManifest manifest, true

	pulse: ->
		_speaker.pulse()



	class Speaker extends createjs.Container
		_color = '#000'
		_fontFamily = 'misaki_gothic, Sans-Serif'
		_fontSize = '28px'
		_scale = 1
		_scaleBase = 1
		_scaleExpanded = 1.1

		iconObj: null
		nameObj: null

		constructor: (args)->
			@initialize()
			@x = args.x
			@y = args.y

			_scale = args.scale
			img = args.img
			@iconObj = createIcon.call @, img
			@addChild @iconObj

			nameObj = createName.call @, args.name, args.width
			@addChild nameObj

		# private
		createIcon = (img)->
			icon = new createjs.Bitmap img
			icon.regX = img.width / 2
			icon.regY = img.height / 2
			icon.x = img.width / 2
			icon.y = img.height / 2
			icon

		createName = (nameStr, x)->
			name = new createjs.Text nameStr, "#{_fontSize} #{_fontFamily}", _color
			name.textAlign = 'right'
			name.x = x - 20
			name


		# public
		pulse: ->
			createjs.Tween.get(@iconObj).to({scaleX: _scaleExpanded, scaleY: _scaleExpanded}, 50).to({scaleX: _scaleBase, scaleY: _scaleBase}, 50)
			@

