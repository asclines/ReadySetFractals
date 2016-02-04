#ifndef FRACTAL_FUNCTIONS_H
#define FRACTAL_FUNCTIONS_H

#include "generator.h"

namespace fractal_generator{


//Returns depth
template<FRACTAL type>
__device__ uint FractalCalc(
	double *x_point_ptr,
	double *y_point_ptr,
	FractalSettings *settings_pointer
	);


//Julia Fractal
template<>
__device__ uint FractalCalc<FRACTAL::JULIA>(
        double *x_point_ptr,
        double *y_point_ptr,
        FractalSettings *settings_pointer
        );

	


}//end namespace

#include "functions.inl"
#endif