#ifndef JULIA_SET_H
#define JULIA_SET_H

#include <cuda.h>
#include <string>

enum FRACTAL_TYPE{
	JULIA
};

`
struct FractalSettings{
	FractalSettings():
		FRACTAL_TYPE(JULIA),
		dimm(512),
		escape_value(2),
		max_iterations(10)
		{}
	FRACTAL_TYPE type;
	int dimm;
	int escape_value;
	int iterations;
};


//Returns filename
std::string GenerateFractal(FractalSettings settings);











#endif
