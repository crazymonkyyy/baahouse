#!/usr/bin/env opend run
import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.math;
import std.algorithm;
import common.alpha_tiles;
import tools.tile_name_utils;

/**
 * Tile renderer with text overlay
 * Creates PPM files with text label rendered directly on the image
 */

// Simple 5x7 pixel font for numbers and basic characters
ubyte[5][7] getCharPixels(char c) {
    ubyte[5][7] charPixels = void;  // Initialize as all zeros (black)
    
    switch(c) {
        case '0':
            charPixels = [
                [0,1,1,1,0],
                [1,0,0,0,1],
                [1,0,0,0,1],
                [1,0,0,0,1],
                [1,0,0,0,1],
                [1,0,0,0,1],
                [0,1,1,1,0]
            ];
            break;
        case '1':
            charPixels = [
                [0,0,1,0,0],
                [0,1,1,0,0],
                [0,0,1,0,0],
                [0,0,1,0,0],
                [0,0,1,0,0],
                [0,0,1,0,0],
                [0,1,1,1,0]
            ];
            break;
        case '2':
            charPixels = [
                [0,1,1,1,0],
                [1,0,0,0,1],
                [0,0,0,0,1],
                [0,0,0,1,0],
                [0,0,1,0,0],
                [0,1,0,0,0],
                [1,1,1,1,1]
            ];
            break;
        case '3':
            charPixels = [
                [0,1,1,1,0],
                [1,0,0,0,1],
                [0,0,0,0,1],
                [0,0,1,1,0],
                [0,0,0,0,1],
                [1,0,0,0,1],
                [0,1,1,1,0]
            ];
            break;
        case '4':
            charPixels = [
                [0,0,0,1,0],
                [0,0,1,1,0],
                [0,1,0,1,0],
                [1,0,0,1,0],
                [1,1,1,1,1],
                [0,0,0,1,0],
                [0,0,0,1,0]
            ];
            break;
        case '5':
            charPixels = [
                [1,1,1,1,1],
                [1,0,0,0,0],
                [1,1,1,1,0],
                [0,0,0,0,1],
                [0,0,0,0,1],
                [1,0,0,0,1],
                [0,1,1,1,0]
            ];
            break;
        case '6':
            charPixels = [
                [0,1,1,1,0],
                [1,0,0,0,0],
                [1,0,0,0,0],
                [1,1,1,1,0],
                [1,0,0,0,1],
                [1,0,0,0,1],
                [0,1,1,1,0]
            ];
            break;
        case '7':
            charPixels = [
                [1,1,1,1,1],
                [0,0,0,0,1],
                [0,0,0,1,0],
                [0,0,1,0,0],
                [0,1,0,0,0],
                [0,1,0,0,0],
                [0,1,0,0,0]
            ];
            break;
        case '8':
            charPixels = [
                [0,1,1,1,0],
                [1,0,0,0,1],
                [1,0,0,0,1],
                [0,1,1,1,0],
                [1,0,0,0,1],
                [1,0,0,0,1],
                [0,1,1,1,0]
            ];
            break;
        case '9':
            charPixels = [
                [0,1,1,1,0],
                [1,0,0,0,1],
                [1,0,0,0,1],
                [0,1,1,1,1],
                [0,0,0,0,1],
                [0,0,0,0,1],
                [0,1,1,1,0]
            ];
            break;
        case ' ':
            // Space character - all black pixels
            break;  // Leave as all zeros
        default:
            // For any other character, return all black (empty)
            break;
    }
    
    return charPixels;
}

// Draw a character onto the image at position (x, y)
void drawChar(ref ubyte[] imageData, int imgWidth, int charX, int charY, char c) {
    auto charPixels = getCharPixels(c);
    
    for (int row = 0; row < 7; row++) {
        for (int col = 0; col < 5; col++) {
            int px = charX + col;
            int py = charY + row;
            
            if (px < imgWidth && py < 128 && charPixels[row][col] == 1) {
                size_t pixelIdx = (py * imgWidth + px) * 3;
                // Set pixel to white (255,255,255) for character
                imageData[pixelIdx] = 255;     // Red
                imageData[pixelIdx + 1] = 255; // Green
                imageData[pixelIdx + 2] = 255; // Blue
            }
        }
    }
}

// Draw text string onto the image
void drawText(ref ubyte[] imageData, int imgWidth, int x, int y, string text) {
    int currentX = x;
    foreach (c; text) {
        drawChar(imageData, imgWidth, currentX, y, c);
        currentX += 6;  // Add 1 pixel space between characters (5 char width + 1 space)
    }
}

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
        writeln("Usage: ", args[0], " <tile_number> [output_file.ppm]");
        writeln("Renders a single tile as 128x128 bitmap to PPM format with text label on the image");
        writeln("If no output file is specified, defaults to tile_<number>_labeled.ppm");
        return 1;
    }

    int tileNum = to!int(args[1]);
    if (tileNum < 0 || tileNum >= 100) {
        writeln("Error: Tile number must be between 0 and 99");
        return 1;
    }

    string outputFile = "tile_" ~ args[1] ~ "_labeled.ppm";
    if (args.length >= 3) {
        outputFile = args[2];
    }

    // Initialize image parameters - increase height to accommodate label at bottom
    const int width = 128;
    const int tileHeight = 128;
    const int labelHeight = 10;  // Add space for text label
    const int totalHeight = tileHeight + labelHeight;

    // Prepare image data (RGB format, 3 bytes per pixel)
    ubyte[] imageData;
    imageData.length = width * totalHeight * 3;  // 3 bytes per pixel (RGB)

    // First, render the tile in the top portion of the image
    for (int y = 0; y < tileHeight; y++) {
        for (int x = 0; x < width; x++) {
            float xf = cast(float)x / (width - 1);  // Normalize to 0-1
            float yf = cast(float)y / (tileHeight - 1); // Normalize to 0-1 for original tile dimensions

            // Get the tile output (true/false) using runtime dispatch
            bool result = evalTileRuntime(tileNum, xf, yf);

            // Define colors: white (255,255,255) for true, black (0,0,0) for false
            ubyte r = result ? 255 : 0;
            ubyte g = result ? 255 : 0;
            ubyte b = result ? 255 : 0;

            // Calculate pixel index in the image data array (map to top portion)
            size_t pixelIdx = (y * width + x) * 3;
            imageData[pixelIdx] = r;      // Red
            imageData[pixelIdx + 1] = g;  // Green
            imageData[pixelIdx + 2] = b;  // Blue
        }
    }

    // Clear the label area (set to black background)
    for (int y = tileHeight; y < totalHeight; y++) {
        for (int x = 0; x < width; x++) {
            size_t pixelIdx = (y * width + x) * 3;
            imageData[pixelIdx] = 0;       // Red
            imageData[pixelIdx + 1] = 0;   // Green
            imageData[pixelIdx + 2] = 0;   // Blue
        }
    }

    // Add text label to the bottom of the image: Tile number and name
    string tileText = "Tile " ~ to!string(tileNum) ~ ": " ~ getTileName(tileNum)[0..min(25, getTileName(tileNum).length)]; // Truncate long names
    drawText(imageData, width, 2, tileHeight + 1, tileText);  // Position text at bottom with 1 pixel margin

    // Write the PPM file
    File file = File(outputFile, "wb");
    file.write("P6\n");
    file.write(to!string(width) ~ " " ~ to!string(totalHeight) ~ "\n");  // Use totalHeight instead of original height
    file.write("255\n");
    file.rawWrite(imageData);
    file.close();

    writeln("Tile ", tileNum, " with label rendered to ", outputFile);
    return 0;
}