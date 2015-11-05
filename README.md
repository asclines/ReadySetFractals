# Ready Set Fractals

Ready Set Fractals aims to create a simple way to design, generate, and explore Mandelbrot and Julia Set Fractals. By providing a simple yet extensive interface, this project aims to give the user a variety of options when it comes to generating a set fractal and exploring it. While not all of these goals have been met yet, they will be. Check out the features section below to see what is done and what is coming up.

## Features

### Current
- Generate julia set fractals
- Output image is a BMP image
- Image color can be B&W or RGB colors

### Future
- Generate mandlebrot fractals
- Be able to handle Multi-GPU
- Better way to get RGB colors
- Expand coloring to a HSV model to give more options for the coloring of the fractal
- A web interface / GUI for creating and viewing the fractals
- Multi-OS compatibility



## Requirements
Currently this project has only been testing on Linux systems, but work is being done to make it work on all systems. 
System Requirements:

 - CUDA 7.5
 - NVIDIA graphics card
 - NVCC and a C++ compiler (NVCC should come with CUDA 7.5)


## Installation

To install the standalone program to generate a fractal on a Linux machine, it is recommended to use the makefile included in the project. 
`make install` will install the program at which point it can be run with `./fractal`

## Usage
Open up **settings.txt** to change the fractal settings to meet your preferences. 
A detailed guide on the settings file is provided here:

##Libraries 
Here is a list of all external libraries used to make this program.

 - [CUDA Toolkit 7.5](https://developer.nvidia.com/cuda-toolkit)
 - [QDBMP (Quick and Dirty Bitmap)](http://qdbmp.sourceforge.net/)
 
## History

This project was initially a class assignment in a Mathematics course I took at Texas Tech University. The assignment was to write a program in CUDA that created a Julia Set Fractal image. I have since taken that assignment and extended its capabilities.

## Credits

My teacher for inspiring me to create this.

## License

See [LICENSE](https://github.com/asclines/ReadySetFractals/blob/master/LICENSE "MIT License")
