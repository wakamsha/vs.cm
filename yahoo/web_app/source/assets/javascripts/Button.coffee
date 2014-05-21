class window.Button

	constructor: (args)->
		eventName = if Modernizr.touch then 'touchstart' else 'click'

		@btn = document.getElementById args.id
		@btn.addEventListener eventName, args.clickHandler

	# public
	addClass: (className)->
		@btn.classList.add className

	removeClass: (className)->
		@btn.classList.remove className
