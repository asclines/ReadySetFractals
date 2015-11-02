# NOTICE:
The project is not yet uploaded. Awaiting some final changes before being uploaded. 
Currently, only the README is here


---


# Ready Set Fractals

Ready Set Fractals aims to create a simple way to design, generate, and explore Mandelbrot and Julia Set Fractals. By providing a simple yet extensive interface, this project aims to give the user a variety of options when it comes to generating a set fractal and exploring it. 

## Features

### Current
- Generate julia set fractals
- Output image is a BMP image
- Image color can even be B&W or RGB colors

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
`make install` will install the program at which point it can be run with `./program`

## Usage
There are two ways to use this program. 

 1. You can just run the program with `./program`and follow the on screen instructions OR
 2. You can modify the **settings.txt** to have your fractal specifications there and feed them into the program like so `./program < settings.txt`

##Libraries 
Here is a list of all external libraries used to make this program.

 - [CUDA Toolkit 7.5](https://developer.nvidia.com/cuda-toolkit)
 - [QDBMP (Quick and Dirty Bitmap)](http://qdbmp.sourceforge.net/)
 
##Project TODO List
- [ ] Finalize settings input file
- [ ] Add CUDA error checking
- [ ] Adding Mandlebrot Set Fractals
- [ ] Add multi-GPU support
- [ ] Create GUI or Web Interface 

## History

This project was initially a class assignment in a Mathematics course I took at Texas Tech University. The assignment was to write a program in CUDA that created a Julia Set Fractal image. I have since taken that assignment and extended its capabilities.

## Credits

My teacher for inspiring me to create this.

## License

See [LICENSE](https://github.com/asclines/ReadySetFractals/blob/master/LICENSE "MIT License")
