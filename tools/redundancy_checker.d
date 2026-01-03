#!/usr/bin/env opend run
import std.stdio;
import std.file;
import std.string;
import std.array;
import std.regex;
import std.conv;
import std.algorithm;
import std.path;

/**
 * Redundancy checker for baahouse tiles
 * Compares each rendered tile against all previous tiles to find duplicates
 * Uses the actual rendered PPM files for comparison
 */

struct PPMImage {
    int width;
    int height;
    ubyte[] pixels;  // RGB format, 3 bytes per pixel
    
    this(int w, int h) {
        width = w;
        height = h;
        pixels.length = w * h * 3;
    }
}

PPMImage loadPPM(string filename) {
    if (!exists(filename)) {
        writeln("Error: File ", filename, " does not exist");
        return PPMImage(0, 0);
    }
    
    ubyte[] data = cast(ubyte[])read(filename);
    
    // Parse PPM header to find where it ends (after third newline)
    size_t pos = 0;
    size_t newlineCount = 0;
    
    while (pos < data.length) {
        if (data[pos] == '\n') {
            newlineCount++;
            if (newlineCount == 3) {
                pos++; // Move past the third newline
                break;
            }
        }
        pos++;
    }
    
    ubyte[] pixelData = data[pos..$];
    
    // For this tool, we'll assume 128x128 resolution since that's what we generate
    int width = 128;
    int height = 128;
    
    if (pixelData.length != width * height * 3) {
        writeln("Error: Invalid pixel data size");
        return PPMImage(0, 0);
    }
    
    PPMImage result;
    result.width = width;
    result.height = height;
    result.pixels = pixelData;
    return result;
}

bool areImagesIdentical(PPMImage img1, PPMImage img2) {
    if (img1.width != img2.width || img1.height != img2.height) {
        return false;
    }
    
    if (img1.pixels.length != img2.pixels.length) {
        return false;
    }
    
    for (size_t i = 0; i < img1.pixels.length; i++) {
        if (img1.pixels[i] != img2.pixels[i]) {
            return false;
        }
    }
    
    return true;
}

int main(string[] args) {
    string rendersDir = "renders";
    if (args.length >= 2) {
        rendersDir = args[1];
    }
    
    if (!exists(rendersDir)) {
        writeln("Error: Renders directory ", rendersDir, " does not exist");
        return 1;
    }
    
    // Find all tile files in the directory
    string[] tileFiles;
    foreach (string file; dirEntries(rendersDir, "*.ppm", SpanMode.shallow)) {
        string fileName = file[ file.lastIndexOf('/') + 1 .. $ ];  // Extract filename
        if (fileName.startsWith("tile_") && fileName.indexOf("_inverted") == -1) {
            tileFiles ~= fileName;
        }
    }

    if (tileFiles.length == 0) {
        writeln("No tile files found in ", rendersDir);
        return 1;
    }

    // Sort files to process in order
    sort(tileFiles);

    writeln("Checking for redundant tiles in ", rendersDir, " (", tileFiles.length, " files found)");

    // Load all images
    PPMImage[] images;
    int[] tileNumbers;

    foreach (string file; tileFiles) {
        // Extract tile number from filename (tile_N.ppm)
        string nameWithoutExt = file[0 .. file.length - 4]; // Remove ".ppm"
        if (nameWithoutExt.startsWith("tile_")) {
            string numStr = nameWithoutExt[5 .. $]; // Remove "tile_" prefix

            // Extract just the number part (in case of "tile_123" format)
            size_t underscoreIdx = numStr.indexOf('_');
            if (underscoreIdx != -1) {
                numStr = numStr[0 .. underscoreIdx];
            }

            try {
                int tileNum = to!int(numStr);
                auto img = loadPPM(rendersDir ~ "/" ~ file);
                if (img.width > 0 && img.height > 0) {  // Successfully loaded
                    images ~= img;
                    tileNumbers ~= tileNum;
                }
            } catch (Exception e) {
                writeln("Error parsing tile number from ", nameWithoutExt, ": ", e.msg);
            }
        }
    }
    
    if (images.length == 0) {
        writeln("No valid tile images loaded");
        return 1;
    }
    
    // Compare each tile against all previous tiles
    bool foundRedundancy = false;
    for (size_t i = 1; i < images.length; i++) {
        for (size_t j = 0; j < i; j++) {
            if (areImagesIdentical(images[i], images[j])) {
                writeln("Redundant tiles found: ", tileNumbers[i], " and ", tileNumbers[j]);
                foundRedundancy = true;
            }
        }
    }
    
    if (!foundRedundancy) {
        writeln("No redundant tiles found among the ", images.length, " tiles checked!");
    }
    
    return foundRedundancy ? 1 : 0;
}