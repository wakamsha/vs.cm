class window.Device
	constructor: ->
		ua = window.navigator.userAgent.toLowerCase()
		@ratio = if ua.indexOf('ipad') != -1 then 1 else 2
		if (ua.indexOf('iphone') > 0 and ua.indexOf('ipad') == -1) or ua.indexOf('ipod') > 0 or ua.indexOf('android') > 0
			@stageH =  (if window.innerHeight > window.innerWidth then window.innerHeight else window.innerWidth - 100)
			@stageW = if (window.innerHeight > window.innerWidth) then screen.width else window.innerHeight
		else
			@ratio = 1
			@stageH = window.innerHeight
			@stageW = window.innerWidth

	# getAspect = ->
	# 	a = window.screen.width
	# 	b = window.screen.height
	# 	for i = Math.min(a,b); i > 1
	getRatio: ->
		@ratio

	getStageSize: ->
		return {
			height: @stageH
			width: @stageW
		}