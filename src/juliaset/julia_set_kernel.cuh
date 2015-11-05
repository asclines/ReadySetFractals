#ifndef JULIA_SET_KERNEL_H
#define JULIA_SET_KERNEL_H

#include <cuda.h>
#include <cuComplex.h>

namespace julia_set_kernel{

typedef cuDoubleComplex Complex;
typedef unsigned int var;

struct JuliaSettings{
/* Julia Set Settings */
	//Size and transformation
	int w_pixels; //Width in pixels
	int h_pixels; //Height in pixels
	double xy_radius; //Radius of the graph in points
	double x_offset; //Offset the graph in the x direction in points
	double y_offset; //Offset the graph in the y direction in points
	
	//Fractal equation
	int max_iterations;//Maximum number of iterations that the fractal equation should run
	Complex complex_constant; //Constant used in the fractal equation
	int escape_range;//Deciding point on whether or not a point escapes
};

struct SetPixelsResults{
	var *x_pixels_ptr;
	var *y_pixels_ptr;
	var *escape_iterations_ptr;
};

__global__ void SetPixels(JuliaSettings settings, SetPixelsResults *results_ptr);

void PrintJuliaSettings(JuliaSettings settings);
}	
#endif


