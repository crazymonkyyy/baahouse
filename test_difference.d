#!/usr/bin/env opend run
import std.stdio;
import std.math;

int main() {
    writeln("Tile 40 (diamond shape): abs(x-0.5)+abs(y-0.5)<0.3");
    writeln("Tile 46 (diamond cross): abs(x-y)<0.3 && abs(x+y-1.0)<0.3");
    writeln();
    
    for (int y = 0; y < 8; y++) {
        for (int x = 0; x < 8; x++) {
            float xf = cast(float)x / 7.0;
            float yf = cast(float)y / 7.0;
            
            bool tile40 = abs(xf-0.5)+abs(yf-0.5)<0.3;
            bool tile46 = abs(xf-yf)<0.3 && abs(xf+yf-1.0)<0.3;
            
            writef("(%s,%s) T40=%s T46=%s  ", x, y, tile40, tile46);
            if (tile40 != tile46) {
                writeln(" <-- DIFFERENCE!");
            } else {
                writeln();
            }
        }
    }
    
    return 0;
}