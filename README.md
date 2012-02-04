# Iced CoffeeScript test
(C) Copyright 2012 by Javier Arevalo

## Summary

Little game-engine-graphics-thing in Iced CoffeeScript, to help me learn this language.
Iced CoffeeScript is a variant of CoffeeScript that adds callback/async primitives to the language. See http://maxtaco.github.com/coffee-script/ for more details.

This is also my first attempt at pushing stuff to github, so if you run into this repo, please bear with me.

## The code

### utils.iced
Bunch of common utility functions

### vec2.iced
A simple 2D vector & matrix library

### jengine.iced
A simple GameObject library.
Create a GoContainer, add Go instances to it, call tick(seconds) and render(context)
Subclass Go to create your own gameobjects.

### game.iced
Not really a game at the moment, just a small graphics experiment with colored rotating circles.

### index.html
The page that contains the canvas and runs the code.
It uses jQuery, probably for not a lot - I just include it by default everywhere.

### build
Script to build the compiled, merged and uglified game.min.js from the .iced sources
Note that uses 'ics' as the command to invoke the Iced CoffeeScript compiler, and 'uglify' for the minification.
You can find and install both uglify and iced-coffee-script as node packages using nodejs' npm.
