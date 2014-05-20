//= require EventObserver
//= require visual/Particle
//= require settings

var app = {
	canvas: {},
	stage: {},
	particle: {},
	queue: null,
	request: {},
	speaker: null,
	speakerCount: 0,
	speakers: [],
	currentCount: 0,
	currentVoteTarget: '',
	lastVoteValue: 0
};

var handleLoadSpeakerComplete = function(event) {
	var img = app.queue.getResult('speaker');
	if (!app.speaker) {
		app.speaker = new createjs.Bitmap(img);
		app.speaker.regY = img.height / 2;
		app.speaker.regX = img.width / 2;
		app.speaker.x = app.canvas.width / 2;
		app.speaker.y = app.canvas.height / 2;
		app.stage.addChild(app.speaker);
	} else {
		app.speaker.image = img;
	}

	if (app.speakerCount < 14) {
		app.speakerCount ++;
	} else {
		app.speakerCount = 0;
	}

	// show particle
	setInterval(function() {
		// var _url = 'http://54.199.157.61:8882/get/room_status';
		// var _url = 'http://yxcm-prod-apielast-1bjmmsxd8mb59-1864953392.ap-northeast-1.elb.amazonaws.com/get/room_status';
		var _url = settings.socketio.baseURL + 'room_status';
		var xhr = new XMLHttpRequest;
		xhr.open('GET', _url, true);
		xhr.onload = function() {
			if (xhr.status >= 200 && xhr.status < 400) {
				var data = JSON.parse(xhr.response);
				if (app.lastVoteValue > 0) {
					var delta = Math.sqrt(data[app.currentVoteTarget] - app.lastVoteValue) / 1;
					for (var i=0; i<delta; i++) {
						setTimeout(applyParticle, 500);
					}
				}
				app.lastVoteValue = data[app.currentVoteTarget];
			} else {
				console.log('error: speakers data');
			}
		};
		xhr.send();
	}, 1000);
};

var tick = function() {
	// loop through all of the active sparkles on stage:
	var l = app.stage.getNumChildren();
	for (var i=l-1; i>0; i--) {
		var sparkle = app.stage.getChildAt(i);

		// apply gravity and friction
		sparkle.vY += 2;
		sparkle.vX *= 0.98;

		// update position, scale, and alpha:
		sparkle.x += sparkle.vX;
		sparkle.y += sparkle.vY;
		sparkle.scaleX = sparkle.scaleY = sparkle.scaleX+sparkle.vS;
		sparkle.alpha += sparkle.vA;

		//remove sparkles that are off screen or not invisble
		if (sparkle.alpha <= 0 || sparkle.y > app.canvas.height) {
			app.stage.removeChildAt(i);
		}
	}

	app.stage.update();
};

var updateSpeaker = function(vote_target) {
	if (!vote_target) return;
	var idx = vote_target;
	app.currentVoteTarget = app.speakers[idx].vote_target;
	var filename = app.speakers[idx].src;
	var baseURL = '../assets/images/speakers/';
	var manifest = [
		{ id: 'speaker', src: baseURL + filename }
	];
	if (!app.queue) {
		app.queue = new createjs.LoadQueue(true);
		app.queue.addEventListener('complete', handleLoadSpeakerComplete);
	}
	app.queue.loadManifest(manifest, true);
};

var applyParticle = function() {
	var x = Math.random() * window.innerWidth - 21,
		y = Math.random() * window.innerHeight - 21,
		count = Math.random() * 200 + 100 | 0;
	app.particle.addParticles(count, x, y, 2);
};

var initStage = function(canvasID) {
	app.canvas = document.getElementById(canvasID);
	app.canvas.width = window.innerWidth;
	app.canvas.height = window.innerHeight;
	app.canvas.style.width = app.canvas.width + 'px';
	app.canvas.style.height = app.canvas.height + 'px';
	app.stage = new createjs.Stage(app.canvas);
};

var getHostname = function() {
	var _url = settings.socketio.baseURL + 'hostname';
	var xhr = new XMLHttpRequest;
	xhr.open('GET', _url, true);
	xhr.onload = function() {
		if (xhr.status >= 200 && xhr.status < 400) {
			var data = xhr.responseText;
			connectTo(data);
		} else {
			console.log('error: speakers data');
		}
	};
	xhr.send();
};

var connectTo = function(hostname) {
	var socket = io.connect('http://' + hostname);
	socket.on('segment', function(data) {
		updateSpeaker(data.vote_target);
	});
};

var initLoad = function() {
	// init stage
	initStage('canvas');

	// init particle
	var data = {
		images: ["../assets/images/particles-like.png"],
		frames: {width:21,height:23,regX:10,regY:11}
	};
	app.particle = new Particle({
		stage: app.stage,
		data: data
	});

	// init Tick
	createjs.Ticker.setFPS(20);
	createjs.Ticker.addEventListener('tick', tick);

	// init Speaker
	app.request = new XMLHttpRequest;
	app.request.open('GET', '../assets/javascripts/data/speakers.json', true);
	app.request.onload = function() {
		if (app.request.status >= 200 && app.request.status < 400) {
			var data = JSON.parse(app.request.response);
			app.speakers = data.speakers;
		} else {
			console.log('error: speakers data');
		}
	};
	app.request.send();

	getHostname();
};

window.addEventListener('load', function(event) {
	event.target.removeEventListener(event.type, arguments.callee);
	initLoad();

	setInterval(function() {
		var x = Math.random() * window.innerWidth - 21,
			y = Math.random() * window.innerHeight - 21,
				count = Math.random() * 20 + 1 | 0;
		app.particle.addParticles(count, x, y, 1);
	}, Math.random()*1000 + 1000);
});