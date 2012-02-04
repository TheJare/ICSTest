
# Simple hierarchical GameObject management classes
# Not terribly efficient since it uses full scans of the gameobject arrays for some operations
# Go is a single entity / GameObject
# GoContainer is a Go that can contain other Gos
# GoContainer may have a Mat2 transform property 'xform' to perform hierarchical transformations

class Go
	constructor: () ->
		@life = 0
		@alive = true
		@idx = null
		@layer = 0
		@container = null
		@xform = new Mat2
		return

	tick: (t) ->
		@life += t
		return

	born: ->
		@container.addToLayer @layer
		return

	die: ->
		@container.removeFromLayer @layer
		return

	render: ->
		return

	changeLayer: (newLayer) ->
		if newLayer != @layer
			@container.addToLayer newLayer
			@container.removeFromLayer @layer
			@layer = layer
		return

	kill: ->
		@container.killgo this
		return

class GoContainer extends Go
	constructor: ->
		super
		@gos = []
		@newgos = []
		@deadgos = false
		@layers = {}

	# Adding and removing Gos
	creatego: (go) ->
		@newgos.push(go)
		go.container = this
		return

	killgo: (go) ->
		if go.alive
			go.alive = false
			@deadgos = true
		return

	# Managing the layers that contain Gos
	removeFromLayer: (layer) ->
		@layers[layer]--
		if not @layers[layer]
			delete @layers[layer]
		return

	addToLayer: (layer) ->
		@layers[layer] = ((@layers[layer] or 0) + 1)
		return

	# Standard Go interfaces
	tick: (t) ->
		super

		# process existing entities
		for go, i in @gos
			go.tick t

		# process newly created entities
		# Multiple passes while new entities have been created in a previous pass
		while @newgos.length > 0
			lastnewgos = @newgos
			@newgos = []
			n = @gos.length
			for go, i in lastnewgos
				go.idx = @gos.length
				@gos.push(go)
				go.born()
				go.tick t
				@addToLayer go.layer

		# process dead entities
		# Multiple passes while new entities have been killed in a previous pass
		while @deadgos
			@deadgos = false
			dead = []
			# Should optimize this to not traverse the entire @gos array
			for go,i in @gos
				if not go.alive
					go.die()
					@removeFromLayer go.layer
					dead.push(i)
				else
					go.idx -= dead.length

			# dead indices are ordered lower to higher
			# so as we remove from the array
			for idx,i in dead
				v = idx-i
				@gos.splice v,1
		return

	die: ->
		super
		for go in @gos
			go.die()
		# @newgos are not born yet so we don't call die for them

	render: (ctx) ->
		# Compose our transform with the ctx's current one
		# Monkeypatched the Canvas Context2D to contain an xform property
		if @xform?
			m = ctx.xform
			(if m? then m.mult(@xform) else @xform).apply ctx

		# Call contained gos in ascending order of layer they are in
		layers = (parseInt(k) for k,v of @layers)
		layers.sort()
		for k in layers
			# Should optimize this to not traverse the entire @gos array
			for go in @gos
				if go.layer is k
					go.render ctx

		# Restore the context's previous xform
		if @xform?
			if m?
				m.apply ctx
			else
				delete ctx.xform
				ctx.setTransform(1,0,0,1,0,0)
		return
