# Misc utils

LOG = (a) -> console.log(if typeof a is "object" then JSON.stringify a else a); return
MakeColor = (r,g,b,a) -> "rgba("+Math.floor(Clamp r, 0, 255) + "," + Math.floor(Clamp g, 0, 255)+","+Math.floor(Clamp b, 0, 255)+","+(if a? then a else "255") + ")"

Pow2 = (v) -> v*v
Lerp = (a,b,t) -> a+(b-a)*t
Clamp = (v,a,b) -> if v<a then a else if v>b then b else v
Wrap = (v,a,b) -> if v<a then (v+(b-a)) else if v>b then (v-(b-a)) else v
RandomInt = (v) -> Math.floor Math.random()*v
RandomIntRange = (a,b) -> Math.floor Math.random()*(b-a)+a
RandomFloat = (v) -> Math.random()*v
RandomFloatRange = (a,b) -> Math.random()*(b-a)+a
RandomColor = (min, max, a) -> min ||= 0; max ||= 255; MakeColor RandomIntRange(min, max), RandomIntRange(min, max), RandomIntRange(min, max), a

window.requestAnimationFrame ||= 
    window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    window.oRequestAnimationFrame ||
    window.msRequestAnimationFrame ||
    (callback, element) ->
        window.setTimeout callback, 1000 / 60

globalLayer = 0

class Blob extends Go
	constructor: ->
		super
		@reset()

	reset: ->
		@maxlife = RandomFloatRange 0.1, 0.8
		@radius = RandomIntRange 5, 50
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
	blobs.xform = (new Mat2).translate(canvas.width/2, canvas.height/2).scale(0.5, 0.5)
	return

tick = () ->
	# uicontainer.css "background", RandomColor 10, 30
	blobs.tick 1/60
	blobs.render(ctx)
	requestAnimationFrame tick
	blobs.xform = blobs.xform.rotate(0.01)
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
