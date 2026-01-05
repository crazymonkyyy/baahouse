# Plan for a Baahouse Image Editor
## Data-Oriented Design Approach

## Executive Summary
This plan outlines the development of a specialized image editor for the baahouse format, focusing on data-oriented design principles to ensure efficiency and performance. The editor will enable users to create, modify, and manipulate images using the unique tile-based approach of the baahouse format while adhering to the documented data structure and file format.

## Project Scope & Data-Oriented Design

### Core Data Structure (baaimage)
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
This structure will be the foundation of the editor's architecture, with performance-critical operations optimized around this data layout.

### Core Features
1. **Canvas Management** - Create, open, save, and~~export~~ baahouse images using the defined baaimage struct
2. **Tile Palette** - Visual interface for selecting and previewing available tiles (0-249 + 5 user-defined)
3. **Drawing Tools** - Brush, ~~eraser~~, ~~fill~~, selection tools optimized for tile-grid editing
~~4. **Grid Editing** - Edit at the tile level with various brush sizes~~ 1 tile always
5. **Preview System** - Real-time preview of the image ~~at various resolutions~~ only the editable canvas
~~6. **Layer System** - Support for multiple layers of tile-based content (each using baaimage struct)~~

### Advanced Features
~~1. **Animation Support** - Create and edit sequences of baahouse images~~
~~2. **Transformation Tools** - Rotate, scale, flip at tile level~~
3. **Color Management** - Define and manage color palettes for the maxcolors=2 constraint
~~4. **Pattern Library** - Save and reuse custom tile arrangements~~
~~5. **Import/Export** - Convert to/from other formats (PPM, PNG, etc.)~~

## Technical Architecture with Data-Oriented Design

### Backend Components - Optimized for Data Layout
- **Core Image Data Structure** - Direct implementation of baaimage struct with cache-friendly operations
~~- **Tile Rendering Engine** - Vectorized rendering of tile functions for performance~~
- **File I/O System** - Efficient binary serialization conforming to the spec: `baa\n` + [encoding] + [width height length] + [binary blob]
-~~ **Undo/Redo System** - Structured around baaimage snapshots for minimal allocation~~

### Data-Oriented Design Principles Applied:
~~- **Structure of Arrays (SoA)** - Where beneficial, separate tile data by components for SIMD processing~~
~~- **Cache-Friendly Layouts** - Optimize memory access patterns for tile operations~~
~~- **Batch Processing** - Group operations on multiple tiles to maximize cache use~~
- **Minimize Indirection** - Direct access to tile grid data where possible

### Frontend/UI Components
- **Canvas Area** - Main area for image editing with ~~zoom/pan~~, backed by the baaimage data structure
- **Tile Palette** - Visual grid of available tiles with previews
- **Toolbar** - Access to drawing tools and utilities
- **Properties Panel** - Adjust brush size, colors, etc.
~~- **Layers Panel** - Manage multiple layers (each as baaimage struct)~~

## Implementation Plan with Data Focus


### Main Window Layout
```
┌─────────────────────────────────────┐
│ Menu Bar                           │
├─────────┬───────────────────────────┤
│ Tile    │                           │
│ Palette │          Canvas           │
│         │    (baaimage data)        │
├─────────┼───────────────────────────┤
│ Layers  │  Properties / Tools       │
│         │    (Data panels)          │
└─────────┴───────────────────────────┘
```

### Data-Driven Components:
- **Canvas**: Directly backed by baaimage.tiles array with optimized access
- **Properties**: Reflect current selection in baaimage data


### Canvas Features
- Grid-based editing aligned with baaimage tile grid (width x height)
- Grid overlay showing the underlying baaimage structure // togglable
- Tile boundary visibility option for better data visualization

## Key Functionality with Data Optimization

### Drawing Operations
- **Direct Data Manipulation**: All tools directly modify the baaimage.tiles array

### Tile Management
- Direct integration with the 250 defined tiles (0-249) + 5 user slots (250-254)
- Efficient preview generation using vectorized tile function evaluation
~~- Searchable tile database with metadata from the actual tile functions~~ tabbed

### Image Operations
- **Size Operations**: Resize maintains baaimage structure integrity //important expand, will need a datstructure
- **Crop/Transform**: Operations that preserve the tile-based format
- **Color Swapping**: Respect the maxcolors=2 constraint in the baaimage struct

## Technical Considerations


## File Format Integration

### Native Support
- Native read/write using the exact format: `baa\n` + [encoding] + [width height length] + [binary blob]
- Preserve tile functions for lossless editing
- Support ua16 encoding (uncompressed alpha-set, 16 colors, 256 tiles max, 2 colors per tile)

### Data Structure Mapping
- Each file maps directly to baaimage struct
- Binary blob directly represents the tiles array
- Maintain format integrity during all operations

## Quality Assurance

### Testing Strategy
- Unit tests for baaimage struct operations
- Performance benchmarks for data manipulation
- Format compliance verification
- Data integrity testing during editing operations

## Potential Challenges

1. **Performance with Large Grids** - Optimizing baaimage operations for large images
2. **Memory Management** - Efficient use of memory for the tile grid data structure

4. **Data Consistency** - Maintaining the baaimage struct integrity during editing


