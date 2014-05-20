//= require NumberEx
//= require StringEx

var initTotalVotes = function(key) {
	var scores = document.querySelectorAll('.table-score .score.' + key);
	var totalVotes = 0;
	for (var i=0; i<scores.length; i++) {
		var tmp = parseInt(scores[i].innerHTML);
		if (isFinite(tmp)) {
			totalVotes += tmp;
		}
	}
	var dom = document.getElementById('total-votes-' + key);
	dom.innerHTML = totalVotes.fillZero(7).addFigure();
};

var initWinSymbols = function(key) {
	var scores = document.querySelectorAll('.table-score tr.' + key);
	for (var i=0; i<scores.length; i++) {
		var icon = document.getElementById('point-' + key + (i + 1));
		icon.classList.add('win');
	}
};

var initVictoryDefeat = function() {
	var sessions = document.querySelectorAll('.table-score tr');
	for (var i=0; i<sessions.length; i++) {
		var yahoo = parseInt(sessions[i].querySelector('.score.yahoo').innerHTML);
		var cm = parseInt(sessions[i].querySelector('.score.cm').innerHTML);
		console.log('yahoo:' + yahoo, ' / cm:' + cm);
		if (Math.max(yahoo, cm) === yahoo) {
			sessions[i].classList.add('yahoo');
		} else if (Math.max(yahoo, cm) === cm) {
			sessions[i].classList.add('cm');
		}
	}
};

var initLoad = function() {
	initVictoryDefeat();
	initTotalVotes('yahoo');
	initTotalVotes('cm');

	initWinSymbols('yahoo');
	initWinSymbols('cm');

};

window.addEventListener('load', function(event) {
	window.removeEventListener(event.type, arguments.callee);
	initLoad();
}, false);