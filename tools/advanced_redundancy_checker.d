#!/usr/bin/env opend run
import std.stdio;
import std.file;
import std.string;
import std.array;
import std.regex;
import std.conv;
import std.algorithm;

/**
 * Advanced redundancy checker for baahouse tiles
 * Compares tile renders and also checks for inverse relationships
 */

struct PPMImage {
    int width;
    int height;
    ubyte[] pixels;  // RGB format, 3 bytes per pixel (assumes black/white)
    
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

bool areImagesInverses(PPMImage img1, PPMImage img2) {
    if (img1.width != img2.width || img1.height != img2.height) {
        return false;
    }
    
    if (img1.pixels.length != img2.pixels.length) {
        return false;
    }
    
    // Check if each pixel in img1 is the inverse of img2
    for (size_t i = 0; i < img1.pixels.length; i += 3) {
        ubyte r1 = img1.pixels[i];
        ubyte g1 = img1.pixels[i+1];
        ubyte b1 = img1.pixels[i+2];
        
        ubyte r2 = img2.pixels[i];
        ubyte g2 = img2.pixels[i+1];
        ubyte b2 = img2.pixels[i+2];
        
        // Check if this is a black/white image (only 0 or 255 for each channel)
        if ((r1 != 0 && r1 != 255) || (g1 != 0 && g1 != 255) || (b1 != 0 && b1 != 255) ||
            (r2 != 0 && r2 != 255) || (g2 != 0 && g2 != 255) || (b2 != 0 && b2 != 255)) {
            writeln("Warning: Non-binary color values detected in image comparison");
            return false;
        }
        
        // Check if img1 pixel is inverse of img2 pixel
        // (255,255,255) should map to (0,0,0) and vice versa
        bool isInverse = (r1 == 255 && r2 == 0) || (r1 == 0 && r2 == 255);
        if (!isInverse) return false;
        
        isInverse = (g1 == 255 && g2 == 0) || (g1 == 0 && g2 == 255);
        if (!isInverse) return false;
        
        isInverse = (b1 == 255 && b2 == 0) || (b1 == 0 && b2 == 255);
        if (!isInverse) return false;
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
        if (fileName.startsWith("tile_") && fileName.indexOf("_inverted") == -1 && !fileName.endsWith("_test.ppm")) {
            tileFiles ~= fileName;
        }
    }
    
    if (tileFiles.length == 0) {
        writeln("No tile files found in ", rendersDir);
        return 1;
    }
    
    // Sort files to process in order
    sort(tileFiles);
    
    writeln("Checking for redundant and inverse tiles in ", rendersDir, " (", tileFiles.length, " files found)");
    
    // Load all images
    PPMImage[] images;
    int[] tileNumbers;
    string[] fileNames;
    
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
                    fileNames ~= file;
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
    
    writeln("Loaded ", images.length, " tile images for comparison");
    
    // Compare each tile against all other tiles
    bool foundRedundancy = false;
    bool foundInverses = false;
    
    // Keep track of found pairs to limit output to first 5 of each type
    int redundancyCount = 0;
    int inverseCount = 0;
    
    for (size_t i = 0; i < images.length; i++) {
        for (size_t j = i + 1; j < images.length; j++) {
            if (redundancyCount < 5 && areImagesIdentical(images[i], images[j])) {
                writeln("REDUNDANT TILES FOUND: ", tileNumbers[i], " and ", tileNumbers[j], 
                        " (files: ", fileNames[i], " and ", fileNames[j], ")");
                foundRedundancy = true;
                redundancyCount++;
            } else if (inverseCount < 5 && areImagesInverses(images[i], images[j])) {
                writeln("INVERSE TILES FOUND: ", tileNumbers[i], " and ", tileNumbers[j], 
                        " (files: ", fileNames[i], " and ", fileNames[j], ")");
                foundInverses = true;
                inverseCount++;
            }
            
            // Stop if we've found 5 of each
            if (redundancyCount >= 5 && inverseCount >= 5) {
                break;
            }
        }
        if (redundancyCount >= 5 && inverseCount >= 5) {
            break;
        }
    }
    
    if (!foundRedundancy) {
        writeln("No redundant tiles found among the ", images.length, " tiles checked!");
    } else {
        writeln("Found ", redundancyCount, " redundant tile pairs.");
    }
    
    if (!foundInverses) {
        writeln("No inverse tile pairs found among the ", images.length, " tiles checked!");
    } else {
        writeln("Found ", inverseCount, " inverse tile pairs.");
    }
    
    // Summary
    writeln("\nSUMMARY:");
    writeln("- Total tiles checked: ", images.length);
    writeln("- Redundant pairs found: ", redundancyCount, "/5 displayed");
    writeln("- Inverse pairs found: ", inverseCount, "/5 displayed");
    
    return (foundRedundancy || foundInverses) ? 1 : 0;
}