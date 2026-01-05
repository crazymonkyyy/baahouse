#!/usr/bin/env opend run
/**
 * Serializer/Deserializer library for baahouse format
 * Implements the documented file format: `baa\n` + [encoding] + [width height length] + [binary blob]
 */

import std.stdio;
import std.file;
import std.conv;
import std.string;
import std.algorithm;
import std.typecons;

// Core baahouse data structure
alias color = ubyte;
enum maxcolors = 2;
alias tilenum = ubyte;

struct baaimage {
    string format = "ua16";  // Default to uncompressed alpha-set (baahouse format)
    int width;
    int height;
    alias tile = Tuple!(color, color, tilenum);
    tile[] tiles;

    this(int w, int h) {
        width = w;
        height = h;
        tiles.length = w * h;
        // Initialize with default tile (0) and default colors (0, 0)
        foreach (ref t; tiles) {
            t[0] = 0;  // First color
            t[1] = 0;  // Second color
            t[2] = 0;  // Tile number
        }
    }
}

/**
 * Serialize a baaimage to baahouse file format
 */
void serializeBaaImage(baaimage img, string filename) {
    // Open file for binary writing
    auto file = File(filename, "wb");
    
    // Write the signature: `baa\n`
    file.write("baa\n");
    
    // Write encoding scheme
    file.write(img.format ~ "\n");
    
    // Write width, height and binary blob length
    string sizeInfo = to!string(img.width) ~ " " ~ to!string(img.height) ~ " " ~ 
                     to!string(img.tiles.length * 3) ~ "\n";  // 3 bytes per tile (2 colors + 1 tile num)
    file.write(sizeInfo);
    
    // Write the binary blob - each tile is 3 bytes: 2 colors + 1 tile number
    foreach (t; img.tiles) {
        ubyte[3] tileData;
        tileData[0] = t[0];  // First color
        tileData[1] = t[1];  // Second color
        tileData[2] = t[2];  // Tile number
        file.rawWrite(tileData);
    }
    
    file.close();
}

/**
 * Parse a baahouse file and return a baaimage
 */
baaimage deserializeBaaImage(string filename) {
    // Read the entire file as binary
    auto data = cast(ubyte[])read(filename);
    
    size_t pos = 0;
    
    // Check signature: `baa\n` (exactly 4 bytes)
    if (pos + 4 > data.length) {
        throw new Exception("File too short, missing signature");
    }
    
    string sig = cast(string)data[0..4];
    if (sig != "baa\n") {
        throw new Exception("Invalid baahouse signature: " ~ sig);
    }
    pos += 4;
    
    // Find the end of the encoding line
    size_t encodingStart = pos;
    while (pos < data.length && data[pos] != '\n') {
        pos++;
    }
    if (pos >= data.length) {
        throw new Exception("No encoding line found");
    }
    
    string encoding = cast(string)data[encodingStart..pos];
    pos++;  // Skip the \n
    
    // Find the end of the size info line
    size_t sizeStart = pos;
    while (pos < data.length && data[pos] != '\n') {
        pos++;
    }
    if (pos >= data.length) {
        throw new Exception("No size info found");
    }
    
    string sizeLine = cast(string)data[sizeStart..pos];
    pos++;  // Skip the \n
    
    // Parse size info: width height length
    string[] parts = split(sizeLine, " ");
    if (parts.length < 3) {
        throw new Exception("Invalid size info format");
    }
    
    int width = to!int(parts[0]);
    int height = to!int(parts[1]);
    int expectedBlobLength = to!int(parts[2]);
    
    // Check that we have enough data left
    if (data.length - pos != expectedBlobLength) {
        throw new Exception("Blob size mismatch: expected " ~ to!string(expectedBlobLength) ~ 
                           ", got " ~ to!string(data.length - pos));
    }
    
    // Create image structure
    baaimage img;
    img.format = encoding;
    img.width = width;
    img.height = height;
    
    // Calculate number of tiles (3 bytes per tile: 2 colors + 1 tile num)
    int numTiles = expectedBlobLength / 3;
    img.tiles.length = numTiles;
    
    // Parse the binary blob
    for (int i = 0; i < numTiles; i++) {
        if (pos + 3 > data.length) {
            throw new Exception("Unexpected end of file while reading tiles");
        }
        
        img.tiles[i][0] = data[pos];     // First color
        img.tiles[i][1] = data[pos+1];   // Second color
        img.tiles[i][2] = data[pos+2];   // Tile number
        pos += 3;
    }
    
    // Verify dimensions match
    if (width * height != numTiles) {
        throw new Exception("Dimension mismatch: " ~ to!string(width) ~ "x" ~ to!string(height) ~ 
                           " != " ~ to!string(numTiles));
    }
    
    return img;
}

/**
 * Create a baaimage from raw tile data
 */
baaimage createBaaImage(int width, int height, tilenum[] tileIds, color[2][] tileColors = null) {
    baaimage img = baaimage(width, height);
    
    if (tileIds.length != width * height) {
        throw new Exception("Tile IDs array length doesn't match image dimensions");
    }
    
    for (int i = 0; i < img.tiles.length; i++) {
        img.tiles[i][2] = tileIds[i];  // Tile number
        
        if (tileColors !is null && i < tileColors.length) {
            img.tiles[i][0] = tileColors[i][0];  // First color
            img.tiles[i][1] = tileColors[i][1];  // Second color
        } else {
            // Default colors: white (255) and black (0)
            img.tiles[i][0] = 255;  // First color (white)
            img.tiles[i][1] = 0;    // Second color (black)
        }
    }
    
    return img;
}