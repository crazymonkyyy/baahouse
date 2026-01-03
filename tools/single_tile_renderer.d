#!/usr/bin/env opend run
import std.stdio;
import std.conv;
import std.math;
import common.alpha_tiles;  // Import the tile definitions
import raylib;

/**
 * Single tile renderer for baahouse project
 * Renders a single tile as a 128x128 bitmap with specified colors
 */

int main(string[] args) {
    if (args.length < 2) {
        writeln("Usage: ", args[0], " <tile_number> [color1] [color2]");
        writeln("Renders a single tile as 128x128 bitmap");
        writeln("Colors default to white (0xFFFFFFFF) and black (0xFF000000) if not specified");
        return 1;
    }
    
    int tileNum = to!int(args[1]);
    if (tileNum < 0 || tileNum >= maxtiles) {
        writeln("Error: Tile number must be between 0 and ", maxtiles-1);
        return 1;
    }
    
    // Default colors: white and black
    uint color1 = 0xFFFFFFFF; // white
    uint color2 = 0xFF000000; // black
    
    if (args.length >= 3) {
        color1 = to!uint("0x" ~ args[2]);
    }
    if (args.length >= 4) {
        color2 = to!uint("0x" ~ args[3]);
    }
    
    // Initialize Raylib window
    const int width = 128;
    const int height = 128;
    
    SetConfigFlags(FLAG_WINDOW_RESIZABLE);
    InitWindow(width, height, "Baahouse Tile Renderer - Tile " ~ args[1]);
    SetTargetFPS(60);
    
    // Create an image to draw the tile
    Image img = GenImageColor(width, height, BLACK);
    
    // Render the tile function to the image
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            float xf = cast(float)x / (width - 1);  // Normalize to 0-1
            float yf = cast(float)y / (height - 1); // Normalize to 0-1
            
            // Get the tile output (true/false)
            bool result = tile!(tileNum)(xf, yf);
            
            // Set pixel based on result and colors
            Color pixelColor = result ? 
                Color(color1 >> 24, (color1 >> 16) & 0xFF, (color1 >> 8) & 0xFF, color1 & 0xFF) :
                Color(color2 >> 24, (color2 >> 16) & 0xFF, (color2 >> 8) & 0xFF, color2 & 0xFF);
                
            ImageDrawPixel(&img, x, y, pixelColor);
        }
    }
    
    // Create texture from image
    Texture2D texture = LoadTextureFromImage(img);
    
    // Main loop
    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        
        // Draw the texture
        DrawTexture(texture, 0, 0, WHITE);
        
        // Add tile number to the window
        DrawText("Tile " ~ args[1], 10, 10, 20, BLACK);
        
        EndDrawing();
    }
    
    // Cleanup
    UnloadTexture(texture);
    UnloadImage(img);
    CloseWindow();
    
    return 0;
}