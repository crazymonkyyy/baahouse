#!/usr/bin/env opend run
import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.math;
import common.alpha_tiles;
import tools.tile_name_utils;

/**
 * Enhanced tile renderer with name annotation
 * Output format: PPM (Portable Pixmap) with tile name in header comment
 */

// Runtime dispatch function to evaluate tiles using template metaprogramming approach
bool evalTileRuntime(int tileId, float x, float y) {
    label: switch(tileId) {
        static foreach(int I; 0 .. 100) {  // Using first 100 tiles
            case I: return tile!I(x, y);
        }
        default: return false; // Default for any tile beyond our defined range
    }
}

int main(string[] args) {
    if (args.length < 2) {
        writeln("Usage: ", args[0], " <tile_number> [output_file.ppm]");
        writeln("Renders a single tile as 128x128 bitmap to PPM format with name annotation");
        writeln("If no output file is specified, defaults to tile_<number>.ppm");
        return 1;
    }
    
    int tileNum = to!int(args[1]);
    if (tileNum < 0 || tileNum >= 100) { // Using 100 as our limit
        writeln("Error: Tile number must be between 0 and 99");
        return 1;
    }
    
    string outputFile = "tile_" ~ args[1] ~ ".ppm";
    if (args.length >= 3) {
        outputFile = args[2];
    }
    
    // Initialize image parameters
    const int width = 128;
    const int height = 128;
    
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
    
    // Write the PPM file with extended comment containing the tile name
    File file = File(outputFile, "wb");
    file.write("P6\n");
    file.write("# Tile name: " ~ getTileName(tileNum) ~ "\n");
    file.write(to!string(width) ~ " " ~ to!string(height) ~ "\n");
    file.write("255\n");
    file.rawWrite(imageData);
    file.close();
    
    writeln("Tile ", tileNum, " (", getTileName(tileNum), ") rendered to ", outputFile);
    return 0;
}