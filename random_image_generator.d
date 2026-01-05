#!/usr/bin/env opend run
/**
 * Tool to generate random small baahouse images
 */

import std.stdio;
import std.random;
import std.conv;
import std.range;
import std.algorithm;
import baahouse_serializer;

/**
 * Generate a random baahouse image
 */
baaimage generateRandomImage(int width, int height, int maxTile = 249, int seed = 0) {
    if (seed != 0) {
        auto rng = Random(seed);
        return doGenerateRandomImage(width, height, maxTile, rng);
    } else {
        auto rng = Random(unpredictableSeed());
        return doGenerateRandomImage(width, height, maxTile, rng);
    }
}

baaimage doGenerateRandomImage(int width, int height, int maxTile, ref Random rng) {
    baaimage img = baaimage(width, height);

    foreach (ref tile; img.tiles) {
        // Random tile number (0 to maxTile)
        tile[2] = cast(ubyte)uniform(0, maxTile + 1, rng);

        // Random colors
        tile[0] = cast(ubyte)uniform(0, 256, rng);  // First color
        tile[1] = cast(ubyte)uniform(0, 256, rng);  // Second color
    }

    return img;
}

/**
 * Generate a random baahouse image with some clustering of similar tiles
 */
baaimage generateClusteredRandomImage(int width, int height, int maxTile = 249, int seed = 0) {
    if (seed != 0) {
        auto rng = Random(seed);
        return doGenerateClusteredRandomImage(width, height, maxTile, rng);
    } else {
        auto rng = Random(unpredictableSeed());
        return doGenerateClusteredRandomImage(width, height, maxTile, rng);
    }
}

baaimage doGenerateClusteredRandomImage(int width, int height, int maxTile, ref Random rng) {
    baaimage img = baaimage(width, height);

    // Define random regions with similar tiles
    int numRegions = uniform(3, 8, rng);  // 3-7 regions

    foreach (i; 0..numRegions) {
        // Random region parameters
        int centerX = uniform(0, width, rng);
        int centerY = uniform(0, height, rng);
        int radius = uniform(1, max(2, max(width, height) / 3), rng);
        tilenum regionTile = cast(ubyte)uniform(0, maxTile + 1, rng);

        // Fill the region
        foreach (y; 0..height) {
            foreach (x; 0..width) {
                int dx = x - centerX;
                int dy = y - centerY;
                int distSq = dx * dx + dy * dy;

                if (distSq <= radius * radius) {
                    int idx = y * width + x;
                    img.tiles[idx][2] = regionTile;
                    img.tiles[idx][0] = cast(ubyte)uniform(0, 256, rng);  // First color
                    img.tiles[idx][1] = cast(ubyte)uniform(0, 256, rng);  // Second color
                }
            }
        }
    }

    // Fill in any remaining tiles randomly
    foreach (i, ref tile; img.tiles) {
        if (tile[2] == 0) {  // If still default (0)
            tile[2] = cast(ubyte)uniform(0, maxTile + 1, rng);
            tile[0] = cast(ubyte)uniform(0, 256, rng);  // First color
            tile[1] = cast(ubyte)uniform(0, 256, rng);  // Second color
        }
    }

    return img;
}

int main(string[] args) {
    if (args.length < 3) {
        writeln("Usage: ", args[0], " <width> <height> [output_file.baa] [seed] [clustered]");
        writeln("  width, height: dimensions of the image");
        writeln("  output_file: output file name (default: random_image.baa)");
        writeln("  seed: random seed (default: 0 = random seed)");
        writeln("  clustered: use clustered pattern (default: false)");
        return 1;
    }

    int width = to!int(args[1]);
    int height = to!int(args[2]);
    string outputFile = (args.length > 3) ? args[3] : "random_image.🐑 🏠";
    int seed = (args.length > 4) ? to!int(args[4]) : 0;
    bool clustered = (args.length > 5) ? (args[5] == "true" || args[5] == "1") : false;

    if (width <= 0 || height <= 0) {
        writeln("Error: Width and height must be positive");
        return 1;
    }

    baaimage img;
    if (clustered) {
        writeln("Generating clustered random baahouse image ", width, "x", height);
        img = generateClusteredRandomImage(width, height, 249, seed);
    } else {
        writeln("Generating random baahouse image ", width, "x", height);
        img = generateRandomImage(width, height, 249, seed);
    }

    serializeBaaImage(img, outputFile);
    writeln("Saved random baahouse image to ", outputFile);
    writeln("  Format: ", img.format);
    writeln("  Size: ", img.width, "x", img.height);
    writeln("  Tiles: ", img.tiles.length);

    return 0;
}