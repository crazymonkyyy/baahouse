#!/usr/bin/env opend run
import std.stdio;
import std.file;
import std.string;
import std.array;
import std.regex;
import std.conv;

/**
 * PPM validator tool for baahouse project
 * Verifies that rendered tiles are black and white PPM files
 */

int main(string[] args) {
    if (args.length < 2) {
        writeln("Usage: ", args[0], " <ppm_file.ppm>");
        writeln("Or: ", args[0], " --all renders/");
        writeln("Validates that PPM files are black and white (255,255,255) and (0,0,0) only");
        return 1;
    }
    
    string[] files;
    
    if (args[1] == "--all" && args.length >= 3) {
        // Process all PPM files in a directory
        string dir = args[2];
        foreach (file; dir.dirEntries("*.ppm", SpanMode.shallow)) {
            files ~= file.name;
        }
    } else {
        // Process specific files
        files = args[1..$];
    }
    
    bool allValid = true;
    
    foreach (fileName; files) {
        if (!validatePPMFile(fileName)) {
            allValid = false;
        }
    }
    
    return allValid ? 0 : 1;
}

bool validatePPMFile(string fileName) {
    if (!exists(fileName)) {
        writeln("Error: File ", fileName, " does not exist");
        return false;
    }
    
    ubyte[] data = cast(ubyte[])read(fileName);
    
    // Parse PPM header
    size_t headerEnd = findHeaderEnd(data);
    if (headerEnd == 0) {
        writeln("Error: Invalid PPM header in file ", fileName);
        return false;
    }
    
    string header = cast(string)data[0..headerEnd];
    string[] lines = splitLines(header);
    
    // Validate PPM format
    if (lines.length < 3 || !lines[0].startsWith("P6")) {
        writeln("Error: Not a valid P6 PPM file: ", fileName);
        return false;
    }
    
    // Extract width and height
    string[] dims = split(lines[1]);
    if (dims.length < 2) {
        writeln("Error: Could not parse dimensions in ", fileName);
        return false;
    }
    
    int width = to!int(dims[0]);
    int height = to!int(dims[1]);
    
    // Extract max value (should be 255)
    int maxVal = to!int(lines[2]);
    if (maxVal != 255) {
        writeln("Error: Max value not 255 in ", fileName);
        return false;
    }
    
    writeln("File: ", fileName, " - Size: ", width, "x", height, " - Max value: ", maxVal);
    
    // Parse pixel data (after header)
    ubyte[] pixelData = data[headerEnd..$];
    size_t expectedPixelSize = width * height * 3; // 3 bytes per pixel (RGB)

    if (pixelData.length != expectedPixelSize) {
        writeln("Error: Invalid pixel data size in ", fileName,
                " - Expected: ", expectedPixelSize, ", Got: ", pixelData.length);
        return false;
    }

    // Check that all pixels are either white (255,255,255) or black (0,0,0)
    bool isBlackAndWhite = true;
    for (size_t i = 0; i < pixelData.length; i += 3) {
        ubyte r = pixelData[i];
        ubyte g = pixelData[i+1];
        ubyte b = pixelData[i+2];
        
        // Check if RGB values are all the same (grayscale)
        if (r != g || g != b) {
            writeln("Error: Non-grayscale pixel in ", fileName, 
                    " at position ", i/3, " - RGB: (", r, ",", g, ",", b, ")");
            isBlackAndWhite = false;
            break;
        }
        
        // Check if pixel is only black (0) or white (255)
        if (r != 0 && r != 255) {
            writeln("Error: Non-black/white pixel in ", fileName, 
                    " at position ", i/3, " - Value: ", r);
            isBlackAndWhite = false;
            break;
        }
    }
    
    if (isBlackAndWhite) {
        writeln("✓ Valid black and white PPM file: ", fileName);
        return true;
    } else {
        writeln("✗ Invalid file: ", fileName);
        return false;
    }
}

size_t findHeaderEnd(ubyte[] data) {
    // Find the third newline which should be the end of PPM header
    // P6 PPM format: magic number \n width height \n maxval \n pixel data
    size_t newlineCount = 0;
    size_t pos = 0;

    while (pos < data.length) {
        if (data[pos] == '\n') {
            newlineCount++;
            if (newlineCount == 3) {
                return pos + 1; // Return position after third newline
            }
        }
        pos++;
    }

    return 0; // Error if we don't find 3 newlines
}

string[] splitLines(string input) {
    return input.split("\n");
}