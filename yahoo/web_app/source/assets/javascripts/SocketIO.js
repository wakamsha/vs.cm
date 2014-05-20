var Socket = (function() {
	var _httpRequest, _s, _pooledCount, _isMeasuring, _interval, _url, isConnected;
	// Constructor
	function Socket(args) {
		initialize.call(this, args);
	}
	// private
	function initialize(args) {
		_url = args.url;
		_isConnected = false;
		_pooledCount = 0;
		_isMeasuring = false;
		_interval = args.interval;
		_httpRequest = new XMLHttpRequest();
		_httpRequest.open('GET', _url, true);
		_httpRequest.send();
		_httpRequest.onreadystatechange = resultHandler;
	}
	function resultHandler(e) {
		if ((e.currentTarget.readyState == 4) && (e.currentTarget.status == 200)) {
			if (!_httpRequest.responseText) return;
			if (_isConnected) return;
			connectTo.call(this, _httpRequest.responseText);
		} else if ((e.currentTarget.readyState == 4) && (e.currentTarget.status == 0)) {
			_httpRequest.abort();
			if (_isConnected) return;
			setTimeout(function() {
				_httpRequest.open('GET', _url, true);
				_httpRequest.send();
				console.log('host接続再試行1');

			}, 300);
		}
	}
	function myRetry() {
		_s = null;
		setTimeout(function() {
			_httpRequest.open('GET', _url, true);
			_httpRequest.send();
			console.log('host接続再試行2');
		}, 300);
	}
	function connectTo(hostname) {
		if (_s && _s.socket.connected) return;
		_s = io.connect('ws://' + hostname, {
		    "reconnect":false,
            "auto connect":false,
            "connect timeout":5000
		});
		_s.redoTransports = true;
		_s.socket.redoTransports = true;

		_s.on('segment', function (data) {
			info.updateInfo(data.info);

			votes.updateTotalVotes(data.votes);
			if (data.vote_status == void 0) return;
			votes.updateVoteStatus(data.vote_status);
			if (data.vote_status == 'init') clearCount();
		});
		_s.on('connecting', function() {
			console.log('接続中・・・');
		});
		_s.on('connect', function() {
			_s.emit('join', {room: 'segment'});
			_isConnected = true;
			console.log('接続');
		});
		//
        _s.on('disconnect', function() {
            _s.removeAllListeners();
            _isConnected = false;
            console.log('切断');
            myRetry.call(this);
        });
        _s.on('error', function (data) {
            _s.removeAllListeners();
            _isConnected = false;
            console.log('エラー');
            myRetry.call(this);
        });
        _s.socket.connect();
	}
	function emit() {
		if( _s == null ){
			return;
		}
		_isMeasuring = true;
		setTimeout(function() {
			if (navigator.onLine) {
				_s.emit('vote',{room: 'segment', count: _pooledCount, tm: new Date() / 1000 });
				_pooledCount = 0;
			}
			_isMeasuring = false;
		}, _interval + 200 + (Math.random()*300)>>0);
	}
	// public
	function vote(value) {
		_pooledCount += value;
		 if(_isMeasuring) return;
		 emit.call(this);
	}
	Socket.prototype = {
		constructor: Socket,
		vote: vote
	};
	return Socket;
})();