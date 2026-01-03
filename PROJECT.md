### layout

the majority of code in this project should be opend, raylib and odc; see ~/src/baahouse-backup for an old attempt

folders:

* common - define spec related libs, such as the tiles 
* tools - reference tools or tools for proving correctness
* ai thoughts - storage for planning docs or ai written docs
* website - propganda website
* renders - storage for renders
* data - test files and other details

### style

every file should start with `#!opend run` or simliar command

tabs

dumb simple naming, coding for high clearity not speed. Several small executables.

### tiles

Given the importance of these functions you MUST follow this layout for how you define tiles

the alpha tiles will be defined in `common/alpha_tiles.d`

tiles will define a `alias output=bool;`, in future tile sets this may a float if lerping is defined or maybe a complex struct for alpha. This line of code is wildly important for upgradablity.

`enum maxtiles=256;` defines the functions in the set

the tiles will be in an overload set with int value template specailization, followed by the tiles name in a comment `output tile(int i:0)(float x,float y)=>true;//blank`

0,0 will be the top left corner, 1,1 the bottom right

Do not break this pattern, edit these tiles one by one. Do not store any extra code here. Never dupicate tile code elsewhere, always import it by `import common.alpha_tiles;`

### data

the main data type should look like this:

```d

alias color=...;
enum maxcolors=2;
alias tilenum=ubyte;

struct baaimage{
	string format;
	int width;
	int height;
	alias tile=Tuple!(color[maxcolors],tilenum);
	tile[] tiles;
}
```

### tools

the end goal of the project is a basic image editor and a renderer that can be of arbitery size

To get there, defining a good tile set should be defined step by step:

Single tile renderer, makes a 128x128 white/black bitmap of a single tile

render inverter, swaps white and black

diff check, given two images report details, % different, first different pixel, anything else

uiqueness check, iterate thru the tiles looking for redunency

robustness check, feed 2.0, nans and other values to the tile functions

tile file linter
