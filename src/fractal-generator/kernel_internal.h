#ifndef FRACTAL_KERNEL_INTERNAL_H
#define FRACTAL_KERNEL_INTERNAL_H

#include "generator.h"

#include <cuda.h>

namespace fractal_generator{

//Returns unique thread id based on thread dimms
__device__ uint GetThreadId();

//Determines pixels based on thread dimms
__device__ void GetPixels(
	uint *x_pixel_ptr,
	uint *y_pixel_ptr
);

//Determines point from pixels,radius, offsets and dimmensions, handes transformations
__device__ void GetPoint(
	uint *pixel_ptr,
	double *radius_ptr,
	int *dimm_ptr,
	double *offset_ptr
	);





}



#endif
