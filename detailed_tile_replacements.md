# Detailed Final Tile Set Plan
## Replacement Patterns for Redundant Tiles

This document details specific replacement patterns for the redundant tiles identified in testing.

## Redundant Tile Replacements

### Group 1: Replace tile 158 (redundant with tile 23)
**Tile 23**: `abs(x-0.5)<0.1 && abs(y-0.5)<0.1` (center square)
**Replacement for 158**: `abs(x-0.5)<0.15 || abs(y-0.5)<0.15` (cross shape)

### Group 2: Replace tile 189 (redundant with tile 29) 
**Tile 29**: `abs(x-0.5)<0.05 && abs(y-0.5)<0.05` (small center square)
**Replacement for 189**: `abs(x-0.5)+abs(y-0.5)<0.05` (small center diamond)

### Group 3: Replace tiles 147 and 186 (redundant with tile 40)
**Tile 40**: `abs(x-0.5)+abs(y-0.5)<0.3` (diamond shape)
**Replacement for 147**: `abs(x-0.5)*abs(y-0.5)<0.05` (center area with exclusion)
**Replacement for 186**: `(x-0.5)*(x-0.5)+(y-0.5)*(y-0.5)<0.1 && abs(x-0.5)+abs(y-0.5)>0.15` (ring with diamond exclusion)

### Group 4: Replace 8 tiles from the large redundant group (51, 61, 118, 127, 159, 213, 220, 227, 242)
Keep tile 51: `((x-0.5)*(y-0.5)<0.1)` (saddle shape)
**Replacements**:
- **61**: `abs(x-0.5)<0.2 && abs(y-0.5)>0.3 || abs(y-0.5)<0.2 && abs(x-0.5)>0.3` (outer cross)
- **118**: `abs(tan(PI*x)*tan(PI*y))<0.5` (tangent grid pattern)
- **127**: `abs(x-0.5)+abs(y-0.5)<0.25 && abs(x-0.5)+abs(y-0.5)>0.15` (diamond ring)
- **159**: `abs((x-0.5)*4)<1.0 && abs((y-0.5)*4)<1.0 && !(abs((x-0.5)*4)<0.5 && abs((y-0.5)*4)<0.5)` (square ring with proportion)
- **213**: `abs(cos(PI*2*x)*sin(PI*2*y))<0.3` (trigonometric pattern)
- **220**: `abs(x-0.5)<0.25 && abs(y-0.5)<0.25 && abs(x-0.5)>0.1 && abs(y-0.5)>0.1 && abs((x-0.5)-(y-0.5))>0.15` (square frame with diagonal exclusion)
- **227**: `(abs(x-0.5)>0.15 && abs(y-0.5)<0.1) || (abs(y-0.5)>0.15 && abs(x-0.5)<0.1)` (offset cross)
- **242**: `abs(x-0.5)<0.25 && abs(y-0.5)<0.25 && abs(abs(x-0.5)-0.1)<0.03 && abs(abs(y-0.5)-0.1)<0.03` (inner grid pattern)

### Group 5: Replace tile 157 (redundant with tile 53)
**Tile 53**: `abs(x-0.5)<0.15 && abs(y-0.5)<0.15 && !(abs(x-0.5)<0.05 && abs(y-0.5)<0.05)` (square with center hole)
**Replacement for 157**: `abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && !(abs(x-0.5)<0.1 && abs(y-0.5)<0.1) && !(abs(x-0.5)<0.15 && abs(y-0.5)<0.05) && !(abs(x-0.5)<0.05 && abs(y-0.5)<0.15)` (square frame with cross exclusions)

### Group 6: Replace tile 164 (redundant with tile 150)
**Tile 150**: `(abs(x-0.25)+abs(y-0.25)<0.15) || (abs(x-0.75)+abs(y-0.75)<0.15) || (abs(x-0.25)+abs(y-0.75)<0.15) || (abs(x-0.75)+abs(y-0.25)<0.15)` (all four diamonds)
**Replacement for 164**: `abs(abs(4*(x-0.5))%1 - 0.5)<0.2 && abs(abs(4*(y-0.5))%1 - 0.5)<0.2` (modular square grid)

### Group 7: Replace tiles 169 and 182 (redundant with tile 154)
**Tile 154**: `abs(x-0.5)<0.25 && abs(y-0.5)<0.25 && (abs(x-0.5)>0.15 || abs(y-0.5)>0.15)` (square with center cross excluded)
**Replacement for 169**: `abs(x-0.5)<0.2 && abs(y-0.5)<0.2 && !(abs(x-0.5)<0.1 && abs(y-0.5)<0.1) && !(abs(x-0.5)<0.05 && abs(y-0.5)<0.05)` (double square frame)
**Replacement for 182**: `(abs(x-0.5)<0.15 && abs(y-0.5)<0.15 || abs(x-0.5)>0.25 && abs(y-0.5)>0.25) && !(abs(x-0.5)<0.05 && abs(y-0.5)<0.05)` (dual square with center exclusion)

### Group 8: Replace tile 194 (redundant with tile 168)
**Tile 168**: `abs((x-0.5)*2)<0.4 && abs((y-0.5)*2)<0.4 && (abs((x-0.5)*2)<0.2 && abs((y-0.5)*2)<0.2)` (concentric squares)
**Replacement for 194**: `abs((x-0.5)*(y-0.5)*((x-0.5)+(y-0.5))*((x-0.5)-(y-0.5)))<0.01` (complex center pattern)

### Group 9: Replace tile 197 (redundant with tile 192)
**Tile 192**: `abs(x-0.5)<0.3 && abs(y-0.5)<0.3 && abs(x-0.5)-abs(y-0.5)<0.1 && abs(y-0.5)-abs(x-0.5)<0.1` (square rotated 45 degrees inside square)
**Replacement for 197**: `(abs(x-y)<0.1 && abs(x-0.5)<0.2 && abs(y-0.5)<0.2) || (abs(x+y-1.0)<0.1 && abs(x-0.5)<0.2 && abs(y-0.5)<0.2)` (center diagonals)

### Group 10: Replace tiles 229 and 239 (redundant with tile 221)
**Tile 221**: `abs(x-0.5)<0.1 && abs(y-0.5)>0.4 || abs(y-0.5)<0.1 && abs(x-0.5)>0.4` (outer cross)
**Replacement for 229**: `abs(x-0.5)<0.05 && abs(y-0.5)<0.35 && abs(y-0.5)>0.15 || abs(y-0.5)<0.05 && abs(x-0.5)<0.35 && abs(x-0.5)>0.15` (extended cross with exclusions)
**Replacement for 239**: `abs(x-0.5)<0.05 && abs(y-0.5)>0.15 && abs(y-0.5)<0.35 || abs(y-0.5)<0.05 && abs(x-0.5)>0.15 && abs(x-0.5)<0.35` (inner cross extension)

## User-Defined Slots (Tiles 250-254)
These 5 slots (250-254) are left completely open for users to define custom tiles that meet the requirements:
- Must follow the format: `output tile(int i:N)(float x,float y)=>CONDITION;`
- Must have output type bool
- Must use coordinates x, y in the range [0,1]
- Must return a boolean value

## Summary
- **Redundant tiles to replace**: 20
- **New unique patterns to add**: 20
- **User-defined slots**: 5 (250-254)
- **Total tiles**: 250 original - 20 redundant + 20 new + 5 user = 255 tiles
- **Max tiles value**: Will be set to 255 to accommodate all slots