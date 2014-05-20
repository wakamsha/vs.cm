class window.EventObserver
	# 登録
	subscribe: (name, listener, context)->
		@listeners = {} unless @listeners?
		@listeners[name] = [] unless @listeners[name]?
		@listeners[name].push [listener, context]
		@
	# 削除
	unsubscribe: (name, listener)->
		return @ unless @listeners[name]
		for listeners, i in @listeners[name]
			if listeners[0] == listener then @listeners[name].splice(i, 1)
		@
	# 実行
	publish: (name)->
		list = @listeners?[name]
		return @ unless list
		e = {}
		e.target = null
		e.context = null
		e.target = @
		for listeners in list
			e.context = listeners[1]
			listeners[0](e)
		@