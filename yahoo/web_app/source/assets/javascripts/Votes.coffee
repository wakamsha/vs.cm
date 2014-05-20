class window.Votes
	_totalVotes = undefined
	_limit = 0
	
	# Constructor
	constructor: (args)->
		_limit = args.limit || 9999999
		@_domTotalVotes = document.getElementById(args.totalVotesId)
		@updateTotalVotes(0)

	# Public
	getVoteStatus: ->
		return @_voteStatus

	updateVoteStatus: (value)->
		if value == undefined then value = 'on'
		@_voteStatus = value

	updateTotalVotes: (value)->
		if value == undefined then return undefined
		if _totalVotes == value then return undefined
		str = value.fillZero(6).addFigure()
		@_domTotalVotes.innerHTML = str

	testIncrement: ->
		setInterval =>
			foo = (Math.random()*10000) >>0
			@updateTotalVotes foo
		, 1000
