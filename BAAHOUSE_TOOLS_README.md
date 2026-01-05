# Baahouse Serializer/Deserializer, Random Image Generator, and Renderer

This package includes three essential tools for working with the baahouse image format:

## 1. Serializer/Deserializer Library

The `baahouse_serializer.d` provides functions to serialize and deserialize baahouse images according to the official format specification:
- Signature: `baa\n`
- Encoding: `ua16\n` (uncompressed alpha-set with 16 colors)
- Size info: `width height blob_length\n`
- Binary blob: 3 bytes per tile (2 colors + 1 tile number)

### Core Data Structure
```d
struct baaimage {
    string format = "ua16";
    int width;
    int height;
    alias tile = Tuple!(color, color, tilenum);
    tile[] tiles;
}
```

### Functions
- `serializeBaaImage(baaimage img, string filename)` - Serialize to .baa file
- `deserializeBaaImage(string filename)` - Deserialize from .baa file
- `createBaaImage(int width, int height, tilenum[] tileIds, color[2][] tileColors = null)` - Create from raw data

## 2. Random Image Generator

The `random_image_generator` tool creates random baahouse images for testing and experimentation.

### Usage
```
./random_image_generator <width> <height> [output_file.baa] [seed] [clustered]
```

### Options
- `width, height`: dimensions of the image
- `output_file`: output file name (default: random_image.baa)
- `seed`: random seed (default: 0 = random seed)
- `clustered`: use clustered pattern (default: false)

### Examples
```
./random_image_generator 8 8
./random_image_generator 16 16 my_image.baa 12345
./random_image_generator 10 10 clustered.baa 0 true
```

## 3. Baahouse Renderer

The `baahouse_renderer` tool converts baahouse images to PPM format for viewing.

### Usage
```
./baahouse_renderer <input.baa> [output.ppm] [tile_resolution]
```

### Options
- `input.baa`: input baahouse file
- `output.ppm`: output PPM file (default: rendered_image.ppm)
- `tile_resolution`: pixels per tile (default: 8)

### Examples
```
./baahouse_renderer my_image.baa
./baahouse_renderer my_image.baa output.ppm 16
```

## Format Specification Compliance

All tools strictly adhere to the baahouse format specification:
- Files start with `baa\n`
- Format line specifies encoding scheme
- Size line contains width, height, and binary blob length
- Binary blob contains 3 bytes per tile: 2 color values and 1 tile number

## Dependencies

- D compiler (dmd, gdc, or ldc)
- Standard D library (Phobos)
- common/alpha_tiles.d (for rendering)

## Example Workflow

1. Generate a random image:
   ```
   ./random_image_generator 16 16 example.baa
   ```

2. Render it to viewable format:
   ```
   ./baahouse_renderer example.baa example.ppm 16
   ```

3. The resulting PPM file can be viewed with most image viewers or converted to other formats.