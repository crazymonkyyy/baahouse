#!/usr/bin/env opend run
/**
 * Renderer for baahouse images to PPM format
 * Uses the tile functions to render each tile at a specified resolution
 */

import std.stdio;
import std.conv;
import std.file;
import std.typecons;
import std.array : split;
import std.algorithm : startsWith;
import baahouse_serializer;
import common.alpha_tiles;

/**
 * Render a baahouse image to PPM format
 */
void renderBaaImage(baaimage img, string outputFile, int tileResolution = 8) {
    PaletteConfig config;
    config.type = "grayscale";
    config.useHue = false;

    renderBaaImageWithConfig(img, outputFile, tileResolution, config);
}

/**
 * Render a baahouse image to PPM format with palette configuration
 */
void renderBaaImageWithConfig(baaimage img, string outputFile, int tileResolution, PaletteConfig config) {
    // Calculate output dimensions
    int outputWidth = img.width * tileResolution;
    int outputHeight = img.height * tileResolution;

    // Create PPM header
    string ppmHeader = "P6\n" ~ to!string(outputWidth) ~ " " ~ to!string(outputHeight) ~ "\n255\n";

    // Prepare image data (RGB format, 3 bytes per pixel)
    ubyte[] imageData;
    imageData.length = outputWidth * outputHeight * 3;  // 3 bytes per pixel (RGB)

    // Render each tile
    for (int y = 0; y < img.height; y++) {
        for (int x = 0; x < img.width; x++) {
            // Get the tile info for this position
            int tileIdx = y * img.width + x;
            auto tileInfo = img.tiles[tileIdx];
            tilenum tileNum = tileInfo[2];
            color color1 = tileInfo[0];  // First color
            color color2 = tileInfo[1];  // Second color

            // Render the specific tile at the appropriate position in the output
            renderTileAtPositionWithConfig(tileNum, color1, color2, x * tileResolution, y * tileResolution,
                                         tileResolution, imageData, outputWidth, config);
        }
    }

    // Write the PPM file
    File file = File(outputFile, "wb");
    file.write(ppmHeader);
    file.rawWrite(imageData);
    file.close();

    writeln("Rendered baahouse image to ", outputFile);
    writeln("  Output size: ", outputWidth, "x", outputHeight);
    writeln("  Tile resolution: ", tileResolution, " pixels per tile");
    if (config.useHue) {
        writeln("  Using hue-based color interpretation");
    }
}

/**
 * Render a single tile at a specific position in the image data array
 */
