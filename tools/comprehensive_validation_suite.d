#!/usr/bin/env opend run
import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.string;
import std.algorithm;
import std.math;
import std.datetime;
import common.alpha_tiles;

/**
 * Comprehensive validation tool for baahouse tiles
 * Performs in-depth testing based on the test expansion plan
 */

import std.datetime;
import std.format;

struct TileTestResult {
    int tileId;
    string testName;
    bool passed;
    string errorMessage;
    Duration executionTime;
}

// Runtime dispatch function (using proper template metaprogramming approach)
bool evalTileRuntime(int tileId, float x, float y) {
    label: switch(tileId) {
        static foreach(int I; 0 .. 100) {  // Use only the defined tile range (0-99)
            case I: return tile!I(x, y);
        }
        default: return false;
    }
}

// Function to run unit tests on individual tiles with extreme values
bool runUnitTests(int tileId, out string errorMessage) {
    auto startTime = Clock.currTime();

    // Test with extreme values outside [0,1] range
    float[] extremes = [-10.0, -1.0, -0.1, 1.1, 2.0, 10.0];
    foreach (ex; extremes) {
        foreach (ey; extremes) {
            try {
                bool result = evalTileRuntime(tileId, ex, ey);
                // Just ensure no exceptions are thrown
            } catch (Exception e) {
                errorMessage = format("Tile %d threw exception with extreme values (%.2f, %.2f): %s",
                                      tileId, ex, ey, e.msg);
                return false;
            }
        }
    }

    // Test boundary conditions
    float[] boundaries = [0.0, 0.1, 0.5, 0.9, 1.0];
    foreach (bx; boundaries) {
        foreach (by; boundaries) {
            try {
                bool result = evalTileRuntime(tileId, bx, by);
                // Just ensure no exceptions
            } catch (Exception e) {
                errorMessage = format("Tile %d threw exception with boundary values (%.2f, %.2f): %s",
                                      tileId, bx, by, e.msg);
                return false;
            }
        }
    }

    // Test precision with floating point values
    for (int i = 0; i < 100; i++) {
        float x = 0.5f + 0.001f * sin(cast(float)i);
        float y = 0.5f + 0.001f * cos(cast(float)i);
        try {
            bool result = evalTileRuntime(tileId, x, y);
        } catch (Exception e) {
            errorMessage = format("Tile %d threw exception with precision test: %s", tileId, e.msg);
            return false;
        }
    }

    auto endTime = Clock.currTime();
    errorMessage = format("Passed extreme value, boundary, and precision tests in %s",
                         to!string((endTime - startTime).total!"msecs") ~ "ms");
    return true;
}

// Function to run performance tests
bool runPerformanceTests(int tileId, out string errorMessage) {
    auto startTime = Clock.currTime();

    const int testResolution = 64;  // Lower resolution for performance test to avoid long execution
    int evaluations = 0;
    int trueCount = 0;

    for (int y = 0; y < testResolution; y++) {
        for (int x = 0; x < testResolution; x++) {
            float xf = cast(float)x / (testResolution - 1);
            float yf = cast(float)y / (testResolution - 1);

            if (evalTileRuntime(tileId, xf, yf)) {
                trueCount++;
            }
            evaluations++;
        }
    }

    auto endTime = Clock.currTime();
    Duration execTime = endTime - startTime;

    // Check if evaluation took too long (more than 100ms for 4096 evaluations)
    if (execTime.total!"msecs" > 100) {
        errorMessage = format("Tile %d performance test exceeded threshold: %sms",
                              tileId, execTime.total!"msecs");
        return false;
    }

    errorMessage = format("Passed performance test: %d evaluations in %sms, %d true/%d false",
                         evaluations, execTime.total!"msecs", trueCount, evaluations - trueCount);
    return true;
}

// Function to run robustness tests with special values
bool runRobustnessTests(int tileId, out string errorMessage) {
    // Test with special values (infinity, NaN)
    float inf = 1.0f / 0.0f;
    float nan = 0.0f / 0.0f;

    float[2][] specialValues = [
        [inf, inf],
        [nan, nan],
        [inf, 0.5f],
        [0.5f, inf],
        [nan, 0.5f],
        [0.5f, nan],
        [inf, nan],
        [nan, inf]
    ];

    foreach (vals; specialValues) {
        try {
            bool result = evalTileRuntime(tileId, vals[0], vals[1]);
            // Just verify it doesn't crash
        } catch (Exception e) {
            errorMessage = format("Tile %d crashed with special values (%.2f, %.2f): %s",
                                  tileId, vals[0], vals[1], e.msg);
            return false;
        }
    }

    errorMessage = "Passed robustness test with special values (inf, NaN)";
    return true;
}

int main(string[] args) {
    writeln("Comprehensive Validation Suite for Baahouse Tiles");
    writeln("===============================================");

    int startTile = 0;
    int endTile = 49; // Test first 50 tiles

    if (args.length >= 2) {
        startTile = to!int(args[1]);
    }
    if (args.length >= 3) {
        endTile = to!int(args[2]);
    }

    writeln(format("Testing tiles from %d to %d", startTile, endTile));

    TileTestResult[] allResults;

    for (int tileId = startTile; tileId <= endTile; tileId++) {
        writeln(format("\nTesting tile %d:", tileId));

        // Unit tests
        string errorMsg;
        bool unitResult = runUnitTests(tileId, errorMsg);
        allResults ~= TileTestResult(tileId, "Unit Tests", unitResult, errorMsg, Duration.zero);
        writeln(format("  Unit Tests: %s - %s", unitResult ? "PASS" : "FAIL", errorMsg));

        // Performance tests
        bool perfResult = runPerformanceTests(tileId, errorMsg);
        allResults ~= TileTestResult(tileId, "Performance Tests", perfResult, errorMsg, Duration.zero);
        writeln(format("  Performance Tests: %s - %s", perfResult ? "PASS" : "FAIL", errorMsg));

        // Robustness tests
        bool robustResult = runRobustnessTests(tileId, errorMsg);
        allResults ~= TileTestResult(tileId, "Robustness Tests", robustResult, errorMsg, Duration.zero);
        writeln(format("  Robustness Tests: %s - %s", robustResult ? "PASS" : "FAIL", errorMsg));
    }

    // Summary
    writeln("\n\nSUMMARY:");
    writeln("========");

    int totalTests = cast(int)allResults.length;
    int passedTests = 0;
    foreach (result; allResults) {
        if (result.passed) passedTests++;
    }

    writeln(format("Total test runs: %d", totalTests));
    writeln(format("Passed: %d", passedTests));
    writeln(format("Failed: %d", totalTests - passedTests));

    if (totalTests - passedTests > 0) {
        writeln("\nFAILED TESTS:");
        foreach (result; allResults) {
            if (!result.passed) {
                writeln(format("  Tile %d - %s: %s", result.tileId, result.testName, result.errorMessage));
            }
        }
    }

    return (totalTests == passedTests) ? 0 : 1;
}