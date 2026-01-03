#!/usr/bin/env opend run
import std.stdio;
import std.math;

int main() {
    writeln("Testing at higher resolution to detect any differences between tile 40 and 46");
    
    int differences = 0;
    for (int y = 0; y <= 100; y++) {
        for (int x = 0; x <= 100; x++) {
            float xf = cast(float)x / 100.0;
            float yf = cast(float)y / 100.0;
            
            bool tile40 = abs(xf-0.5)+abs(yf-0.5)<0.3;
            bool tile46 = abs(xf-yf)<0.3 && abs(xf+yf-1.0)<0.3;
            
            if (tile40 != tile46) {
                differences++;
                if (differences <= 5) { // Only print first 5 differences
                    writeln("Difference at (", x, ",", y, "): xf=", xf, ", yf=", yf, "  T40=", tile40, " T46=", tile46);
                }
            }
        }
    }
    
    if (differences > 0) {
        writeln("Found ", differences, " differences total");
    } else {
        writeln("No differences found at 100x100 resolution");
    }
    
    return 0;
}