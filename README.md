# Iced CoffeeScript test
(C) Copyright 2012 by Javier Arevalo

## Summary

Little game-engine-graphics-thing in Iced CoffeeScript, to help me learn this language.
Also my first attempt at pushing stuff to github, so if you run into this repo, please bear with me

## The code

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