module tools.generic_tile_dispatcher;

import common.alpha_tiles;
import std.stdio;

/**
 * Generic tile dispatcher using template metaprogramming approach from intoverloadset.d
 * This module provides reusable functions for runtime dispatch of tile evaluation
 */

// Runtime dispatch function to evaluate tiles using template metaprogramming approach
bool evalTileRuntime(int tileId, float x, float y) {
    label: switch(tileId) {
        static foreach(int I; 0 .. maxtiles) {  // Use maxtiles from common.alpha_tiles
            case I: return tile!I(x, y);
        }
        default: return false; // Default for any tile beyond our defined range
    }
}

// Generic function to evaluate any tile at given coordinates
bool evaluateTile(int tileId, float x, float y) {
    return evalTileRuntime(tileId, x, y);
}

// Template to get tile count automatically (not used directly in switch but demonstrates the pattern)
template getTileCount(int acc = 0) {
    static if (!__traits(compiles, tile!(acc)(0.0f, 0.0f))) {
        enum getTileCount = acc;
    } else {
        enum getTileCount = getTileCount!(acc + 1);
    }
}