void renderTileAtPosition(tilenum tileNum, color color1, color color2, 
                         int offsetX, int offsetY, int resolution, 
                         ref ubyte[] imageData, int outputWidth) {
    
    for (int ty = 0; ty < resolution; ty++) {
        for (int tx = 0; tx < resolution; tx++) {
            // Calculate normalized coordinates (0.0 to 1.0)
            float xf = cast(float)tx / (resolution - 1);
            float yf = cast(float)ty / (resolution - 1);
            
            // Evaluate the tile function
            bool tileResult;
            switch(tileNum) {
                case 0: tileResult = tile!(0)(xf, yf); break;
                case 1: tileResult = tile!(1)(xf, yf); break;
                case 2: tileResult = tile!(2)(xf, yf); break;
                case 3: tileResult = tile!(3)(xf, yf); break;
                case 4: tileResult = tile!(4)(xf, yf); break;
                case 5: tileResult = tile!(5)(xf, yf); break;
                case 6: tileResult = tile!(6)(xf, yf); break;
                case 7: tileResult = tile!(7)(xf, yf); break;
                case 8: tileResult = tile!(8)(xf, yf); break;
                case 9: tileResult = tile!(9)(xf, yf); break;
                case 10: tileResult = tile!(10)(xf, yf); break;
                case 11: tileResult = tile!(11)(xf, yf); break;
                case 12: tileResult = tile!(12)(xf, yf); break;
                case 13: tileResult = tile!(13)(xf, yf); break;
                case 14: tileResult = tile!(14)(xf, yf); break;
                case 15: tileResult = tile!(15)(xf, yf); break;
                case 16: tileResult = tile!(16)(xf, yf); break;
                case 17: tileResult = tile!(17)(xf, yf); break;
                case 18: tileResult = tile!(18)(xf, yf); break;
                case 19: tileResult = tile!(19)(xf, yf); break;
                case 20: tileResult = tile!(20)(xf, yf); break;
                case 21: tileResult = tile!(21)(xf, yf); break;
                case 22: tileResult = tile!(22)(xf, yf); break;
                case 23: tileResult = tile!(23)(xf, yf); break;
                case 24: tileResult = tile!(24)(xf, yf); break;
                case 25: tileResult = tile!(25)(xf, yf); break;
                case 26: tileResult = tile!(26)(xf, yf); break;
                case 27: tileResult = tile!(27)(xf, yf); break;
                case 28: tileResult = tile!(28)(xf, yf); break;
                case 29: tileResult = tile!(29)(xf, yf); break;
                case 30: tileResult = tile!(30)(xf, yf); break;
                case 31: tileResult = tile!(31)(xf, yf); break;
                case 32: tileResult = tile!(32)(xf, yf); break;
                case 33: tileResult = tile!(33)(xf, yf); break;
                case 34: tileResult = tile!(34)(xf, yf); break;
                case 35: tileResult = tile!(35)(xf, yf); break;
                case 36: tileResult = tile!(36)(xf, yf); break;
                case 37: tileResult = tile!(37)(xf, yf); break;
                case 38: tileResult = tile!(38)(xf, yf); break;
                case 39: tileResult = tile!(39)(xf, yf); break;
                case 40: tileResult = tile!(40)(xf, yf); break;
                case 41: tileResult = tile!(41)(xf, yf); break;
                case 42: tileResult = tile!(42)(xf, yf); break;
                case 43: tileResult = tile!(43)(xf, yf); break;
                case 44: tileResult = tile!(44)(xf, yf); break;
                case 45: tileResult = tile!(45)(xf, yf); break;
                case 46: tileResult = tile!(46)(xf, yf); break;
                case 47: tileResult = tile!(47)(xf, yf); break;
                case 48: tileResult = tile!(48)(xf, yf); break;
                case 49: tileResult = tile!(49)(xf, yf); break;
                case 50: tileResult = tile!(50)(xf, yf); break;
                case 51: tileResult = tile!(51)(xf, yf); break;
                case 52: tileResult = tile!(52)(xf, yf); break;
                case 53: tileResult = tile!(53)(xf, yf); break;
                case 54: tileResult = tile!(54)(xf, yf); break;
                case 55: tileResult = tile!(55)(xf, yf); break;
                case 56: tileResult = tile!(56)(xf, yf); break;
                case 57: tileResult = tile!(57)(xf, yf); break;
                case 58: tileResult = tile!(58)(xf, yf); break;
                case 59: tileResult = tile!(59)(xf, yf); break;
                case 60: tileResult = tile!(60)(xf, yf); break;
                case 61: tileResult = tile!(61)(xf, yf); break;
                case 62: tileResult = tile!(62)(xf, yf); break;
                case 63: tileResult = tile!(63)(xf, yf); break;
                case 64: tileResult = tile!(64)(xf, yf); break;
                case 65: tileResult = tile!(65)(xf, yf); break;
                case 66: tileResult = tile!(66)(xf, yf); break;
                case 67: tileResult = tile!(67)(xf, yf); break;
                case 68: tileResult = tile!(68)(xf, yf); break;
                case 69: tileResult = tile!(69)(xf, yf); break;
                case 70: tileResult = tile!(70)(xf, yf); break;
                case 71: tileResult = tile!(71)(xf, yf); break;
                case 72: tileResult = tile!(72)(xf, yf); break;
                case 73: tileResult = tile!(73)(xf, yf); break;
                case 74: tileResult = tile!(74)(xf, yf); break;
                case 75: tileResult = tile!(75)(xf, yf); break;
                case 76: tileResult = tile!(76)(xf, yf); break;
                case 77: tileResult = tile!(77)(xf, yf); break;
                case 78: tileResult = tile!(78)(xf, yf); break;
                case 79: tileResult = tile!(79)(xf, yf); break;
                case 80: tileResult = tile!(80)(xf, yf); break;
                case 81: tileResult = tile!(81)(xf, yf); break;
                case 82: tileResult = tile!(82)(xf, yf); break;
                case 83: tileResult = tile!(83)(xf, yf); break;
                case 84: tileResult = tile!(84)(xf, yf); break;
                case 85: tileResult = tile!(85)(xf, yf); break;
                case 86: tileResult = tile!(86)(xf, yf); break;
                case 87: tileResult = tile!(87)(xf, yf); break;
                case 88: tileResult = tile!(88)(xf, yf); break;
                case 89: tileResult = tile!(89)(xf, yf); break;
                case 90: tileResult = tile!(90)(xf, yf); break;
                case 91: tileResult = tile!(91)(xf, yf); break;
                case 92: tileResult = tile!(92)(xf, yf); break;
                case 93: tileResult = tile!(93)(xf, yf); break;
                case 94: tileResult = tile!(94)(xf, yf); break;
                case 95: tileResult = tile!(95)(xf, yf); break;
                case 96: tileResult = tile!(96)(xf, yf); break;
                case 97: tileResult = tile!(97)(xf, yf); break;
                case 98: tileResult = tile!(98)(xf, yf); break;
                case 99: tileResult = tile!(99)(xf, yf); break;
                case 100: tileResult = tile!(100)(xf, yf); break;
                case 101: tileResult = tile!(101)(xf, yf); break;
                case 102: tileResult = tile!(102)(xf, yf); break;
                case 103: tileResult = tile!(103)(xf, yf); break;
                case 104: tileResult = tile!(104)(xf, yf); break;
                case 105: tileResult = tile!(105)(xf, yf); break;
                case 106: tileResult = tile!(106)(xf, yf); break;
                case 107: tileResult = tile!(107)(xf, yf); break;
                case 108: tileResult = tile!(108)(xf, yf); break;
                case 109: tileResult = tile!(109)(xf, yf); break;
                case 110: tileResult = tile!(110)(xf, yf); break;
                case 111: tileResult = tile!(111)(xf, yf); break;
                case 112: tileResult = tile!(112)(xf, yf); break;
                case 113: tileResult = tile!(113)(xf, yf); break;
                case 114: tileResult = tile!(114)(xf, yf); break;
                case 115: tileResult = tile!(115)(xf, yf); break;
                case 116: tileResult = tile!(116)(xf, yf); break;
                case 117: tileResult = tile!(117)(xf, yf); break;
                case 118: tileResult = tile!(118)(xf, yf); break;
                case 119: tileResult = tile!(119)(xf, yf); break;
                case 120: tileResult = tile!(120)(xf, yf); break;
                case 121: tileResult = tile!(121)(xf, yf); break;
                case 122: tileResult = tile!(122)(xf, yf); break;
                case 123: tileResult = tile!(123)(xf, yf); break;
                case 124: tileResult = tile!(124)(xf, yf); break;
                case 125: tileResult = tile!(125)(xf, yf); break;
                case 126: tileResult = tile!(126)(xf, yf); break;
                case 127: tileResult = tile!(127)(xf, yf); break;
                case 128: tileResult = tile!(128)(xf, yf); break;
                case 129: tileResult = tile!(129)(xf, yf); break;
                case 130: tileResult = tile!(130)(xf, yf); break;
                case 131: tileResult = tile!(131)(xf, yf); break;
                case 132: tileResult = tile!(132)(xf, yf); break;
                case 133: tileResult = tile!(133)(xf, yf); break;
                case 134: tileResult = tile!(134)(xf, yf); break;
                case 135: tileResult = tile!(135)(xf, yf); break;
                case 136: tileResult = tile!(136)(xf, yf); break;
                case 137: tileResult = tile!(137)(xf, yf); break;
                case 138: tileResult = tile!(138)(xf, yf); break;
                case 139: tileResult = tile!(139)(xf, yf); break;
                case 140: tileResult = tile!(140)(xf, yf); break;
                case 141: tileResult = tile!(141)(xf, yf); break;
                case 142: tileResult = tile!(142)(xf, yf); break;
                case 143: tileResult = tile!(143)(xf, yf); break;
                case 144: tileResult = tile!(144)(xf, yf); break;
                case 145: tileResult = tile!(145)(xf, yf); break;
                case 146: tileResult = tile!(146)(xf, yf); break;
                case 147: tileResult = tile!(147)(xf, yf); break;
                case 148: tileResult = tile!(148)(xf, yf); break;
                case 149: tileResult = tile!(149)(xf, yf); break;
                case 150: tileResult = tile!(150)(xf, yf); break;
                case 151: tileResult = tile!(151)(xf, yf); break;
                case 152: tileResult = tile!(152)(xf, yf); break;
                case 153: tileResult = tile!(153)(xf, yf); break;
                case 154: tileResult = tile!(154)(xf, yf); break;
                case 155: tileResult = tile!(155)(xf, yf); break;
                case 156: tileResult = tile!(156)(xf, yf); break;
                case 157: tileResult = tile!(157)(xf, yf); break;
                case 158: tileResult = tile!(158)(xf, yf); break;
                case 159: tileResult = tile!(159)(xf, yf); break;
                case 160: tileResult = tile!(160)(xf, yf); break;
                case 161: tileResult = tile!(161)(xf, yf); break;
                case 162: tileResult = tile!(162)(xf, yf); break;
                case 163: tileResult = tile!(163)(xf, yf); break;
                case 164: tileResult = tile!(164)(xf, yf); break;
                case 165: tileResult = tile!(165)(xf, yf); break;
                case 166: tileResult = tile!(166)(xf, yf); break;
                case 167: tileResult = tile!(167)(xf, yf); break;
                case 168: tileResult = tile!(168)(xf, yf); break;
                case 169: tileResult = tile!(169)(xf, yf); break;
                case 170: tileResult = tile!(170)(xf, yf); break;
                case 171: tileResult = tile!(171)(xf, yf); break;
                case 172: tileResult = tile!(172)(xf, yf); break;
                case 173: tileResult = tile!(173)(xf, yf); break;
                case 174: tileResult = tile!(174)(xf, yf); break;
                case 175: tileResult = tile!(175)(xf, yf); break;
                case 176: tileResult = tile!(176)(xf, yf); break;
                case 177: tileResult = tile!(177)(xf, yf); break;
                case 178: tileResult = tile!(178)(xf, yf); break;
                case 179: tileResult = tile!(179)(xf, yf); break;
                case 180: tileResult = tile!(180)(xf, yf); break;
                case 181: tileResult = tile!(181)(xf, yf); break;
                case 182: tileResult = tile!(182)(xf, yf); break;
                case 183: tileResult = tile!(183)(xf, yf); break;
                case 184: tileResult = tile!(184)(xf, yf); break;
                case 185: tileResult = tile!(185)(xf, yf); break;
                case 186: tileResult = tile!(186)(xf, yf); break;
                case 187: tileResult = tile!(187)(xf, yf); break;
                case 188: tileResult = tile!(188)(xf, yf); break;
                case 189: tileResult = tile!(189)(xf, yf); break;
                case 190: tileResult = tile!(190)(xf, yf); break;
                case 191: tileResult = tile!(191)(xf, yf); break;
                case 192: tileResult = tile!(192)(xf, yf); break;
                case 193: tileResult = tile!(193)(xf, yf); break;
                case 194: tileResult = tile!(194)(xf, yf); break;
                case 195: tileResult = tile!(195)(xf, yf); break;
                case 196: tileResult = tile!(196)(xf, yf); break;
                case 197: tileResult = tile!(197)(xf, yf); break;
                case 198: tileResult = tile!(198)(xf, yf); break;
                case 199: tileResult = tile!(199)(xf, yf); break;
                case 200: tileResult = tile!(200)(xf, yf); break;
                case 201: tileResult = tile!(201)(xf, yf); break;
                case 202: tileResult = tile!(202)(xf, yf); break;
                case 203: tileResult = tile!(203)(xf, yf); break;
                case 204: tileResult = tile!(204)(xf, yf); break;
                case 205: tileResult = tile!(205)(xf, yf); break;
                case 206: tileResult = tile!(206)(xf, yf); break;
                case 207: tileResult = tile!(207)(xf, yf); break;
                case 208: tileResult = tile!(208)(xf, yf); break;
                case 209: tileResult = tile!(209)(xf, yf); break;
                case 210: tileResult = tile!(210)(xf, yf); break;
                case 211: tileResult = tile!(211)(xf, yf); break;
                case 212: tileResult = tile!(212)(xf, yf); break;
                case 213: tileResult = tile!(213)(xf, yf); break;
                case 214: tileResult = tile!(214)(xf, yf); break;
                case 215: tileResult = tile!(215)(xf, yf); break;
                case 216: tileResult = tile!(216)(xf, yf); break;
                case 217: tileResult = tile!(217)(xf, yf); break;
                case 218: tileResult = tile!(218)(xf, yf); break;
                case 219: tileResult = tile!(219)(xf, yf); break;
                case 220: tileResult = tile!(220)(xf, yf); break;
                case 221: tileResult = tile!(221)(xf, yf); break;
                case 222: tileResult = tile!(222)(xf, yf); break;
                case 223: tileResult = tile!(223)(xf, yf); break;
                case 224: tileResult = tile!(224)(xf, yf); break;
                case 225: tileResult = tile!(225)(xf, yf); break;
                case 226: tileResult = tile!(226)(xf, yf); break;
                case 227: tileResult = tile!(227)(xf, yf); break;
                case 228: tileResult = tile!(228)(xf, yf); break;
                case 229: tileResult = tile!(229)(xf, yf); break;
                case 230: tileResult = tile!(230)(xf, yf); break;
                case 231: tileResult = tile!(231)(xf, yf); break;
                case 232: tileResult = tile!(232)(xf, yf); break;
                case 233: tileResult = tile!(233)(xf, yf); break;
                case 234: tileResult = tile!(234)(xf, yf); break;
                case 235: tileResult = tile!(235)(xf, yf); break;
                case 236: tileResult = tile!(236)(xf, yf); break;
                case 237: tileResult = tile!(237)(xf, yf); break;
                case 238: tileResult = tile!(238)(xf, yf); break;
                case 239: tileResult = tile!(239)(xf, yf); break;
                case 240: tileResult = tile!(240)(xf, yf); break;
                case 241: tileResult = tile!(241)(xf, yf); break;
                case 242: tileResult = tile!(242)(xf, yf); break;
                case 243: tileResult = tile!(243)(xf, yf); break;
                case 244: tileResult = tile!(244)(xf, yf); break;
                case 245: tileResult = tile!(245)(xf, yf); break;
                case 246: tileResult = tile!(246)(xf, yf); break;
                case 247: tileResult = tile!(247)(xf, yf); break;
                case 248: tileResult = tile!(248)(xf, yf); break;
                case 249: tileResult = tile!(249)(xf, yf); break;
                default: tileResult = false;  // Default to false for undefined tiles
            }
            
            // Determine pixel color based on tile result
            color pixelColor = tileResult ? color1 : color2;
            
            // Calculate pixel index in the image data array
            int pixelX = offsetX + tx;
            int pixelY = offsetY + ty;
            size_t pixelIdx = (pixelY * outputWidth + pixelX) * 3;
            
            // Set RGB values (for simplicity, using grayscale from the color value)
            imageData[pixelIdx] = pixelColor;     // Red
            imageData[pixelIdx + 1] = pixelColor; // Green
            imageData[pixelIdx + 2] = pixelColor; // Blue
        }
    }
}

