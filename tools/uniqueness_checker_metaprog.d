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
 * Uses template metaprogramming approach from intoverloadset.d
 * Identifies redundant or duplicate tiles by comparing their outputs
 */

// Runtime dispatch function to evaluate tiles using template metaprogramming approach
bool evalTileRuntime(int tileId, float x, float y) {
    label: switch(tileId) {
        static foreach(int I; 0 .. 50) {  // Use actual number of tiles we have defined
            case I: return tile!I(x, y);
        }
        default: return false; // Default for any tile beyond our defined range
    }
}

int main(string[] args) {
    int resolution = 32; // Use a 32x32 grid for checking uniqueness (can be adjusted for precision vs speed)
    
    if (args.length >= 2) {
        resolution = to!int(args[1]);
    }
    
    writeln("Checking uniqueness of tiles at ", resolution, "x", resolution, " resolution...");
    
    // Arrays to store the patterns of each tile in our defined range
    bool[][][] tilePatterns;
    tilePatterns.length = maxtiles;  // Using maxtiles from common.alpha_tiles
    
    // Generate patterns for each tile in our defined range
    for (int i = 0; i < maxtiles && i < 50; i++) {  // Only check first 50 for now
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
    
    // Compare each tile to every other tile to find duplicates
    bool foundRedundancy = false;
    for (int i = 0; i < maxtiles && i < 50; i++) {
        for (int j = i + 1; j < maxtiles && j < 50; j++) {
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