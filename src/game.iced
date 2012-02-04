# Iced CoffeeScript test
# (C) Copyright 2012 by Javier Arevalo

globalLayer = 0
minSize = 1

class Blob extends Go
	constructor: ->
		super
		@reset()

	reset: ->
		@maxlife = RandomFloatRange 0.1, 0.8
		@radius = minSize*RandomFloatRange 0.01, 0.10
		@color = RandomColor(0, 255, 0.2)
		@pos = new Vec2 RandomInt(canvas.width), RandomInt(canvas.height)

	tick: (t) ->
		super
		@radius++
		if @life >= @maxlife
			@kill()

	born: ->
		@layer = globalLayer++
		super

	die: ->
		super
		@container.creatego new Blob

	render: (ctx) ->
		ctx.beginPath()
		ctx.arc @pos.x, @pos.y, @radius, 0, Math.PI*2, true
		ctx.fillStyle = @color
		ctx.fill()

uicontainer = null
canvas = null
ctx = null

blobs = new GoContainer

rebuildCanvas = () ->
	canvas.width = uicontainer.width() #window.document.body.clientWidth
	canvas.height = uicontainer.height() #window.document.body.clientHeight
	minSize = Math.min(canvas.width, canvas.height)
	blobs.xform = (new Mat2).translate(canvas.width/2, canvas.height/2).scale(0.5, 0.5)
	return

lastTime = 0
tick = () ->
	# uicontainer.css "background", RandomColor 10, 30
	timeNow = Date.now()
	elapsed = (timeNow - lastTime)*0.001
	if elapsed > 0
		if lastTime != 0
			# Cap max elapsed time to 1 second to avoid death spiral
			if elapsed > 1 then elapsed = 1
			blobs.tick elapsed
			blobs.xform = blobs.xform.rotate elapsed*0.8
			blobs.render ctx
		lastTime = timeNow

	requestAnimationFrame tick
	return

$ () ->
	LOG "Starting up"
	uicontainer = $ "#uicontainer"
	uicontainer.css "background", MakeColor 0,0,0 #255, 0, 255
	canvas = document.createElement "canvas"
	$(canvas).addClass "fullscreen"
	uicontainer.append(canvas)
	ctx = canvas.getContext "2d"

	$(document).bind "touchmove", (e) -> e.preventDefault()
	$(window).resize rebuildCanvas
	$(document).bind "orientationChanged", (e) -> rebuildCanvas()
	rebuildCanvas()

	# blobs.xform = (new Mat2).translate(200, 200).scale(0.2, 0.2).rotate(2)

	for i in [0...20]
		blobs.creatego new Blob
	tick()
	return