/**
 * Render a single tile at a specific position in the image data array with config
 */
void renderTileAtPositionWithConfig(tilenum tileNum, color color1, color color2,
                         int offsetX, int offsetY, int resolution,
                         ref ubyte[] imageData, int outputWidth, PaletteConfig config) {

    for (int ty = 0; ty < resolution; ty++) {
        for (int tx = 0; tx < resolution; tx++) {
            // Calculate normalized coordinates (0.0 to 1.0)
            float xf = cast(float)tx / (resolution - 1);
            float yf = cast(float)ty / (resolution - 1);

            // Evaluate the tile function
            bool tileResult;
            switch(tileNum) {
                case 0: tileResult = tile!(0)(xf, yf); break;
                case 1: tileResult = tile!(1)(xf, yf); break;
                case 2: tileResult = tile!(2)(xf, yf); break;
                case 3: tileResult = tile!(3)(xf, yf); break;
                case 4: tileResult = tile!(4)(xf, yf); break;
                case 5: tileResult = tile!(5)(xf, yf); break;
                case 6: tileResult = tile!(6)(xf, yf); break;
                case 7: tileResult = tile!(7)(xf, yf); break;
                case 8: tileResult = tile!(8)(xf, yf); break;
                case 9: tileResult = tile!(9)(xf, yf); break;
                case 10: tileResult = tile!(10)(xf, yf); break;
                case 11: tileResult = tile!(11)(xf, yf); break;
                case 12: tileResult = tile!(12)(xf, yf); break;
                case 13: tileResult = tile!(13)(xf, yf); break;
                case 14: tileResult = tile!(14)(xf, yf); break;
                case 15: tileResult = tile!(15)(xf, yf); break;
                case 16: tileResult = tile!(16)(xf, yf); break;
                case 17: tileResult = tile!(17)(xf, yf); break;
                case 18: tileResult = tile!(18)(xf, yf); break;
                case 19: tileResult = tile!(19)(xf, yf); break;
                case 20: tileResult = tile!(20)(xf, yf); break;
                case 21: tileResult = tile!(21)(xf, yf); break;
                case 22: tileResult = tile!(22)(xf, yf); break;
                case 23: tileResult = tile!(23)(xf, yf); break;
                case 24: tileResult = tile!(24)(xf, yf); break;
                case 25: tileResult = tile!(25)(xf, yf); break;
                case 26: tileResult = tile!(26)(xf, yf); break;
                case 27: tileResult = tile!(27)(xf, yf); break;
                case 28: tileResult = tile!(28)(xf, yf); break;
                case 29: tileResult = tile!(29)(xf, yf); break;
                case 30: tileResult = tile!(30)(xf, yf); break;
                case 31: tileResult = tile!(31)(xf, yf); break;
                case 32: tileResult = tile!(32)(xf, yf); break;
                case 33: tileResult = tile!(33)(xf, yf); break;
                case 34: tileResult = tile!(34)(xf, yf); break;
                case 35: tileResult = tile!(35)(xf, yf); break;
                case 36: tileResult = tile!(36)(xf, yf); break;
                case 37: tileResult = tile!(37)(xf, yf); break;
                case 38: tileResult = tile!(38)(xf, yf); break;
                case 39: tileResult = tile!(39)(xf, yf); break;
                case 40: tileResult = tile!(40)(xf, yf); break;
                case 41: tileResult = tile!(41)(xf, yf); break;
                case 42: tileResult = tile!(42)(xf, yf); break;
                case 43: tileResult = tile!(43)(xf, yf); break;
                case 44: tileResult = tile!(44)(xf, yf); break;
                case 45: tileResult = tile!(45)(xf, yf); break;
                case 46: tileResult = tile!(46)(xf, yf); break;
                case 47: tileResult = tile!(47)(xf, yf); break;
                case 48: tileResult = tile!(48)(xf, yf); break;
                case 49: tileResult = tile!(49)(xf, yf); break;
                case 50: tileResult = tile!(50)(xf, yf); break;
                case 51: tileResult = tile!(51)(xf, yf); break;
                case 52: tileResult = tile!(52)(xf, yf); break;
                case 53: tileResult = tile!(53)(xf, yf); break;
                case 54: tileResult = tile!(54)(xf, yf); break;
                case 55: tileResult = tile!(55)(xf, yf); break;
                case 56: tileResult = tile!(56)(xf, yf); break;
                case 57: tileResult = tile!(57)(xf, yf); break;
                case 58: tileResult = tile!(58)(xf, yf); break;
                case 59: tileResult = tile!(59)(xf, yf); break;
                case 60: tileResult = tile!(60)(xf, yf); break;
                case 61: tileResult = tile!(61)(xf, yf); break;
                case 62: tileResult = tile!(62)(xf, yf); break;
                case 63: tileResult = tile!(63)(xf, yf); break;
                case 64: tileResult = tile!(64)(xf, yf); break;
                case 65: tileResult = tile!(65)(xf, yf); break;
                case 66: tileResult = tile!(66)(xf, yf); break;
                case 67: tileResult = tile!(67)(xf, yf); break;
                case 68: tileResult = tile!(68)(xf, yf); break;
                case 69: tileResult = tile!(69)(xf, yf); break;
                case 70: tileResult = tile!(70)(xf, yf); break;
                case 71: tileResult = tile!(71)(xf, yf); break;
                case 72: tileResult = tile!(72)(xf, yf); break;
                case 73: tileResult = tile!(73)(xf, yf); break;
                case 74: tileResult = tile!(74)(xf, yf); break;
                case 75: tileResult = tile!(75)(xf, yf); break;
                case 76: tileResult = tile!(76)(xf, yf); break;
                case 77: tileResult = tile!(77)(xf, yf); break;
                case 78: tileResult = tile!(78)(xf, yf); break;
                case 79: tileResult = tile!(79)(xf, yf); break;
                case 80: tileResult = tile!(80)(xf, yf); break;
                case 81: tileResult = tile!(81)(xf, yf); break;
                case 82: tileResult = tile!(82)(xf, yf); break;
                case 83: tileResult = tile!(83)(xf, yf); break;
                case 84: tileResult = tile!(84)(xf, yf); break;
                case 85: tileResult = tile!(85)(xf, yf); break;
                case 86: tileResult = tile!(86)(xf, yf); break;
                case 87: tileResult = tile!(87)(xf, yf); break;
                case 88: tileResult = tile!(88)(xf, yf); break;
                case 89: tileResult = tile!(89)(xf, yf); break;
                case 90: tileResult = tile!(90)(xf, yf); break;
                case 91: tileResult = tile!(91)(xf, yf); break;
                case 92: tileResult = tile!(92)(xf, yf); break;
                case 93: tileResult = tile!(93)(xf, yf); break;
                case 94: tileResult = tile!(94)(xf, yf); break;
                case 95: tileResult = tile!(95)(xf, yf); break;
                case 96: tileResult = tile!(96)(xf, yf); break;
                case 97: tileResult = tile!(97)(xf, yf); break;
                case 98: tileResult = tile!(98)(xf, yf); break;
                case 99: tileResult = tile!(99)(xf, yf); break;
                case 100: tileResult = tile!(100)(xf, yf); break;
                case 101: tileResult = tile!(101)(xf, yf); break;
                case 102: tileResult = tile!(102)(xf, yf); break;
                case 103: tileResult = tile!(103)(xf, yf); break;
                case 104: tileResult = tile!(104)(xf, yf); break;
                case 105: tileResult = tile!(105)(xf, yf); break;
                case 106: tileResult = tile!(106)(xf, yf); break;
                case 107: tileResult = tile!(107)(xf, yf); break;
                case 108: tileResult = tile!(108)(xf, yf); break;
                case 109: tileResult = tile!(109)(xf, yf); break;
                case 110: tileResult = tile!(110)(xf, yf); break;
                case 111: tileResult = tile!(111)(xf, yf); break;
                case 112: tileResult = tile!(112)(xf, yf); break;
                case 113: tileResult = tile!(113)(xf, yf); break;
                case 114: tileResult = tile!(114)(xf, yf); break;
                case 115: tileResult = tile!(115)(xf, yf); break;
                case 116: tileResult = tile!(116)(xf, yf); break;
                case 117: tileResult = tile!(117)(xf, yf); break;
                case 118: tileResult = tile!(118)(xf, yf); break;
                case 119: tileResult = tile!(119)(xf, yf); break;
                case 120: tileResult = tile!(120)(xf, yf); break;
                case 121: tileResult = tile!(121)(xf, yf); break;
                case 122: tileResult = tile!(122)(xf, yf); break;
                case 123: tileResult = tile!(123)(xf, yf); break;
                case 124: tileResult = tile!(124)(xf, yf); break;
                case 125: tileResult = tile!(125)(xf, yf); break;
                case 126: tileResult = tile!(126)(xf, yf); break;
                case 127: tileResult = tile!(127)(xf, yf); break;
                case 128: tileResult = tile!(128)(xf, yf); break;
                case 129: tileResult = tile!(129)(xf, yf); break;
                case 130: tileResult = tile!(130)(xf, yf); break;
                case 131: tileResult = tile!(131)(xf, yf); break;
                case 132: tileResult = tile!(132)(xf, yf); break;
                case 133: tileResult = tile!(133)(xf, yf); break;
                case 134: tileResult = tile!(134)(xf, yf); break;
                case 135: tileResult = tile!(135)(xf, yf); break;
                case 136: tileResult = tile!(136)(xf, yf); break;
                case 137: tileResult = tile!(137)(xf, yf); break;
                case 138: tileResult = tile!(138)(xf, yf); break;
                case 139: tileResult = tile!(139)(xf, yf); break;
                case 140: tileResult = tile!(140)(xf, yf); break;
                case 141: tileResult = tile!(141)(xf, yf); break;
                case 142: tileResult = tile!(142)(xf, yf); break;
                case 143: tileResult = tile!(143)(xf, yf); break;
                case 144: tileResult = tile!(144)(xf, yf); break;
                case 145: tileResult = tile!(145)(xf, yf); break;
                case 146: tileResult = tile!(146)(xf, yf); break;
                case 147: tileResult = tile!(147)(xf, yf); break;
                case 148: tileResult = tile!(148)(xf, yf); break;
                case 149: tileResult = tile!(149)(xf, yf); break;
                case 150: tileResult = tile!(150)(xf, yf); break;
                case 151: tileResult = tile!(151)(xf, yf); break;
                case 152: tileResult = tile!(152)(xf, yf); break;
                case 153: tileResult = tile!(153)(xf, yf); break;
                case 154: tileResult = tile!(154)(xf, yf); break;
                case 155: tileResult = tile!(155)(xf, yf); break;
                case 156: tileResult = tile!(156)(xf, yf); break;
                case 157: tileResult = tile!(157)(xf, yf); break;
                case 158: tileResult = tile!(158)(xf, yf); break;
                case 159: tileResult = tile!(159)(xf, yf); break;
                case 160: tileResult = tile!(160)(xf, yf); break;
                case 161: tileResult = tile!(161)(xf, yf); break;
                case 162: tileResult = tile!(162)(xf, yf); break;
                case 163: tileResult = tile!(163)(xf, yf); break;
                case 164: tileResult = tile!(164)(xf, yf); break;
                case 165: tileResult = tile!(165)(xf, yf); break;
                case 166: tileResult = tile!(166)(xf, yf); break;
                case 167: tileResult = tile!(167)(xf, yf); break;
                case 168: tileResult = tile!(168)(xf, yf); break;
                case 169: tileResult = tile!(169)(xf, yf); break;
                case 170: tileResult = tile!(170)(xf, yf); break;
                case 171: tileResult = tile!(171)(xf, yf); break;
                case 172: tileResult = tile!(172)(xf, yf); break;
                case 173: tileResult = tile!(173)(xf, yf); break;
                case 174: tileResult = tile!(174)(xf, yf); break;
                case 175: tileResult = tile!(175)(xf, yf); break;
                case 176: tileResult = tile!(176)(xf, yf); break;
                case 177: tileResult = tile!(177)(xf, yf); break;
                case 178: tileResult = tile!(178)(xf, yf); break;
                case 179: tileResult = tile!(179)(xf, yf); break;
                case 180: tileResult = tile!(180)(xf, yf); break;
                case 181: tileResult = tile!(181)(xf, yf); break;
                case 182: tileResult = tile!(182)(xf, yf); break;
                case 183: tileResult = tile!(183)(xf, yf); break;
                case 184: tileResult = tile!(184)(xf, yf); break;
                case 185: tileResult = tile!(185)(xf, yf); break;
                case 186: tileResult = tile!(186)(xf, yf); break;
                case 187: tileResult = tile!(187)(xf, yf); break;
                case 188: tileResult = tile!(188)(xf, yf); break;
                case 189: tileResult = tile!(189)(xf, yf); break;
                case 190: tileResult = tile!(190)(xf, yf); break;
                case 191: tileResult = tile!(191)(xf, yf); break;
                case 192: tileResult = tile!(192)(xf, yf); break;
                case 193: tileResult = tile!(193)(xf, yf); break;
                case 194: tileResult = tile!(194)(xf, yf); break;
                case 195: tileResult = tile!(195)(xf, yf); break;
                case 196: tileResult = tile!(196)(xf, yf); break;
                case 197: tileResult = tile!(197)(xf, yf); break;
                case 198: tileResult = tile!(198)(xf, yf); break;
                case 199: tileResult = tile!(199)(xf, yf); break;
                case 200: tileResult = tile!(200)(xf, yf); break;
                case 201: tileResult = tile!(201)(xf, yf); break;
                case 202: tileResult = tile!(202)(xf, yf); break;
                case 203: tileResult = tile!(203)(xf, yf); break;
                case 204: tileResult = tile!(204)(xf, yf); break;
                case 205: tileResult = tile!(205)(xf, yf); break;
                case 206: tileResult = tile!(206)(xf, yf); break;
                case 207: tileResult = tile!(207)(xf, yf); break;
                case 208: tileResult = tile!(208)(xf, yf); break;
                case 209: tileResult = tile!(209)(xf, yf); break;
                case 210: tileResult = tile!(210)(xf, yf); break;
                case 211: tileResult = tile!(211)(xf, yf); break;
                case 212: tileResult = tile!(212)(xf, yf); break;
                case 213: tileResult = tile!(213)(xf, yf); break;
                case 214: tileResult = tile!(214)(xf, yf); break;
                case 215: tileResult = tile!(215)(xf, yf); break;
                case 216: tileResult = tile!(216)(xf, yf); break;
                case 217: tileResult = tile!(217)(xf, yf); break;
                case 218: tileResult = tile!(218)(xf, yf); break;
                case 219: tileResult = tile!(219)(xf, yf); break;
                case 220: tileResult = tile!(220)(xf, yf); break;
                case 221: tileResult = tile!(221)(xf, yf); break;
                case 222: tileResult = tile!(222)(xf, yf); break;
                case 223: tileResult = tile!(223)(xf, yf); break;
                case 224: tileResult = tile!(224)(xf, yf); break;
                case 225: tileResult = tile!(225)(xf, yf); break;
                case 226: tileResult = tile!(226)(xf, yf); break;
                case 227: tileResult = tile!(227)(xf, yf); break;
                case 228: tileResult = tile!(228)(xf, yf); break;
                case 229: tileResult = tile!(229)(xf, yf); break;
                case 230: tileResult = tile!(230)(xf, yf); break;
                case 231: tileResult = tile!(231)(xf, yf); break;
                case 232: tileResult = tile!(232)(xf, yf); break;
                case 233: tileResult = tile!(233)(xf, yf); break;
                case 234: tileResult = tile!(234)(xf, yf); break;
                case 235: tileResult = tile!(235)(xf, yf); break;
                case 236: tileResult = tile!(236)(xf, yf); break;
                case 237: tileResult = tile!(237)(xf, yf); break;
                case 238: tileResult = tile!(238)(xf, yf); break;
                case 239: tileResult = tile!(239)(xf, yf); break;
                case 240: tileResult = tile!(240)(xf, yf); break;
                case 241: tileResult = tile!(241)(xf, yf); break;
                case 242: tileResult = tile!(242)(xf, yf); break;
                case 243: tileResult = tile!(243)(xf, yf); break;
                case 244: tileResult = tile!(244)(xf, yf); break;
                case 245: tileResult = tile!(245)(xf, yf); break;
                case 246: tileResult = tile!(246)(xf, yf); break;
                case 247: tileResult = tile!(247)(xf, yf); break;
                case 248: tileResult = tile!(248)(xf, yf); break;
                case 249: tileResult = tile!(249)(xf, yf); break;
                default: tileResult = false;  // Default to false for undefined tiles
            }

            // Determine pixel color based on tile result
            color pixelColor = tileResult ? color1 : color2;

            // Calculate pixel index in the image data array
            int pixelX = offsetX + tx;
            int pixelY = offsetY + ty;
            size_t pixelIdx = (pixelY * outputWidth + pixelX) * 3;

            // Set RGB values based on configuration
            ubyte[3] rgbColor = grayscaleToRGB(pixelColor, config.useHue);
            imageData[pixelIdx] = rgbColor[0];     // Red
            imageData[pixelIdx + 1] = rgbColor[1]; // Green
            imageData[pixelIdx + 2] = rgbColor[2]; // Blue
        }
    }
}

