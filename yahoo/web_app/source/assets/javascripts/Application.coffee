//= require NumberEx
//= require StringEx
//= require EventObserver
//= require Button
//= require CountManager
//= require Device
//= require InfoManager
//= require SocketIO_coffee
//= require SpeakerManager
//= require Votes
//= require settings


countManager    = null
device          = null
infoManager     = null
queue           = null
speakerManager  = null
stage           = null
scale           = 1
socketio        = null


handleClickButton = (event)->
	console.log 'button clicked'
	speakerManager.pulse()
	countManager.incrementCount 1

initButton = ->
	button = new Button
		id: 'btn-a'
		clickHandler: handleClickButton
	@

initCount = ->
	countManager = new CountManager
		keyName: 'vs_cm'
		countValue: 1
		stage: stage
		backgroundImage: queue.getResult 'counter-bg'
	stage.addChild countManager

initConnect = ->

initInfo = ->
	infoManager = new InfoManager
		x: 40 * scale
		y: stage.canvas.height / 2
		width: stage.canvas.width - (80 * scale)
		height: stage.canvas.height / 2 - (40 * scale)
		scale: scale
	stage.addChild infoManager

initSpeaker = ->
	speakerManager = new SpeakerManager
		speakersData: queue.getResult('speakersData').speakers
		stage: stage
		scale: scale
		x: 80 * scale
		y: 40 * scale

	speakerManager.updateSpeaker 'vote0'

createMainCanvasStage = (device, canvasId)->
	s = new createjs.Stage(canvasId)
	canvas = s.canvas
	ratio = device.getRatio()
	stageSize = device.getStageSize()
	deviceHeight = stageSize.height
	deviceWidth = stageSize.width
	canvas.height = deviceHeight * ratio
	canvas.width = deviceWidth * ratio
	canvas.style.height = "#{deviceHeight}px"
	canvas.style.width = "#{deviceWidth}px"
	s

handleInitialLoadComplete = (event)->
	queue.removeEventListener event.type, arguments.callee

	initButton()
	initSpeaker()
	initCount()
	initInfo()
	@

initLoad = ->
	# init Tick
	createjs.Ticker.setFPS 15
	createjs.Ticker.addEventListener 'tick', ->
		stage.update()

	# get device info
	device = new Device()
	if device.isUnsupportedDevice()
		console.log 'ご利用のブラウザはサポート対象外です'

	# init scale
	scale = device.getScale()

	# create stage
	stage = createMainCanvasStage device, 'main-canvas'
	stage.canvas.className = 'loading'

	# load assets
	manifest = [
		{ id: 'soundVote', src: './assets/audio/b_071.m4a' }
		{ id: 'counter-bg', src: './assets/images/bg-counter.png' }
		{ id: 'speakersData', src: './assets/javascripts/data/speakers.json' }
	]
	queue = new createjs.LoadQueue true
	queue.installPlugin createjs.Sound
	createjs.Sound.alternateExtensions = ['mp3'];
	queue.addEventListener 'complete', handleInitialLoadComplete
	queue.loadManifest manifest, true
	@

window.addEventListener 'load', (event)->
	window.removeEventListener event.type, arguments.callee
	initLoad()
	@