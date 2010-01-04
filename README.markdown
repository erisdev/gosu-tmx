# README
## WHAT IS THIS

Eventually, a usable TMX map loader that works with Gosu and doesn't care 
whether you're using Chingu or some home-grown game engine of your own
devising.

### WHY ON EARTH

I like Chingu and a TMX loader already exists for it, but it's just not the
right tool for what I want to do. Hopefully others will find this useful as
well. :)

### WHAT IS MISSING

Pretty much everything useful. So far, map data is loaded and layers, object
groups and tile sets are created. What's missing is a way to actually retrieve
tiles by gid and draw the map.

The obvious (and probably fast) way would be to load all the tiles into a
single array once the tile sets are loaded. This would make it somewhat more
difficult to switch tiles or tile sets on the fly, which is something I'd like
to be able to do eventually. Any ideas?

Help is welcome, obviously.

## INSTALL

Don't do it yet. The API is so unstable it does not have a half life but a
quarter life.

### PREREQUISITES

* ruby >= 1.9.1 (probably)
* nokogiri
* gosu

## LICENSE

This software is available under the terms of the MIT license for no better
reason than that this is the license of Gosu itself. This means that you are
technically allowed to use my hard work as part of your proprietary,
commercial product with no obligation to give anything back but credit where
it's due. Use your discretion on that one.

The full license is reproduced here for posterity:

> Copyright © 2009–2010 Eris
> 
> Permission is hereby granted, free of charge, to any person
> obtaining a copy of this software and associated documentation
> files (the "Software"), to deal in the Software without
> restriction, including without limitation the rights to use,
> copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the
> Software is furnished to do so, subject to the following
> conditions:
> 
> The above copyright notice and this permission notice shall be
> included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
> WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> OTHER DEALINGS IN THE SOFTWARE.

## AUTHORS

* Eris <eris.discord@gmail.com>
* your name here!

## SEE ALSO

* [Gosu][], a 2D game development library for Ruby and C++
* [Chingu][], a higher level game library built on top of Gosu
* [Chipmunk][], a 2D rigid body physics engine in C
* [chipmunk-ffi][], more up-to-date Ruby bindings for Chipmunk
* [Tiled][], a flexible tile map editor and the origin of the TMX format (I
  think).

[chingu]: http://github.com/ippa/chingu
[chipmunk]: http://code.google.com/p/chipmunk-physics
[chipmunk-ffi]: http://github.com/shawn42/chipmunk-ffi
[gosu]: http://libgosu.org
[tiled]: http://mapeditor.org/
