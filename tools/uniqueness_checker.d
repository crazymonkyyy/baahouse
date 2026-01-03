#!/usr/bin/env opend run
import std.stdio;
import std.file;
import std.array;
import std.algorithm;
import std.math;
import std.conv;
import common.alpha_tiles;

/**
 * Uniqueness checker for baahouse tiles
 * Identifies redundant or duplicate tiles by comparing their outputs
 */

// Runtime dispatch function to evaluate tiles (same as in tile_to_bitmap)
bool evalTile(int tileId, float x, float y) {
    switch(tileId) {
        case 0: return tile!(0)(x, y);
        case 1: return tile!(1)(x, y);
        case 2: return tile!(2)(x, y);
        case 3: return tile!(3)(x, y);
        case 4: return tile!(4)(x, y);
        case 5: return tile!(5)(x, y);
        case 6: return tile!(6)(x, y);
        case 7: return tile!(7)(x, y);
        case 8: return tile!(8)(x, y);
        case 9: return tile!(9)(x, y);
        case 10: return tile!(10)(x, y);
        case 11: return tile!(11)(x, y);
        case 12: return tile!(12)(x, y);
        case 13: return tile!(13)(x, y);
        case 14: return tile!(14)(x, y);
        case 15: return tile!(15)(x, y);
        case 16: return tile!(16)(x, y);
        case 17: return tile!(17)(x, y);
        case 18: return tile!(18)(x, y);
        case 19: return tile!(19)(x, y);
        case 20: return tile!(20)(x, y);
        case 21: return tile!(21)(x, y);
        case 22: return tile!(22)(x, y);
        case 23: return tile!(23)(x, y);
        case 24: return tile!(24)(x, y);
        case 25: return tile!(25)(x, y);
        case 26: return tile!(26)(x, y);
        case 27: return tile!(27)(x, y);
        case 28: return tile!(28)(x, y);
        case 29: return tile!(29)(x, y);
        case 30: return tile!(30)(x, y);
        case 31: return tile!(31)(x, y);
        case 32: return tile!(32)(x, y);
        case 33: return tile!(33)(x, y);
        case 34: return tile!(34)(x, y);
        case 35: return tile!(35)(x, y);
        case 36: return tile!(36)(x, y);
        case 37: return tile!(37)(x, y);
        case 38: return tile!(38)(x, y);
        case 39: return tile!(39)(x, y);
        case 40: return tile!(40)(x, y);
        case 41: return tile!(41)(x, y);
        case 42: return tile!(42)(x, y);
        case 43: return tile!(43)(x, y);
        case 44: return tile!(44)(x, y);
        case 45: return tile!(45)(x, y);
        case 46: return tile!(46)(x, y);
        case 47: return tile!(47)(x, y);
        case 48: return tile!(48)(x, y);
        case 49: return tile!(49)(x, y);
        default: return false; // Default for any tile beyond our defined range
    }
}

int main(string[] args) {
    int resolution = 32; // Use a 32x32 grid for checking uniqueness (can be adjusted for precision vs speed)
    
    if (args.length >= 2) {
        resolution = to!int(args[1]);
    }
    
    writeln("Checking uniqueness of tiles at ", resolution, "x", resolution, " resolution...");
    
    // Arrays to store the patterns of each tile
    bool[][][] tilePatterns;
    tilePatterns.length = maxtiles;  // Assuming maxtiles is 256
    
    // Generate patterns for each tile in our defined range (0-49 for now)
    for (int i = 0; i < 50; i++) {
        tilePatterns[i].length = resolution;
        for (int y = 0; y < resolution; y++) {
            tilePatterns[i][y].length = resolution;
            for (int x = 0; x < resolution; x++) {
                float xf = cast(float)x / (resolution - 1);
                float yf = cast(float)y / (resolution - 1);
                tilePatterns[i][y][x] = evalTile(i, xf, yf);
            }
        }
    }
    
    // Compare each tile to every other tile to find duplicates
    bool foundRedundancy = false;
    for (int i = 0; i < 50; i++) {
        for (int j = i + 1; j < 50; j++) {
            bool identical = true;
            for (int y = 0; y < resolution && identical; y++) {
                for (int x = 0; x < resolution && identical; x++) {
                    if (tilePatterns[i][y][x] != tilePatterns[j][y][x]) {
                        identical = false;
                    }
                }
            }
            
            if (identical) {
                writeln("Redundant tiles found: ", i, " and ", j);
                foundRedundancy = true;
            }
        }
    }
    
    if (!foundRedundancy) {
        writeln("No redundant tiles found among the first 50 tiles at ", resolution, "x", resolution, " resolution!");
    }
    
    return foundRedundancy ? 1 : 0;
}