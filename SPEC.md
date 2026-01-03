### baahouse

A hybrid vector bitmap image format. A grid of "tiles"; the tile themselves are a emuerated list of functions that fit a square, with finite colors for each tile; for example consider `(x,y)=>x>y` and two colors.

files have the file extension of 
 1. `.🐑 🏠` (emoji: "sheep" "house building", both part of 2010 emoji)
 2. `.baahouse` (for legacy systems, not 

Files start with plain text then binary like ppm

The first 4 bytes of every baahouse image is `baa\n`

The next line is a extension and encoding scheme line.

The next line is width and height and binary blob length.(maybe changed by extensions)

after the last endline is the binary blob.

### encoding

The first encoding is `ua16`; the u is for uncompressed, a for alpha-set of tiles, 16 for (unknown to the file)base16 colors

No compression is attempted for `u`, `c` should be used for the first attempted compression

`a` will be the most basic set of 256 tiles, 2 color max

`16` will not define a pallet

For this encoding tiles with be defined by 2 bytes, 4 bits for color 1, 4 bits for color 2, 8 bits for the tile. 

Binary blob length SHOULD match width x height.

reserved for future use: 

	* `t` for text overlays
	* `c` for a compression scheme
	* `256` for a defined pallet of 256 colors

 
