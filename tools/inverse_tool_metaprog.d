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
 * Uses template metaprogramming approach from intoverloadset.d
 * Tests tile robustness by feeding extreme values and inverting patterns
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
    writeln("  (0.0, 0.0): ", evalTileRuntime(tileNum, 0.0, 0.0));
    writeln("  (1.0, 1.0): ", evalTileRuntime(tileNum, 1.0, 1.0));
    writeln("  (0.0, 1.0): ", evalTileRuntime(tileNum, 0.0, 1.0));
    writeln("  (1.0, 0.0): ", evalTileRuntime(tileNum, 1.0, 0.0));
    writeln("  (0.5, 0.5): ", evalTileRuntime(tileNum, 0.5, 0.5));
    
    // Test values outside the [0,1] range (robustness test)
    writeln("Testing outside range values (robustness):");
    writeln("  (2.0, 2.0): ", evalTileRuntime(tileNum, 2.0, 2.0));
    writeln("  (-1.0, -1.0): ", evalTileRuntime(tileNum, -1.0, -1.0));
    writeln("  (10.0, 0.5): ", evalTileRuntime(tileNum, 10.0, 0.5));
    writeln("  (0.5, -5.0): ", evalTileRuntime(tileNum, 0.5, -5.0));
    
    // Test with NaN and infinity if available (will require special handling)
    writeln("Testing with special values:");
    float inf = 1.0 / 0.0;  // infinity
    float nan = 0.0 / 0.0;  // NaN
    
    writeln("  (inf, inf): ", evalTileRuntime(tileNum, inf, inf));
    writeln("  (nan, 0.5): ", evalTileRuntime(tileNum, nan, 0.5));
    
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
            bool originalResult = evalTileRuntime(tileNum, xf, yf);
            
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