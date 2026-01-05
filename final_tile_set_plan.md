# Final Tile Set Plan for Baahouse Project

## Executive Summary
This plan outlines the organization of 250 tiles (0-249) with 5 blank slots reserved for user-defined tiles (250-254). The plan addresses redundancy issues identified in testing and organizes tiles by functional classification.

## Current State Analysis
- **Total defined tiles**: 250 (0-249)
- **Redundant tile groups identified**: Multiple groups of identical patterns
- **Available slots**: 250-255 (but we'll only use 250-254 for user tiles, keeping 255 as a future expansion slot)

## Plan for Addressing Redundant Tiles
Based on the uniqueness test results, several tile groups are redundant. The plan is to:
1. Remove redundant tiles from the official set
2. Keep only one representative from each redundant group
3. Replace the removed tiles with new, unique patterns

### Redundant Tile Groups:
1. **Group 1**: 23 and 158 → Keep 23, replace 158 with new pattern
2. **Group 2**: 29 and 189 → Keep 29, replace 189 with new pattern
3. **Group 3**: 40, 147, 186 → Keep 40, replace 147 and 186 with new patterns
4. **Group 4**: 51, 61, 118, 127, 159, 213, 220, 227, 242 → Keep 51, replace 8 tiles with new patterns
5. **Group 5**: 53 and 157 → Keep 53, replace 157 with new pattern
6. **Group 6**: 150 and 164 → Keep 150, replace 164 with new pattern
7. **Group 7**: 154, 169, 182 → Keep 154, replace 169 and 182 with new patterns
8. **Group 8**: 168 and 194 → Keep 168, replace 194 with new pattern
9. **Group 9**: 192 and 197 → Keep 192, replace 197 with new pattern
10. **Group 10**: 221, 229, 239 → Keep 221, replace 229 and 239 with new patterns

**Result**: 20 redundant tiles to be replaced with new unique patterns

## Final Tile Classification Plan

### 0-49: Basic and Geometric Patterns (Essential Core Set)
**Tiles 0-49**: Retain core geometric patterns with some replacements for redundancy
- **0-19**: Fundamental geometric shapes (lines, triangles, quadrants, crosshairs)
- **20-29**: Basic geometric patterns (stripes, bands, diagonals)
- **30-39**: Circular and radial patterns (circles, rings, ellipses)
- **40-49**: Complex geometric patterns and early examples (saddles, diamonds, etc.)

### 50-99: Complex Geometric and Mathematical Patterns
**Tiles 50-99**: More complex geometric patterns and mathematical functions
- **50-59**: Card suit and symbolic patterns
- **60-69**: Ring and frame patterns
- **70-79**: Cross, plus, and L-shape patterns
- **80-89**: Compound geometric patterns
- **90-99**: Grid and pattern combinations

### 100-149: Wave and Trigonometric Patterns
**Tiles 100-149**: Waveforms, trigonometric functions, and oscillating patterns
- **100-109**: Cross and intersection patterns
- **110-119**: Wave and interference patterns
- **120-129**: Grid and modular patterns
- **130-139**: Wave and wave intersection patterns
- **140-149**: Elliptical and complex trigonometric patterns

### 150-199: Advanced Patterns and Combinations
**Tiles 150-199**: More complex combinations and advanced geometric patterns
- **150-159**: Multi-element patterns (multiple shapes combined)
- **160-169**: Wave and pattern interferences
- **170-179**: Frame and border patterns
- **180-189**: Modulo and grid-based patterns
- **190-199**: Complex intersection and exclusion patterns

### 200-249: Experimental and Advanced Mathematical Functions
**Tiles 200-249**: Complex and experimental mathematical functions
- **200-209**: Advanced trigonometric and transcendental functions
- **210-219**: Complex exclusion and intersection patterns
- **220-229**: Complex pattern combinations
- **230-239**: Complex geometric arrangements
- **240-249**: Advanced pattern combinations (final tiles)

### 250-254: User-Defined Tiles (5 slots reserved)
**Tiles 250-254**: Completely open for user-defined tile functions
- Reserved for custom tile definitions by users
- Same format requirements as standard tiles
- Allows for extension without modifying core library

## Implementation Strategy
1. **Phase 1**: Update alpha_tiles.d to remove redundant tiles and add new unique patterns
2. **Phase 2**: Update the enum maxtiles to 255 (for 256 total possible tiles) 
3. **Phase 3**: Ensure all tools work correctly with the new arrangement
4. **Phase 4**: Create a mechanism for users to define tiles 250-254

## Technical Implementation Notes
- All tiles must follow the specified format: `output tile(int i:INDEX)(float x,float y)=>CONDITION;`
- Coordinate system remains (0,0) top-left to (1,1) bottom-right
- Output type remains `bool` for current alpha tiles
- `maxtiles` should be updated to 255 to accommodate user tiles

## Expected Impact
- **Redundancy Eliminated**: All redundant tiles will be replaced with unique patterns
- **Enhanced Diversity**: The tile set will have greater diversity and utility
- **User Extensibility**: 5 slots for user-defined tiles enable customization
- **Maintained Compatibility**: All existing functionality preserved