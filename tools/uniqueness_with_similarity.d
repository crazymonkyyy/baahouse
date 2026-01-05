#!/usr/bin/env opend run
import std.stdio;
import std.file;
import std.string;
import std.array;
import std.conv;
import std.algorithm;
import std.math;
import common.alpha_tiles;
import tools.tile_name_utils;

/**
 * Uniqueness checker for baahouse tiles with similarity analysis
 * Identifies most similar tile for each tile
 */

// Runtime dispatch function to evaluate tiles using template metaprogramming approach
bool evalTileRuntime(int tileId, float x, float y) {
    label: switch(tileId) {
        static foreach(int I; 0 .. 100) {  // Use actual number of tiles we have defined
            case I: return tile!I(x, y);
        }
        default: return false; // Default for any tile beyond our defined range
    }
}

int main(string[] args) {
    int resolution = 128; // Use 128x128 grid for accurate similarity checking (as per project requirements)

    if (args.length >= 2) {
        resolution = to!int(args[1]);
    }

    writeln("Checking similarity of tiles at ", resolution, "x", resolution, " resolution...");
    
    // Arrays to store the patterns of each tile
    bool[][][] tilePatterns;
    tilePatterns.length = maxtiles;  // Use maxtiles from common.alpha_tiles
    
    // Generate patterns for each tile
    for (int i = 0; i < maxtiles; i++) {
        tilePatterns[i].length = resolution;
        for (int y = 0; y < resolution; y++) {
            tilePatterns[i][y].length = resolution;
            for (int x = 0; x < resolution; x++) {
                float xf = cast(float)x / (resolution - 1);
                float yf = cast(float)y / (resolution - 1);
                tilePatterns[i][y][x] = evalTileRuntime(i, xf, yf);
            }
        }
    }
    
    // For each tile, find the most similar tile
    for (int i = 0; i < maxtiles; i++) {
        int mostSimilarIndex = -1;
        int minDifferences = int.max;

        for (int j = 0; j < maxtiles; j++) {
            if (i == j) continue; // Skip self comparison
            
            int differences = 0;
            for (int y = 0; y < resolution; y++) {
                for (int x = 0; x < resolution; x++) {
                    if (tilePatterns[i][y][x] != tilePatterns[j][y][x]) {
                        differences++;
                    }
                }
            }
            
            if (differences < minDifferences) {
                minDifferences = differences;
                mostSimilarIndex = j;
            }
        }
        
        if (mostSimilarIndex != -1) {
            writeln("Tile ", i, " (", getTileName(i), ") is most similar to Tile ", mostSimilarIndex, " (", getTileName(mostSimilarIndex), ") with ", minDifferences, " differences at ", resolution, "x", resolution, " resolution");
        }
    }
    
    return 0;
}