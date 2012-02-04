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