struct PaletteConfig {
    string type = "grayscale"; // grayscale, rgb, or custom
    bool useHue = false;       // interpret color values as hues
    ubyte defaultColor1 = 255; // default first color (white)
    ubyte defaultColor2 = 0;   // default second color (black)
}

/**
 * Parse color from string in format R,G,B where each is 0-255
 */
ubyte[3] parseColor(string colorStr) {
    string[] parts = split(colorStr, ",");
    if (parts.length != 3) {
        throw new Exception("Invalid color format. Expected R,G,B");
    }

    ubyte[3] color;
    color[0] = to!ubyte(parts[0]);
    color[1] = to!ubyte(parts[1]);
    color[2] = to!ubyte(parts[2]);

    return color;
}

/**
 * Convert grayscale to RGB with optional hue interpretation
 */
ubyte[3] grayscaleToRGB(ubyte gray, bool useHue = false) {
    if (useHue) {
        // Convert grayscale value to a hue in the HSV color space, then to RGB
        // This creates a colorful interpretation of the grayscale value
        float h = (cast(float)gray / 255.0) * 360.0; // Hue from 0-360
        float s = 1.0;  // Full saturation
        float v = 1.0;  // Full value

        // Convert HSV to RGB (simplified)
        int hi = cast(int)(h / 60) % 6;
        float f = h / 60 - cast(int)(h / 60);
        float p = v * (1 - s);
        float q = v * (1 - f * s);
        float t = v * (1 - (1 - f) * s);

        float r, g, b;
        if (hi == 0) { r = v; g = t; b = p; }
        else if (hi == 1) { r = q; g = v; b = p; }
        else if (hi == 2) { r = p; g = v; b = t; }
        else if (hi == 3) { r = p; g = q; b = v; }
        else if (hi == 4) { r = t; g = p; b = v; }
        else { r = v; g = p; b = q; }

        ubyte[3] result;
        result[0] = cast(ubyte)(r * 255);
        result[1] = cast(ubyte)(g * 255);
        result[2] = cast(ubyte)(b * 255);
        return result;
    } else {
        // Standard grayscale - same value for R, G, B
        ubyte[3] result;
        result[0] = gray;
        result[1] = gray;
        result[2] = gray;
        return result;
    }
}

