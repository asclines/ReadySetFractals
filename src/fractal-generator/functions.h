#ifndef FRACTAL_FUNCTIONS_H
#define FRACTAL_FUNCTIONS_H

#include "generator.h"

namespace fractal_generator{


//Returns depth
template<FRACTAL type>
__device__ uint FractalCalc(
	double *x_point_ptr,
	double *y_point_ptr,
	FractalSettings *settings_ptr,
	SetPixelsResults *results_ptr
	);


//Julia Fractal
template<>
__device__ uint FractalCalc<FRACTAL::JULIA>(
        double *x_point_ptr,
        double *y_point_ptr,
        FractalSettings *settings_ptr,
	SetPixelsResults *results_ptr
        );

//Mandlebrot
template<>
__device__ uint FractalCalc<FRACTAL::MANDLEBROT>(
        double *x_point_ptr,
        double *y_point_ptr,
        FractalSettings *settings_ptr,
        SetPixelsResults *results_ptr
        );

//Tri Symmetric Julia Fractal	
template<>
__device__ uint FractalCalc<FRACTAL::TRI_JULIA>(
        double *x_point_ptr,
        double *y_point_ptr,
        FractalSettings *settings_ptr,
        SetPixelsResults *results_ptr
        );




}//end namespace

#include "functions.inl"
#endif
