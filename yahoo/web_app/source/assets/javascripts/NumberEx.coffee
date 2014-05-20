Number.prototype.addFigure = ->
	r = @toString().replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,' )
	
Number.prototype.fillZero = (n)->
	r = @toString().split('')
	while r.length <= n
		r.unshift '0'
	r.join ''