int main(string[] args) {
    if (args.length < 2) {
        writeln("Usage: ", args[0], " <input.emoji_extension> [options]");
        writeln("Options:");
        writeln("  -o, --output FILE        Output PPM file (default: rendered_image.ppm)");
        writeln("  -r, --resolution N       Pixels per tile (default: 8)");
        writeln("  --palette TYPE           Palette type: grayscale, colorful (default: grayscale)");
        writeln("  --color1 R,G,B           First color RGB values (default: 255,255,255 - white)");
        writeln("  --color2 R,G,B           Second color RGB values (default: 0,0,0 - black)");
        writeln("  --use-hue                Interpret grayscale values as hues for colorful output");
        writeln("");
        writeln("Examples:");
        writeln("  ", args[0], " input.emoji");
        writeln("  ", args[0], " input.emoji -o output.ppm -r 16 --palette colorful");
        writeln("  ", args[0], " input.emoji --color1 255,100,100 --color2 50,50,200");
        writeln("  ", args[0], " input.emoji --use-hue");
        writeln("  (Official extensions: .🐑 🏠 or .baahouse for legacy systems)");
        return 1;
    }

    string inputFile = args[1];
    string outputFile = "rendered_image.ppm";
    int tileResolution = 8;
    PaletteConfig config;

    // Parse command line arguments
    for (int i = 2; i < args.length; i++) {
        string arg = args[i];
        if (arg == "-o" || arg == "--output") {
            if (i + 1 < args.length) {
                outputFile = args[++i];
            } else {
                writeln("Error: --output requires a filename");
                return 1;
            }
        } else if (arg == "-r" || arg == "--resolution") {
            if (i + 1 < args.length) {
                tileResolution = to!int(args[++i]);
            } else {
                writeln("Error: --resolution requires a value");
                return 1;
            }
        } else if (arg == "--palette") {
            if (i + 1 < args.length) {
                string paletteType = args[++i];
                if (paletteType == "grayscale") {
                    config.type = "grayscale";
                } else if (paletteType == "colorful") {
                    config.type = "colorful";
                    config.useHue = true;
                } else {
                    writeln("Error: Unknown palette type. Use 'grayscale' or 'colorful'");
                    return 1;
                }
            } else {
                writeln("Error: --palette requires a type");
                return 1;
            }
        } else if (arg == "--color1") {
            if (i + 1 < args.length) {
                try {
                    ubyte[3] color = parseColor(args[++i]);
                    // For our renderer, we'll use these as default colors if tile colors are not varied
                    config.defaultColor1 = color[0]; // We'll handle this in the render function
                } catch (Exception e) {
                    writeln("Error parsing color1: ", e.msg);
                    return 1;
                }
            } else {
                writeln("Error: --color1 requires R,G,B values");
                return 1;
            }
        } else if (arg == "--color2") {
            if (i + 1 < args.length) {
                try {
                    ubyte[3] color = parseColor(args[++i]);
                    config.defaultColor2 = color[0]; // We'll handle this in the render function
                } catch (Exception e) {
                    writeln("Error parsing color2: ", e.msg);
                    return 1;
                }
            } else {
                writeln("Error: --color2 requires R,G,B values");
                return 1;
            }
        } else if (arg == "--use-hue") {
            config.useHue = true;
        } else if (arg.startsWith("-")) {
            writeln("Error: Unknown option: ", arg);
            return 1;
        }
    }

    if (tileResolution <= 0) {
        writeln("Error: tile resolution must be positive");
        return 1;
    }

    // Load the baahouse image
    baaimage img = deserializeBaaImage(inputFile);
    writeln("Loaded baahouse image:");
    writeln("  Format: ", img.format);
    writeln("  Size: ", img.width, "x", img.height);
    writeln("  Tiles: ", img.tiles.length);
    writeln("Rendering with palette: ", config.type);

    // Render to PPM
    renderBaaImageWithConfig(img, outputFile, tileResolution, config);

    return 0;
}