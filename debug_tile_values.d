#!/usr/bin/env opend run
import std.stdio;
import common.alpha_tiles;

int main() {
    writeln("Testing tile 0 (x+y<1.0) at various points:");
    writeln("(0.0,0.0): ", tile!(0)(0.0f, 0.0f));
    writeln("(0.25,0.25): ", tile!(0)(0.25f, 0.25f));
    writeln("(0.5,0.5): ", tile!(0)(0.5f, 0.5f));
    writeln("(0.75,0.75): ", tile!(0)(0.75f, 0.75f));
    writeln("(1.0,1.0): ", tile!(0)(1.0f, 1.0f));
    
    writeln("\nTesting tile 1 (abs((x-0.5)*(y-0.5))<0.1) at various points:");
    writeln("(0.0,0.0): ", tile!(1)(0.0f, 0.0f));
    writeln("(0.5,0.5): ", tile!(1)(0.5f, 0.5f));
    writeln("(0.6,0.6): ", tile!(1)(0.6f, 0.6f));
    writeln("(1.0,1.0): ", tile!(1)(1.0f, 1.0f));
    
    return 0;
}