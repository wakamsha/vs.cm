class window.Particle
	_bmpSprite = {}
	# constructor
	constructor: (args)->
		_sprite = new createjs.SpriteSheet args.data
		_bmpSprite = new createjs.Sprite _sprite

	# public
	addParticles: (count, x, y, speed)->
		for i in [1..count]
			particle = _bmpSprite.clone()
			
			particle.x = x
			particle.y = y
			particle.alpha = Math.random() * 0.5 + 0.5
			particle.scaleX = particle.scaleY = Math.random() + 0.3

			a = Math.PI * 2 * Math.random()
			v = (Math.random() - 0.5) * 30 * speed
			particle.vX = Math.cos(a) * v
			particle.vY = Math.sin(a) * v
			particle.vS = (Math.random() - 0.5) * 0.2	# scale
			particle.vA = Math.random() * 0.5 - 0.01	# alpha

			particle.gotoAndPlay(Math.random() * particle.spriteSheet.getNumFrames()|0)
			app.stage.addChild(particle)
