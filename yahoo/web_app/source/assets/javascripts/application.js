//= require NumberEx
//= require StringEx
//= require EventObserver
//= require Button
//= require Count
//= require Device
//= require Info
//= require SocketIO_coffee
//= require Speaker
//= require Votes
//= require settings


var cjs = createjs,
	app = {
		btnAction: {},
		clickEventName: 'click',
		count: {},
		device: {},
		info: {},
		ratio: 1,
		request: {},
		queue: {},
		speaker: null,
		speakerCount: 0,
		speakers: {},
		stage: {},
		soundVote: {},
		socketio: null,
		currentVoteTarget: '',
		isInitial: true
	};

var handleInitialLoadComplete = function(event) {
	app.queue.removeEventListener(event.type, handleInitialLoadComplete);

	// init count
	app.count = new Count({
		keyname: 'vs_cm',
		limit: 9999,
		counterId: 'counter',
		stage: app.stage
	});

	// init info
	app.info = new Info({
		info:'info',
		infoList:'info-list'
	});

	// init sound
	app.soundVote = cjs.Sound.createInstance('soundVote');

	// init buttons
	app.btnAction = new Button('btn-a', function(e) {
		app.count.countUp(1);
		app.socketio.vote(1);
		app.speaker.pulse();
		app.soundVote.play();
	});

	// init socketio
	app.socketio = new SocketIO({
		// url: 'http://54.199.157.61:8881/hostname',
		// url: 'http://ws.rt.classmethod.jp/hostname',
		url: settings.socketio.baseURL + 'hostname',
		interval: 1200
	});
	app.socketio.subscribe('segment.get', function(event) {
		// console.log('segment取得成功');
		var segmentData = app.socketio.segmentData;
		// 活性・非活性
		if (segmentData.vote_status !== 'on') {
			disableVote();
			app.count.clearCount();
		} else {
			app.btnAction.removeClass('disable');
			var display = document.getElementById('display'),
				container = document.getElementById('alert');
			if (container) {
				display.removeChild(container);
			}
		}
		// スピーカー交代
		if (app.currentVoteTarget !== segmentData.vote_target) {
			app.currentVoteTarget = segmentData.vote_target;
			if (!app.isInitial) {
				app.count.clearCount();
			} else {
				app.isInitial = false;
			}
			updateSpeaker();
		}
	});
};

var tick = function() {
	app.stage.update();
};

var initStage = function() {
	var size = app.device.getStageSize(),
		offsets = [13,34],
		borderTickness = 3,
		display = document.getElementById('display');
	app.stage = new cjs.Stage('vote-canvas');
	app.stage.canvas.height = window.innerWidth < 768 ? display.clientHeight - 30 : size.height / 2;
	app.stage.canvas.width = size.width - ((offsets[0]*2+borderTickness)*2);
	app.stage.canvas.style.height = app.stage.canvas.height + 'px';
	app.stage.canvas.style.width = app.stage.canvas.width + 'px';
};

var disableVote = function() {
	addMessage('しばらくおまちください');
	app.btnAction.addClass('disable');
};

var addMessage = function(msg) {
	var text_node = document.createTextNode(msg);
	var display = document.getElementById('display');
	var container = document.createElement('div');
	container.id = 'alert';
	container.className = 'alert';
	var msgDOM = document.createElement('p');
	msgDOM.id = 'alert-message';
	msgDOM.appendChild(text_node);
	container.appendChild(msgDOM);
	display.appendChild(container);
};


var handleUpdateSpeaker = function(evemt) {
	var sp = app.speakers[app.currentVoteTarget];
	app.queue.removeEventListener('load', handleUpdateSpeaker);
	if (!app.speaker) {
		app.speaker = new Speaker({img: app.queue.getResult('speaker'), name: sp.name});
	} else {
		app.speaker.updateSpeaker(app.queue.getResult('speaker'), sp.name);
	}
	app.info.updateInfo(sp.title);

	// if (app.speakerCount < app.speakers.length - 1) {
	// 	app.speakerCount ++;
	// } else {
	// 	app.speakerCount = 0;
	// }
};

var updateSpeaker = function() {
	var filename = app.speakers[app.currentVoteTarget].src;
	var baseURL = './assets/images/speakers/';
	var manifest = [
		{ id: 'speaker', src: baseURL + filename }
	];
	app.queue.addEventListener('complete', handleUpdateSpeaker);
	app.queue.loadManifest(manifest, true);
};

var initLoad = function(canvasId) {
	// init Tick
	cjs.Ticker.setFPS(24);
	cjs.Ticker.addEventListener('tick', tick);

	if (cjs.Touch.isSupported()) {
		cjs.Touch.enable(app.stage);
	}

	// init speakers
	app.request = new XMLHttpRequest;
	app.request.open('GET', './assets/javascripts/data/speakers.json', true);
	app.request.onload = function() {
		if (app.request.status >= 200 && app.request.status < 400) {
			var data = JSON.parse(app.request.response);
			app.speakers = data.speakers;
			// updateSpeaker();
		} else {
			console.log('error: speakers data');
		}
	};
	app.request.send();

	// init device
	app.device = new Device();
	app.ratio = app.device.getRatio();

	// load assets
	var manifest = [
		{ id: 'soundVote', src: './assets/b_071.mp3' }
	];
	app.queue = new cjs.LoadQueue(true);
	app.queue.installPlugin(cjs.Sound);
	app.queue.addEventListener('complete', handleInitialLoadComplete);
	app.queue.loadManifest(manifest, true);

	// init click event
	app.clickEventName = Modernizr.touch ? 'touchstart' : 'click';

	initStage();

	// for Debug
	// initDebug();
};


window.addEventListener('load', function(event) {
	window.removeEventListener(event.type, arguments.callee);
	initLoad('vote-canvas');
}, false);

// for Debug
function initDebug() {
	var btnChangeSpeaker = document.getElementById('debug-change-speaker');
	btnChangeSpeaker.addEventListener(app.clickEventName, function(e) {
		app.count.clearCount();
		updateSpeaker();
	});
	// var btnDisable = document.getElementById('debug-disable-vote');
	// btnDisable.addEventListener(app.clickEventName, function(e) {
	// 	disableVote();
	// });
	var btnMessage = document.getElementById('debug-send-message');
	btnMessage.addEventListener(app.clickEventName, function(e) {
		app.info.updateInfo('ボタンを押してスピーカーを応援しよう！')
	});
}