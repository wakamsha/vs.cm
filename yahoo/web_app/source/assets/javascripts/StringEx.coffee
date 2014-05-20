String.prototype.addFigure = ->
	r = @replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,' )

String.prototype.trim = ->
	r = @replace(/^\s+|\s+$/g, "")
