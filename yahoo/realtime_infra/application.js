var room_status = {
	tm: new Date().getTime(),
	rooms: {
		vote0:  0,
		vote1:  0,
		vote2:  0,
		vote3:  0,
		vote4:  0,
		vote5:  0,
		vote6:  0,
		vote7:  0,
		vote8:  0,
		vote9:  0,
		vote10: 0,
		vote11: 0,
		vote12: 0,
		vote13: 0,
		vote14: 0
	}
};
var renderAdmin = function(res) {
	var template = fs.readFileSync(__dirname + '/views/admin.ejs', 'utf-8');
	var data = ejs.render(template, {
		roomsLength: 15
	});
	res.writeHead(200, {'Content-Type': 'text/html'});
	res.write(data);
	res.end();
};
var requestHandler = function(req, res) {
	switch (req.url) {
		case '/room_status':
			var data = JSON.stringify(room_status.rooms);
			res.writeHead(200, {
				'Content-Type': 'application/json',
				'Access-Control-Allow-Origin' : '*',
				'Pragma': 'no-cache',
				'Cache-Control' : 'no-cache'
			});
			res.end(data);
			break;
		case '/hostname':
			var url = settings.host + ':' + settings.port;
			res.writeHead(200, {
				'Content-Type': 'text/html',
				'Access-Control-Allow-Origin' : '*',
				'Pragma': 'no-cache',
				'Cache-Control' : 'no-cache'
			});
			res.end(url);
			break;
		case '/admin':
			renderAdmin(res);
			break;
		default:
			res.writeHead(404, {
				'Content-Type': 'text/pain'
			});
			res.write('404 Not Found\n');
			res.end();
	}
};

// modules
var http = require('http').createServer(requestHandler),
	io = require('socket.io').listen(http),
	qs = require('querystring'),
	fs = require('fs'),
	ejs = require('ejs'),
	jq = require('jquery'),
	settings = require('./settings');

// 
// init
// 
io.sockets.on('connection', function(socket) {
	socket.emit('segment', {
		vote_target: 'vote0',
		vote_status: 'on',
	});
	socket.on('vote', function(data) {
		room_status.tm = data.tm;
		room_status.rooms[data.room] += data.count * 1;
	});
	socket.on('status.change', function(data) {
		if (data.vote_status === 'init') {
			for (var i=0; i<15; i++) {
				room_status.rooms['vote' + i] = 0;
			}
		}
		io.sockets.emit('segment', {
			vote_target: data.vote_target,
			vote_status: data.vote_status,
		});
	});
	setInterval(function() {
		socket.emit('vote.update', room_status);
	}, 5000);
});

http.listen(settings.port, settings.host);
console.log('http server listening: ' + settings.host + ':' + settings.port);
