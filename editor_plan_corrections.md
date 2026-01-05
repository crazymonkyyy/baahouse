# Key Documentation Insights for Image Editor Plan

## Important Specifications to Consider

### File Format (from SPEC.md)
- Files start with `baa\n` (exactly 4 bytes)
- Next line: extension and encoding scheme
- Next line: width, height, and binary blob length
- Then: binary blob data
- For `ua16` encoding: tiles defined by 2 bytes, 4 bits for color 1, 4 bits for color 2, 8 bits for the tile

### Data Structure (from PROJECT.md and QWEN.md)
- baaimage struct with format, width, height, and tiles array
- maxcolors=2 (2 colors per tile maximum)
- tilenum=ubyte (tile numbers as unsigned bytes)
- Tile coordinates: (0,0) is top-left, (1,1) is bottom-right

### Tile System
- All tiles must define `alias output=bool;` (may become float for lerping in future)
- `enum maxtiles=256;` defines the function set (though only 250 tiles currently defined)
- Tiles use overload set pattern with integer specialization
- Import tiles using `import common.alpha_tiles;`, never duplicate tile code elsewhere

### Implementation Requirements
- Every file should start with `#!opend run` or similar command
- Use tabs for indentation
- Small, focused executables rather than monolithic code
- Focus on correctness before performance