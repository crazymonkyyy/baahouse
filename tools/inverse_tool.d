#!/usr/bin/env opend run
import std.stdio;
import std.file;
import std.array;
import std.regex;
import std.conv;
import std.math;
import common.alpha_tiles;

/**
 * Inverse tool for baahouse tiles
 * Tests tile robustness by feeding extreme values and inverting patterns
 */

// Runtime dispatch function to evaluate tiles (same as in other tools)
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
    if (args.length < 2) {
        writeln("Usage: ", args[0], " <tile_number>");
        writeln("Tests tile robustness by inverting the pattern and checking extreme values");
        return 1;
    }
    
    int tileNum = to!int(args[1]);
    if (tileNum < 0 || tileNum >= maxtiles) {
        writeln("Error: Tile number must be between 0 and ", maxtiles-1);
        return 1;
    }
    
    writeln("Testing robustness of tile ", tileNum);
    
    // Test with extreme values
    writeln("Testing extreme values:");
    writeln("  (0.0, 0.0): ", evalTile(tileNum, 0.0, 0.0));
    writeln("  (1.0, 1.0): ", evalTile(tileNum, 1.0, 1.0));
    writeln("  (0.0, 1.0): ", evalTile(tileNum, 0.0, 1.0));
    writeln("  (1.0, 0.0): ", evalTile(tileNum, 1.0, 0.0));
    writeln("  (0.5, 0.5): ", evalTile(tileNum, 0.5, 0.5));
    
    // Test values outside the [0,1] range (robustness test)
    writeln("Testing outside range values (robustness):");
    writeln("  (2.0, 2.0): ", evalTile(tileNum, 2.0, 2.0));
    writeln("  (-1.0, -1.0): ", evalTile(tileNum, -1.0, -1.0));
    writeln("  (10.0, 0.5): ", evalTile(tileNum, 10.0, 0.5));
    writeln("  (0.5, -5.0): ", evalTile(tileNum, 0.5, -5.0));
    
    // Test with NaN and infinity if available (will require special handling)
    writeln("Testing with special values:");
    float inf = 1.0 / 0.0;  // infinity
    float nan = 0.0 / 0.0;  // NaN
    
    writeln("  (inf, inf): ", evalTile(tileNum, inf, inf));
    writeln("  (nan, 0.5): ", evalTile(tileNum, nan, 0.5));
    
    // Test inverting the pattern (create inverted PPM)
    writeln("Creating inverted version of tile ", tileNum);
    
    const int width = 128;
    const int height = 128;
    
    // Prepare image data for inverted tile
    ubyte[] imageData;
    imageData.length = width * height * 3;  // 3 bytes per pixel (RGB)
    
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            float xf = cast(float)x / (width - 1);  // Normalize to 0-1
            float yf = cast(float)y / (height - 1); // Normalize to 0-1
            
            // Get original tile output
            bool originalResult = evalTile(tileNum, xf, yf);
            
            // Invert the result: true becomes false (black), false becomes true (white)
            bool invertedResult = !originalResult;
            
            // Define colors: white (255,255,255) for true, black (0,0,0) for false
            ubyte r = invertedResult ? 255 : 0;
            ubyte g = invertedResult ? 255 : 0;
            ubyte b = invertedResult ? 255 : 0;
            
            // Calculate pixel index in the image data array
            size_t pixelIdx = (y * width + x) * 3;
            imageData[pixelIdx] = r;      // Red
            imageData[pixelIdx + 1] = g;  // Green
            imageData[pixelIdx + 2] = b;  // Blue
        }
    }
    
    // Write the inverted PPM file
    string outputFile = "renders/tile_" ~ args[1] ~ "_inverted.ppm";
    File file = File(outputFile, "wb");
    file.write("P6\n");
    file.write(to!string(width) ~ " " ~ to!string(height) ~ "\n");
    file.write("255\n");
    file.rawWrite(imageData);
    file.close();
    
    writeln("Inverted tile ", tileNum, " saved to ", outputFile);
    
    return 0;
}