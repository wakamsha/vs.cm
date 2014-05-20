class window.Info
	_info = {}
	_infoList = {}
	_infoListDOM = {}
	constructor: (args)->
		_info = new cjs.DOMElement(document.getElementById(args.info))
		_infoInner = document.querySelector('.info-inner');
		_infoInner.style.minHeight = app.stage.canvas.height / 2 - 23 + 'px'
		_infoInner.style.maxHeight = app.stage.canvas.height / 2 - 23 + 'px'
		_info.x = 0
		_info.y = app.stage.canvas.height / 2
		app.stage.addChild _info
		_infoList = new cjs.DOMElement(document.getElementById args.infoList)
		app.stage.addChild _infoList

	# private
	setInfo = (value)->
		unless value? then return
		li = document.createElement 'li'
		li.textContent = value
		_infoList.htmlElement.appendChild li

	tweenInfo = ->
		cjs.Tween.get(_infoList).to({y: -56}, 250, cjs.Ease.quartOut).call(->
			_infoList.htmlElement.removeChild(_infoList.htmlElement.children[0])
		).to({y: 0}, 0)

	# Public
	updateInfo: (value)->
		setInfo.call @, value
		tweenInfo.call @