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

struct ImageSettings{
	ImageSettings():
		dimm(512),
		is_bw(true)
		{}
	int dimm;
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

struct FractalSettings{
	FractalSettings():
		FRACTAL_TYPE(JULIA),
		escape_value(2),
		max_iterations(10)
		{}
	FRACTAL_TYPE type;
	GraphSettings graph_settings;
	ImageSettings image_settings;
	Point point;
	int escape_value;
	int iterations;
};


//Returns filename
std::string GenerateFractal(FractalSettings settings);



}//End namespace







#endif
