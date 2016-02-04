#ifndef JULIA_SET_H
#define JULIA_SET_H

#include <string>
#include "complex/complex.h"

namespace fractal_generator{

typedef unsigned int uint;
typedef Complex<double> complex;


enum class FRACTAL{
	JULIA,
	MANDLEBROT
};


struct GraphSettings{
	GraphSettings():
		radius(.1),
		x_offset(.4),
		y_offset(-0.330)
		{}
	double radius;
	double x_offset;
	double y_offset;
};

struct ColorSettings{
	ColorSettings():
		is_bw(false),
		color_offset(0)
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
		complex_num(-0.45,0.6),
		dimm(1024),
		escape_value(2),
		max_iterations(1500)
		{}
	FRACTAL type;
	GraphSettings graph_settings;
	complex complex_num;
	int dimm;
	int escape_value;
	int max_iterations;
};


//Returns filename
SetPixelsResults* GenerateFractal(FractalSettings fractal_settings);

std::string GenerateImage(ColorSettings color_settings, FractalSettings fractal_settings, SetPixelsResults *results);

}//End namespace







#endif
