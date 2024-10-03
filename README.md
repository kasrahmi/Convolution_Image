# Convolution Image Processing Project

This project demonstrates **image convolution** using **assembly language**, applying various filters like sharpen, blur, and edge detection through kernel manipulation. The goal is to showcase how assembly-level operations can handle image processing tasks efficiently.

## Project Overview

The core of this project involves convolution operations, which are widely used in image processing for modifying pixel values based on neighboring pixels. Convolution is implemented using different kernels (or filters) to achieve various effects on images.

### Key Features

- **Convolution Filters**: Implements multiple convolution filters, including:
  - **Sharpen Filter**: Enhances the edges of objects in the image.
  - **Blur Filter**: Smooths the image by reducing noise and detail.
  - **Edge Detection**: Detects the boundaries within an image using a ridge filter.

- **Assembly Code**: This project is written in assembly language, focusing on:
  - **Low-level optimization**: Assembly allows fine control over hardware, ensuring efficient memory usage and performance.
  - **Matrix Operations**: Applies a 3x3 kernel (or custom sizes like 5x5) to the image matrix to process each pixel.

- **Performance Focused**: The project aims at providing fast computation by leveraging assembly's direct control over system resources.

## Project Structure

- **Kernel Definitions**: Located in `cross_normal.asm` and `cross_parallel.asm`, these files define the various filters.
- **Image Processing**: Assembly routines process input images pixel by pixel using the defined kernels.
- **Matrix Transpose**: A utility for efficient matrix manipulation during convolution.
- **Test Images**: Example images are provided to demonstrate the effects of each filter.

## How It Works

1. **Input**: The program takes an input image, reads it as a matrix of pixels.
2. **Kernel Application**: A 3x3 convolution kernel is applied to the image matrix.
3. **Output**: The transformed image is written out after the convolution operation.

## Example

- **Sharpen Kernel Example**:

```plaintext
0  -1  0
-1  5  -1
0  -1  0
```

## Benchmarks

Testing different filters shows significant performance benefits of assembly-level optimization over high-level languages. The time complexity for processing increases with image size, but assembly ensures minimal overhead.

| Filter         | Average Time (s) |
|----------------|------------------|
| Sharpen        | 0.378            |
| Blur           | 0.387            |
| Edge Detection | 0.453            |

## How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/kasrahmi/Convolution_Image.git
  ```

2. Compile the assembly code using NASM or your preferred assembler:
 ```bash
   nasm -f elf64 cross_normal.asm
  ```

3. Run the compiled code with the input image:
  ```bash
  ./convolution input_image.bmp
  ```
## Future Improvements

- Implement more complex filters (e.g., Gaussian blur).
- Extend kernel sizes for higher resolution effects.
- Add support for colored images (currently operates on grayscale).

## References

- [Convolution in Image Processing](https://en.wikipedia.org/wiki/Kernel_(image_processing))
- [Assembly Language Optimizations](https://en.wikipedia.org/wiki/Assembly_language)
