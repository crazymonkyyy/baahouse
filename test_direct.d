#!/usr/bin/env opend run
import std.stdio;
import std.math;
import common.alpha_tiles;

int main() {
    writeln("Direct comparison using the original tile functions:");
    
    int differences = 0;
    for (int y = 0; y <= 64; y++) {
        for (int x = 0; x <= 64; x++) {
            float xf = cast(float)x / 64.0;
            float yf = cast(float)y / 64.0;
            
            bool tile40 = tile!(40)(xf, yf);  // Direct call to tile function
            bool tile46 = tile!(46)(xf, yf);  // Direct call to tile function
            
            if (tile40 != tile46) {
                differences++;
                if (differences <= 3) { // Only print first 3 differences
                    writeln("Difference at (", x, ",", y, "): xf=", xf, ", yf=", yf, "  T40=", tile40, " T46=", tile46);
                }
            }
        }
    }
    
    if (differences > 0) {
        writeln("Found ", differences, " differences total");
        writeln("Tiles 40 and 46 are NOT redundant");
    } else {
        writeln("No differences found - tiles are redundant");
    }
    
    return 0;
}