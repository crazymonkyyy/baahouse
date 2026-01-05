# Baahouse Format Comparison

This page demonstrates the file size comparison between the baahouse format and various bitmap formats when rendering the same image to 512x512 pixels.

## File Size Comparison Table

| Format | File Extension | File Size | Description |
|--------|----------------|-----------|-------------|
| Baahouse | `.🐑 🏠` | 64 bytes | Vector-based tile definitions |
| Raw Bitmap | `.ppm` | 769 KB | Uncompressed 512×512×3 bytes per pixel |
| PNG | `.png` | 3.9 KB | Lossless compressed bitmap |
| JPEG | `.jpg` | 46 KB | Lossy compressed bitmap |

## Compression Efficiency

- **Baahouse vs Raw Bitmap**: The baahouse format is **12,000x smaller** than the raw bitmap
- **Baahouse vs JPEG**: The baahouse format is **~700x smaller** than JPEG
- **Baahouse vs PNG**: The baahouse format is **~60x smaller** than PNG

## Scalability Benefits

The baahouse format maintains constant file size regardless of render resolution. A 1000x1000 render would still be 64 bytes in .baahouse format but would be ~3MB in uncompressed PPM.

## Quality Preservation

- The baahouse format maintains perfect mathematical precision at any resolution
- Bitmap formats lose information upon compression (JPEG with lossy compression, PNG with lossless)

This comparison demonstrates the extraordinary compression efficiency of the baahouse format, which achieves orders of magnitude smaller file sizes while preserving perfect scalability and mathematical precision compared to traditional bitmap formats.