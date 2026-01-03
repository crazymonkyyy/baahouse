#!/usr/bin/env opend run
import std.stdio;
import std.file;
import std.regex;
import std.string;
import std.array;
import std.algorithm;
import std.format;
import std.conv;

/**
 * Tile linter for baahouse project
 * Validates tile files according to project conventions:
 * - Must have shebang line
 * - Must define alias output=bool;
 * - Must define enum maxtiles=256;
 * - Must have proper tile function format
 * - Coordinates (0,0) top-left, (1,1) bottom-right
 */

int main(string[] args) {
    if (args.length < 2) {
        writeln("Usage: ", args[0], " <tile_file.d>");
        writeln("Validates tile file according to baahouse project conventions");
        return 1;
    }

    string fileName = args[1];

    if (!exists(fileName)) {
        writeln("Error: File ", fileName, " does not exist");
        return 1;
    }

    string content = cast(string)read(fileName);
    string[] lines = splitLines(content);

    bool isValid = true;
    string[] errors;

    // Check for shebang line
    if (lines.length == 0 || !lines[0].startsWith("#!")) {
        errors ~= "Missing or invalid shebang line at the beginning of the file";
        isValid = false;
    } else {
        writeln("✓ Shebang line found: ", lines[0]);
    }

    // Check for module declaration
    bool hasModule = false;
    foreach (line; lines) {
        if (line.strip().startsWith("module ")) {
            hasModule = true;
            writeln("✓ Module declaration found: ", line.strip());
            break;
        }
    }
    if (!hasModule) {
        errors ~= "Missing module declaration";
        isValid = false;
    }

    // Check for output alias
    bool hasOutputAlias = false;
    foreach (line; lines) {
        if (line.strip().startsWith("alias output=bool;")) {
            hasOutputAlias = true;
            writeln("✓ Output alias found: ", line.strip());
            break;
        }
    }
    if (!hasOutputAlias) {
        errors ~= "Missing or incorrect output alias (should be: alias output=bool;)";
        isValid = false;
    }

    // Check for maxtiles enum
    bool hasMaxTilesEnum = false;
    foreach (line; lines) {
        if (line.strip().startsWith("enum maxtiles=256;")) {
            hasMaxTilesEnum = true;
            writeln("✓ Max tiles enum found: ", line.strip());
            break;
        }
    }
    if (!hasMaxTilesEnum) {
        errors ~= "Missing or incorrect maxtiles enum (should be: enum maxtiles=256;)";
        isValid = false;
    }

    // Check for tile functions
    int tileCount = 0;
    int[] tileIds;
    auto tilePattern = regex(r"output tile\(int i:(\d+)\)\(float x,float y\)=>[^;]+;.*");

    foreach (i, line; lines) {
        auto match = matchFirst(line, tilePattern);
        if (!match.empty) {
            tileCount++;
            int tileId = to!int(match[1]);
            tileIds ~= tileId;

            // Extract comment if present
            string comment = "";
            size_t commentPos = line.indexOf("//");
            if (commentPos != -1) {
                comment = line[commentPos .. $];
            }

            writeln("✓ Tile function found: tile ", tileId, " at line ", i+1, comment);
        }
    }

    if (tileCount == 0) {
        errors ~= "No tile functions found. Expected format: output tile(int i:N)(float x,float y)=>expression;";
        isValid = false;
    } else {
        writeln("✓ Found ", tileCount, " tile function(s)");

        // Check for duplicate tile IDs
        sort(tileIds);
        for (int i = 1; i < tileIds.length; i++) {
            if (tileIds[i] == tileIds[i-1]) {
                errors ~= format("Duplicate tile ID found: %d", tileIds[i]);
                isValid = false;
            }
        }

        // Check for gaps in sequence (not strictly required, but warn)
        if (tileIds.length > 0) {
            sort(tileIds);
            int expected = tileIds[0];
            foreach (id; tileIds) {
                if (id != expected) {
                    writeln("Note: Non-sequential tile IDs detected");
                    break;
                }
                expected++;
            }
        }
    }

    // Check proper function format
    bool hasCorrectFormat = true;
    auto functionPattern = regex(r"output tile\(int i:(\d+)\)\(float x,float y\)");
    foreach (line; lines) {
        auto match = matchFirst(line, functionPattern);
        if (!match.empty) {
            if (line.indexOf("=>") == -1 || line.indexOf(";") == -1) {
                errors ~= format("Tile function at line does not have correct format: %s", line);
                hasCorrectFormat = false;
                isValid = false;
            }
        }
    }

    if (hasCorrectFormat) {
        writeln("✓ All tile functions have correct format");
    }

    // Report results
    if (isValid) {
        writeln("\n✓ File ", fileName, " passed all validation checks!");
        writeln("Summary: ", tileCount, " tile(s) found");
        return 0;
    } else {
        writeln("\n✗ File ", fileName, " failed validation:");
        foreach (error; errors) {
            writeln("  - ", error);
        }
        return 1;
    }
}

// Helper function to split lines
string[] splitLines(string content) {
    return split(content, "\n");
}