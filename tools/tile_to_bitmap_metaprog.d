#!/usr/bin/env opend run
import std.stdio;
import std.conv;
import std.math;
import std.file;
import common.alpha_tiles;  // Import the tile definitions

/**
 * Renders a single tile as a bitmap file
 * Output format: PPM (Portable Pixmap)
 * Uses proper template metaprogramming approach from intoverloadset.d
 */

template getTileCount(int acc = 0) {
    static if (!__traits(compiles, tile!(acc)(0.0f, 0.0f))) {
        enum getTileCount = acc;
    } else {
        enum getTileCount = getTileCount!(acc + 1);
    }
}

// Runtime dispatch function to evaluate tiles using the template metaprogramming approach
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
        writeln("Usage: ", args[0], " <tile_number> [output_file.ppm]");
        writeln("Renders a single tile as 128x128 bitmap to PPM format");
        writeln("If no output file is specified, defaults to tile_<number>.ppm");
        return 1;
    }
    
    int tileNum = to!int(args[1]);
    if (tileNum < 0 || tileNum >= maxtiles) {
        writeln("Error: Tile number must be between 0 and ", maxtiles-1);
        return 1;
    }
    
    string outputFile = "tile_" ~ args[1] ~ ".ppm";
    if (args.length >= 3) {
        outputFile = args[2];
    }
    
    // Initialize image parameters
    const int width = 128;
    const int height = 128;
    
    // Create PPM header
    string ppmHeader = "P6\n" ~ to!string(width) ~ " " ~ to!string(height) ~ "\n255\n";
    
    // Prepare image data (RGB format, 3 bytes per pixel)
    ubyte[] imageData;
    imageData.length = width * height * 3;  // 3 bytes per pixel (RGB)
    
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            float xf = cast(float)x / (width - 1);  // Normalize to 0-1
            float yf = cast(float)y / (height - 1); // Normalize to 0-1
            
            // Get the tile output (true/false) using runtime dispatch
            bool result = evalTileRuntime(tileNum, xf, yf);
            
            // Define colors: white (255,255,255) for true, black (0,0,0) for false
            ubyte r = result ? 255 : 0;
            ubyte g = result ? 255 : 0;
            ubyte b = result ? 255 : 0;
            
            // Calculate pixel index in the image data array
            size_t pixelIdx = (y * width + x) * 3;
            imageData[pixelIdx] = r;      // Red
            imageData[pixelIdx + 1] = g;  // Green
            imageData[pixelIdx + 2] = b;  // Blue
        }
    }
    
    // Write the PPM file
    File file = File(outputFile, "wb");
    file.write("P6\n");
    file.write(to!string(width) ~ " " ~ to!string(height) ~ "\n");
    file.write("255\n");
    file.rawWrite(imageData);
    file.close();
    
    writeln("Tile ", tileNum, " rendered to ", outputFile);
    return 0;
}