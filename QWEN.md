# QWEN.md - Baahouse Project Context

## Project Overview

Baahouse is a hybrid vector-bitmap image format project that uses a grid of "tiles" where each tile is an enumerated list of functions that fit a square space. The tiles are mathematical functions that define patterns within each square, with finite colors for each tile. For example, a simple tile could be defined as `(x,y)=>x>y` with two colors.

### Key Characteristics:
- **File Extensions**: `.🐑 🏠` (primary) and `.baahouse` (legacy)
- **Format**: Plain text header followed by binary data, similar to PPM format
- **Signature**: Every file starts with `baa\n`
- **Primary Language**: D (indicated by `.d` file extensions and D syntax in documentation)

### File Format Structure:
1. First 4 bytes: `baa\n`
2. Extension and encoding scheme line
3. Width, height, and binary blob length information
4. Binary blob data

### Supported Encoding Schemes:
- `ua16`: Uncompressed alpha-set with 16 colors (256 tiles, max 2 colors per tile)
- Future: `c` for compression, `t` for text overlays

## Architecture & Directory Structure

```
baahouse/
├── common/          # Core tile definitions, spec-related libraries
├── tools/           # Reference tools, correctness verification tools
├── ai thoughts/     # AI planning documents and generated documentation
├── website/         # Project website and promotional materials
├── renders/         # Rendered output files and examples
└── data/            # Test files and sample data
```

### Key Components:
- **common/alpha_tiles.d**: Primary tile definitions using overload sets with integer template specialization
- **Tile definition pattern**: Must follow template with `alias output=bool;` and `enum maxtiles=256;`
- **Core data structure**: `baaimage` struct for storing format data

## Development Conventions

### Code Style:
- Every file should start with `#!opend run` or similar command
- Use tabs for indentation (not spaces)
- Naming: Dumb simple naming for clarity over speed
- Multiple small executables rather than monolithic code

### Tile Definition Requirements:
1. All tiles must define `alias output=bool;` (may be float in future for lerping)
2. Must include `enum maxtiles=256;` to define function set
3. Tiles follow overload set pattern with integer specialization
4. Coordinate system: (0,0) is top-left, (1,1) is bottom-right
5. Import tiles using `import common.alpha_tiles;`, never duplicate tile code elsewhere

### Core Data Structure (`baaimage`):
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

## Development Tools & Workflow

### Planned Tools:
1. **Single tile renderer**: Renders 128x128 bitmap of a single tile
2. **Render inverter**: Swaps white and black colors
3. **Diff check**: Compares two images for differences (% different, first different pixel)
4. **Uniqueness check**: Identifies redundant tiles
5. **Robustness check**: Tests tile functions with edge cases (2.0, NaN, etc.)
6. **Tile file linter**: Validates tile file syntax

### Implementation Approach:
- Step-by-step tile set definition
- Focus on correctness before performance
- Small, focused executables for each function

## Building and Running

The project uses the D programming language with OpenD. Based on the project's emphasis on simple executables and the file structure requirements, building likely involves:

```bash
# Using OpenD compiler (as indicated by the #!opend run requirement)
opend run <file>.d

# For compiling individual tools
opend build <tool_file>.d

# Alternative standard D compiler
dmd <file>.d
```

The documentation specifically mentions that every file should start with `#!opend run` or similar command, suggesting a scripting approach where individual D files can be executed directly. For development, you would work with individual tool files in the `tools/` directory and common library files in the `common/` directory.

## Testing

The project emphasizes correctness with various verification tools planned:
- Robustness checking with edge values
- Uniqueness checking to avoid redundant tiles
- Diff checking for image comparison

## Special Considerations

1. **Tile Function Pattern**: Never break the established pattern for tile definitions in `common/alpha_tiles.d`
2. **Coordinate System**: Always maintain (0,0) as top-left, (1,1) as bottom-right
3. **Extensibility**: The design allows for future tile sets with different output types (bool → float → struct)
4. **No Duplicated Code**: Always import tiles rather than duplicating function definitions elsewhere

This project represents an innovative approach to image storage that combines vector-like functions with bitmap tiling, offering both compression potential and mathematical precision in image representation.