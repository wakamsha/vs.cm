# class window.Speaker extends EventObserver
# 	_jsonURL = '../assets/javascripts/data/speakers.json'
# 	_baseURL = '../assets/images/speakers/'
# 	_filename = ''
# 	_index = ''
# 	_manifest = null
# 	_count = 0
# 	_speakers = null
# 	_currentVoteTarget = ''
# 	_queue = null,
# 	_currentSpeaker = null

# 	constructor: ->
# 		xhr = new XMLHttpRequest
# 		xhr.open 'GET', _jsonURL, true
# 		xhr.onload = =>
# 			if xhr.status >= 200 and xhr.status < 400
# 				data = JSON.parse xhr.response
# 				_speakers = data.speakers;
# 				updateSpeaker.call @
# 			else
# 				console.log 'error: speakers data'
# 		xhr.send();

# 	# private
# 	updateSpeaker = ->
# 		_index = "vote#{_count}"
# 		_currentVoteTarget = _speakers[_index].vote_target
# 		filename = _speakers[_index].src
# 		_manifest = [
# 			{ id: 'speaker', src: baseURL + filename }
# 		]
# 		unless _queue
# 			_queue = new createjs.LoadQueue(true)
# 			_queue.addEventListener 'complete', =>
# 				handleLoadSpeakerComplete.call @
# 		_queue.loadManigest _manifest, true

# 	handleLoadSpeakerComplete = ->
# 		img = _queue.getResult 'speaker'
# 		unless _currentSpeaker
# 			_currentSpeaker = new createjs.Bitmap(img)
# 			_currentSpeaker.regY = img.height / 2;
# 			_currentSpeaker.regX = img.width / 2;
# 			_currentSpeaker.x = app.canvas.width / 2;
# 			_currentSpeaker.y = app.canvas.height / 2;
# 			app.stage.addChild app.speaker
# 			_currentSpeaker.addEventListener 'click', (event)=>
# 				updateSpeaker.call @
# 		else
# 			_currentSpeaker.image = img

# 		if _count < 14 -1
# 			_count += 1
# 		else
# 			_count = 0

# 		@publish 'loadSpeakerComplete'

# 	# public

