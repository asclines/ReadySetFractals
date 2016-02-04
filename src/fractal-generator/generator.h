#ifndef JULIA_SET_H
#define JULIA_SET_H

#include <string>
#include "complex/complex.h"

namespace fractal_generator{

typedef unsigned int uint;
typedef Complex<double> complex;


enum class FRACTAL{
	JULIA
};


struct GraphSettings{
	GraphSettings():
		radius(0),
		x_offset(0),
		y_offset(0)
		{}
	double radius;
	double x_offset;
	double y_offset;
};

struct ColorSettings{
	ColorSettings():
		is_bw(true),
		color_offset(1)
		{}
	bool is_bw;
	int color_offset;
};

struct SetPixelsResults{
        uint *x_pixels_ptr;
        uint *y_pixels_ptr;
        uint *escape_iterations_ptr;
};


//Should only contain data the kernel needs
struct FractalSettings{
	FractalSettings():
		type(FRACTAL::JULIA),
		complex_num(1,1),
		dimm(64),
		escape_value(2),
		max_iterations(10)
		{}
	FRACTAL type;
	GraphSettings graph_settings;
	complex complex_num;
	int dimm;
	int escape_value;
	int max_iterations;
};


//Returns filename
std::string GenerateFractal(FractalSettings fractal_settings, SetPixelsResults *set_pixels_results_ptr);

std::string GenerateImage(ColorSettings color_settings, FractalSettings fractal_settings, SetPixelsResults results);

}//End namespace







#endif
