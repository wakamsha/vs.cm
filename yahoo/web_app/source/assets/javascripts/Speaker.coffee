class window.Speaker
	bmpSpeaker = {}
	_nameDom = {}
	_scaleBase = 1
	_scaleExpanded = 1.1

	# Constructor
	constructor: (args)->
		img = args.img
		margin = 8
		bmpSpeaker = new cjs.Bitmap(img)
		bmpSpeaker.regX = img.width / 2;
		bmpSpeaker.regY = img.height / 2;
		bmpSpeaker.scaleX = if window.innerWidth < 768 then 1/2 else 1.4
		bmpSpeaker.scaleY = if window.innerWidth < 768 then 1/2 else 1.4
		_scaleBase = bmpSpeaker.scaleX
		_scaleExpanded = _scaleBase * 1.1
		bmpSpeaker.x = if window.innerWidth < 768 then bmpSpeaker.regX / 2 + margin else (bmpSpeaker.regX - margin)*2
		bmpSpeaker.y = if window.innerWidth < 768 then (img.height / 4) + margin else img.height - margin * 3
		app.stage.addChild bmpSpeaker
		_nameDom = document.getElementById 'speaker-name'
		_nameDom.innerHTML = args.name

	# Public
	pulse: ->
		cjs.Tween.get(bmpSpeaker).to({scaleX: _scaleExpanded, scaleY: _scaleExpanded}, 50).to({scaleX: _scaleBase, scaleY: _scaleBase}, 50)

	updateSpeaker: (foo, name)->
		img = foo
		bmpSpeaker.image = img
		_nameDom.innerHTML = name
