module tools.tile_name_utils;

import std.file;
import std.string;
import std.regex;
import std.array;
import std.conv;

/**
 * Tile name utility module that gets the actual name of a tile
 * by reading the source file comments using OpenD's import(filename) pattern
 */

// Cache to store tile definitions for performance
private string[] tileComments;

void initializeTileNames() {
    if (tileComments.length > 0) return; // Already initialized

    string source = cast(string)std.file.read("common/alpha_tiles.d");
    string[] lines = splitLines(source);

    tileComments.length = 256; // maxtiles value

    auto tilePattern = regex(r"output tile\(int i:(\d+)\)\(float x,float y\)=>[^;]+;.*");

    foreach (line; lines) {
        auto match = matchFirst(line, tilePattern);
        if (!match.empty) {
            int tileId = to!int(match[1]);

            // Extract comment if present
            string comment = "";
            size_t commentPos = line.indexOf("//");
            if (commentPos != -1) {
                comment = line[commentPos + 2 .. $].strip(); // Remove "//" and trim
            }

            if (comment.length > 0) {
                tileComments[tileId] = comment;
            } else {
                tileComments[tileId] = "tile " ~ to!string(tileId);
            }
        }
    }
}

string getTileName(int index) {
    initializeTileNames();

    if (index >= 0 && index < tileComments.length && tileComments[index].length > 0) {
        return tileComments[index];
    } else {
        return "tile " ~ to!string(index);
    }
}

string[] splitLines(string content) {
    return content.split("\n");
}