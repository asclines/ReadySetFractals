#ifndef JULIA_SET_H
#define JULIA_SET_H

#include <string>

namspace fractal_generator{

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
		is_bw(true)
		{}
	bool is_bw;
};

struct Point{
	Point():
		real(1),
		imag(1)
		{}
	double real;
	double imag;
};

//Should only contain data the kernel needs
struct FractalSettings{
	FractalSettings():
		FRACTAL_TYPE(JULIA),
		dimm(512),
		escape_value(2),
		max_iterations(10)
		{}
	FRACTAL_TYPE type;
	GraphSettings graph_settings;
	Point point;
	int dimm;
	int escape_value;
	int iterations;
};


//Returns filename
std::string GenerateFractal(FractalSettings fractal_settings,ColorSettings color_settings);



}//End namespace







#endif
