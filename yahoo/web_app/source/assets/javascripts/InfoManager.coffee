class window.InfoManager extends createjs.Container
	_currentInfo = null

	constructor: (args)->
		@initialize()
		@x = args.x
		@y = args.y
		@_width = args.width
		@_height = args.height
		@_scale = args.scale

		createBackground.call @

	createBackground = ->
		bg = new createjs.Shape()
		bg.graphics.ss(4).s('#000').f('#fff').rr(0,0,@_width,@_height, 8)
		@addChild bg
		
		innerBg = new createjs.Shape()
		innerBg.graphics.f('#000').rr(10,10,@_width - 20, @_height - 20, 8)
		@addChild innerBg
		@

	updateInfo: (value)->
		if _currentInfo
			_currentInfo.hide()
		_currentInfo = new Info
			value: value
			width: @_width
			height: @_height
			container: @
		_currentInfo.show()
		@


	class Info extends createjs.Text
		_color = '#fff'
		_fontFamily = 'misaki_gothic, sans-serif'
		_fontSize = '28px'
		container: null


		constructor: (args)->
			@initialize args.value, "#{_fontSize} #{_fontFamily}", _color
			@lineWidth = args.width
			@lineHeight = 40
			@_height = args.height
			@x = 30
			@container = args.container

		show: ->
			@y = @_height
			@.container.addChild @
			createjs.Tween.get(@).to({y: 30}, 500, createjs.Ease.quartOut)
			@

		hide: ->
			# self = @
			# createjs.Tween.get(@).to({y: @_height * -1}, 500, createjs.Ease.quartOut).call(->
			# 	@container.removeChild self
			# )
			@container.removeChild @