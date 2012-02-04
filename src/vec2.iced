# Quick & dirty 2D vector / matrix functions
# Operations return new values, do not change the instance

# 2D Vector
class @Vec2
	constructor: (x, y) -> @x = x || 0; @y = y || 0
	@FromAngLen: (a, l) -> new Vec2 l*Math.cos(a), l*Math.sin(a)
	clone:	() -> new Vec2 @x, @y
	add:	(o) -> new Vec2 @x + o.x, @y + o.y
	sub:	(o) -> new Vec2 @x - o.x, @y - o.y
	dot:	(o) -> @x*o.x + @y*o.y
	len2:	() -> @x*@x + @y*@y
	len:	() -> Math.sqrt @x*@x + @y*@y
	ang:	() -> Math.atan @y, @x
	norm:	() -> l = @len(); if l > 0.0001 then new Vec2 @x/l, @y/l else new Vec2 1, 0
	scale:	(f) -> new Vec2 @x*f, @y*f
	clamp:	(l) -> tl = @len(); if tl < l then @clone(); else k = l/tl; new Vec2 @x*k, @y*k
	perp:	() -> new Vec2 -@y, @x
	rot:	(a) -> c = Math.cos a; s = Math.sin a; new Vec2 @x*c - @y*s, @y*c + @x*s

# 2D Matrix compatible with the canvas Context2D
# Inspired by https://github.com/simonsarris/Canvas-tutorials/blob/master/transform.js
class @Mat2
	constructor: (a) ->
		@m = a or [1, 0, 0, 1, 0, 0]

	mult: (m) ->
		r11 = @m[0]*m.m[0] + @m[2]*m.m[1]
		r12 = @m[1]*m.m[0] + @m[3]*m.m[1]
		r21 = @m[0]*m.m[2] + @m[2]*m.m[3]
		r22 = @m[1]*m.m[2] + @m[3]*m.m[3]
		x   = @m[0]*m.m[4] + @m[2]*m.m[5] + @m[4]
		y   = @m[1]*m.m[4] + @m[3]*m.m[5] + @m[5]
		new Mat2([r11, r12, r21, r22, x, y])

	det: ->
		1 / (@m[0] * @m[3] - @m[1] * @m[2])

	invert: ->
		d = @det()
		r11 =  @m[3] * d
		r12 = -@m[1] * d
		r21 = -@m[2] * d
		r22 =  @m[0] * d
		x = d * (@m[2] * @m[5] - @m[3] * @m[4])
		y = d * (@m[1] * @m[4] - @m[0] * @m[5])
		new Mat2([r11, r12, r21, r22, x, y])

	rotate: (a) ->
		c = Math.cos a
		s = Math.sin a
		r11 = @m[0] *  c + @m[2] * s
		r12 = @m[1] *  c + @m[3] * s
		r21 = @m[0] * -s + @m[2] * c
		r22 = @m[1] * -s + @m[3] * c
		new Mat2([r11, r12, r21, r22, @m[4], @m[5]])

	translate: (x,y) ->
		nx = @m[4] + @m[0]*x + @m[2]*y
		ny = @m[5] + @m[1]*x + @m[3]*y
		new Mat2([@m[0], @m[1], @m[2], @m[3], nx, ny])

	scale: (x,y) ->
		new Mat2([@m[0]*x, @m[1]*x, @m[2]*y, @m[3]*y, @m[4], @m[5]])

	transform: (xorv,y) ->
		if y?
			new Vec2(xorv*@m[0] + y*@m[2] + @m[4])
		else
			new Vec2(xorv.x*@m[0] + xorv.y*@m[2] + @m[4])

	apply: (ctx) ->
		ctx.setTransform(@m[0], @m[1], @m[2], @m[3], @m[4], @m[5])
		# Monkeypatched the Canvas Context2D to contain an xform property
		ctx.xform = this
		return
