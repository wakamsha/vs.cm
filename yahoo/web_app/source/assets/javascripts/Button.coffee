class window.Button
	constructor: (btnId, clickHandler)->
		eventname = if Modernizr.touch then 'touchstart' else 'click'
		@btn = document.getElementById btnId
		@btn.addEventListener eventname, clickHandler

	addClass: (className)->
		@btn.classList.add className
	removeClass: (className)->
		@btn.classList.remove className
