#!/usr/bin/env opend run
/**
 * Baahouse to SVG converter
 * Converts baahouse images to SVG format to demonstrate vector representation
 */

import std.stdio;
import std.conv;
import std.file;
import std.string;
import std.array;
import baahouse_serializer;
import common.alpha_tiles;

/**
 * Convert a single tile to SVG path data
 */
string tileToSVGPath(int tileNum, float x, float y, float width, float height) {
    // Generate a path that approximates the tile function
    string pathData = "";
    
    // Create a fine grid to sample the tile function
    int gridSize = 16; // Adjust for accuracy/detail
    float cellWidth = width / gridSize;
    float cellHeight = height / gridSize;
    
    for (int row = 0; row < gridSize; row++) {
        for (int col = 0; col < gridSize; col++) {
            float xf = x + col * cellWidth;
            float yf = y + row * cellHeight;
            
            // Evaluate the tile function at the grid point
            bool result = evalTile(tileNum, xf, yf);
            
            if (result) {
                // Create a small rectangle for each "true" cell
                pathData ~= format("M%f,%f h%f v%f h-%f z ", xf, yf, cellWidth, cellHeight, cellWidth);
            }
        }
    }
    
    return pathData;
}

// Runtime dispatch function for tile evaluation
bool evalTile(int tileId, float x, float y) {
    label: switch(tileId) {
        static foreach(int I; 0 .. 250) {  // Use all defined tiles (250 tiles: 0-249)
            case I: return tile!I(x, y);
        }
        default: return false;
    }
}

/**
 * Convert baahouse image to SVG
 */
void baahouseToSVG(baaimage img, string svgFilename, int tileSize = 100) {
    auto file = File(svgFilename, "w");
    
    // Calculate SVG dimensions
    int svgWidth = img.width * tileSize;
    int svgHeight = img.height * tileSize;
    
    // Write SVG header
    file.writeln("<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"", svgWidth, "\" height=\"", svgHeight, "\" viewBox=\"0 0 ", svgWidth, " ", svgHeight, "\">");
    
    // Process each tile
    for (int y = 0; y < img.height; y++) {
        for (int x = 0; x < img.width; x++) {
            // Get the tile info for this position
            int tileIdx = y * img.width + x;
            auto tileInfo = img.tiles[tileIdx];
            tilenum tileNum = tileInfo[2];
            color color1 = tileInfo[0];  // First color (fill when function returns true)
            color color2 = tileInfo[1];  // Second color (fill when function returns false)
            
            // Calculate position of this tile in the SVG
            float tileX = x * tileSize;
            float tileY = y * tileSize;
            
            // Create background for the entire tile (for the false areas)
            file.writeln("  <!-- Tile ", tileIdx, ": color2 background -->");
            file.writeln(format("  <rect x=\"%f\" y=\"%f\" width=\"%d\" height=\"%d\" fill=\"#%02x%02x%02x\" />",
                tileX, tileY, tileSize, tileSize, color2, color2, color2));
                
            // Create paths for areas where the tile function evaluates to true
            file.writeln("  <!-- Tile ", tileIdx, ": color1 path shapes -->");
            
            // For better SVG representation, use a finer sampling to create more accurate paths
            string tilePath = tileToSVGPath(tileNum, tileX, tileY, tileSize, tileSize);
            
            if (tilePath.length > 0) {
                file.writeln(format("  <path d=\"%s\" fill=\"#%02x%02x%02x\" />", 
                    tilePath.strip(), color1, color1, color1));
            }
        }
    }
    
    file.writeln("</svg>");
    file.close();
    
    writeln("Converted baahouse image to SVG: ", svgFilename);
    writeln("  Dimensions: ", svgWidth, "x", svgHeight);
    writeln("  Tile size: ", tileSize, " pixels");
    writeln("  Total tiles: ", img.width * img.height);
}

int main(string[] args) {
    if (args.length < 2) {
        writeln("Usage: ", args[0], " <input..Sheep.House> [output.svg] [tile_size]");
        writeln("  input..Sheep.House: input baahouse file");
        writeln("  output.svg: output SVG file (default: converted_image.svg)");
        writeln("  tile_size: size of each tile in pixels (default: 100)");
        return 1;
    }
    
    string inputFile = args[1];
    string outputFile = (args.length > 2) ? args[2] : "converted_image.svg";
    int tileSize = (args.length > 3) ? to!int(args[3]) : 100;
    
    if (tileSize <= 0) {
        writeln("Error: tile size must be positive");
        return 1;
    }
    
    // Load the baahouse image
    baaimage img = deserializeBaaImage(inputFile);
    writeln("Loaded baahouse image:");
    writeln("  Format: ", img.format);
    writeln("  Size: ", img.width, "x", img.height);
    writeln("  Tiles: ", img.tiles.length);
    
    // Convert to SVG
    baahouseToSVG(img, outputFile, tileSize);
    
    return 0;
}