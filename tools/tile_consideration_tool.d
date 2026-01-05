#!/usr/bin/env opend run
import std.stdio;
import std.file;
import std.string;
import std.array;
import std.conv;
import std.algorithm;
import std.math;

/**
 * Tile consideration tool for baahouse project
 * Analyzes and describes tile patterns statistically
 */

struct TileStats {
    string filename;
    int tileId;
    double whiteRatio;
    double blackRatio;
    int totalPixels;
    int whitePixels;
    int blackPixels;
    
    // Symmetry analysis
    double horizontalSymmetry;
    double verticalSymmetry;
    double rotationalSymmetry;
    
    // Complexity measures
    double edgeDensity;
    double patternComplexity;
}

TileStats[] loadAllTileStats(string rendersDir = "renders") {
    TileStats[] allStats;
    
    foreach (dirEntry; dirEntries(rendersDir, "tile_*.ppm", SpanMode.shallow)) {
        string fileName = dirEntry.name[ dirEntry.name.lastIndexOf('/') + 1 .. $ ];  // Extract filename

        // Extract tile number from filename (tile_N.ppm)
        string nameWithoutExt = fileName[0 .. fileName.length - 4]; // Remove ".ppm"
        if (nameWithoutExt.startsWith("tile_")) {
            string numStr = nameWithoutExt[5 .. $]; // Remove "tile_" prefix

            // Extract just the number part (in case of "tile_123" format)
            size_t underscoreIdx = numStr.indexOf('_');
            if (underscoreIdx != -1) {
                numStr = numStr[0 .. underscoreIdx];
            }

            try {
                int tileNum = to!int(numStr);
                TileStats stats = analyzeTile(dirEntry.name);
                stats.tileId = tileNum;
                stats.filename = fileName;
                allStats ~= stats;
            } catch (Exception e) {
                writeln("Error parsing tile number from ", nameWithoutExt, ": ", e.msg);
            }
        }
    }
    
    return allStats;
}

TileStats analyzeTile(string filename) {
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
    
    // For this analysis, we'll assume 128x128 resolution (128*128 = 16,384 pixels * 3 channels)
    // Each pixel has R, G, B values - for binary PPM they should be (255,255,255) or (0,0,0)
    const int width = 128;
    const int height = 128;
    
    if (pixelData.length != width * height * 3) {
        writeln("Error: Unexpected pixel data size in ", filename);
        return TileStats();
    }
    
    TileStats stats;
    stats.whitePixels = 0;
    stats.blackPixels = 0;
    stats.totalPixels = width * height;
    
    // Count white vs black pixels (each RGB triple is one pixel)
    for (size_t i = 0; i < pixelData.length; i += 3) {
        ubyte r = pixelData[i];
        ubyte g = pixelData[i+1];
        ubyte b = pixelData[i+2];
        
        // Check if this is a white pixel (255,255,255) or black pixel (0,0,0)
        if (r == 255 && g == 255 && b == 255) {
            stats.whitePixels++;
        } else if (r == 0 && g == 0 && b == 0) {
            stats.blackPixels++;
        } else {
            // If not pure white or black, count as black for binary analysis
            stats.blackPixels++;
        }
    }
    
    stats.whiteRatio = (stats.whitePixels * 100.0) / stats.totalPixels;
    stats.blackRatio = (stats.blackPixels * 100.0) / stats.totalPixels;
    
    // For now, skip detailed symmetry and complexity analysis to focus on basic statistics
    stats.horizontalSymmetry = 0.0;
    stats.verticalSymmetry = 0.0;
    stats.rotationalSymmetry = 0.0;
    stats.edgeDensity = 0.0;
    stats.patternComplexity = 0.0;
    
    return stats;
}

int main(string[] args) {
    string rendersDir = "renders";
    if (args.length >= 2) {
        rendersDir = args[1];
    }
    
    writeln("Analyzing tile statistics for ", rendersDir);
    writeln("------------------------------------------");
    
    TileStats[] allStats = loadAllTileStats(rendersDir);
    sort!("a.tileId < b.tileId")(allStats);
    
    writeln("Tile ID | Filename      | White% | Black% | Analysis");
    writeln("--------|---------------|--------|--------|---------");
    
    foreach (stats; allStats) {
        string analysis = "";
        if (stats.whiteRatio > 90) {
            analysis = "mostly white";
        } else if (stats.blackRatio > 90) {
            analysis = "mostly black";
        } else if (abs(stats.whiteRatio - stats.blackRatio) < 5) {
            analysis = "balanced";
        } else {
            analysis = "unbalanced";
        }
        
        writefln("%7d | %13s | %5.1f%% | %5.1f%% | %s", 
                 stats.tileId, stats.filename, stats.whiteRatio, stats.blackRatio, analysis);
    }
    
    writeln("\nStatistical Summary:");
    writeln("-------------------");
    
    if (allStats.length > 0) {
        double avgWhiteRatio = 0.0, avgBlackRatio = 0.0;
        int mostlyWhiteCount = 0, mostlyBlackCount = 0, balancedCount = 0;
        
        foreach (stats; allStats) {
            avgWhiteRatio += stats.whiteRatio;
            avgBlackRatio += stats.blackRatio;
            
            if (stats.whiteRatio > 75) mostlyWhiteCount++;
            else if (stats.blackRatio > 75) mostlyBlackCount++;
            else balancedCount++;
        }
        
        avgWhiteRatio /= allStats.length;
        avgBlackRatio /= allStats.length;
        
        writeln("Total tiles analyzed: ", allStats.length);
        writeln("Average white ratio: ", avgWhiteRatio, "%");
        writeln("Average black ratio: ", avgBlackRatio, "%");
        writeln("Mostly white tiles: ", mostlyWhiteCount);
        writeln("Mostly black tiles: ", mostlyBlackCount);
        writeln("Balanced tiles: ", balancedCount);
    }
    
    return 0;
}