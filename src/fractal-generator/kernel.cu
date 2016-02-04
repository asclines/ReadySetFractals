#include "kernel_internal.h"
#include "generator.h"

namespace fractal_generator{

//Returns unique thread id based on thread dimms
__device__ uint GetThreadId(){
	return ( blockIdx.y*gridDim.x+blockIdx.x)*(blockDim.x*blockDim.y)+(threadIdx.y*blockDim.x)+threadIdx.x;
}

//Determines pixels based on thread dimms
__device__ void GetPixels(
        uint *x_pixel_ptr,
        uint *y_pixel_ptr
){

	*x_pixel_ptr = ((blockIdx.x * blockDim.x) + threadIdx.x);
	*y_pixel_ptr = ((blockIdx.y * blockDim.y) + threadIdx.y);
}

//Determines point from pixels,radius, offsets and dimmensions, handes transformations
__device__ double GetPoint(
        uint *pixel_ptr,
        double *radius_ptr,
        int *dimm_ptr,
        double *offset_ptr
        ){
	
	double pre_transform = (double)(*pixel_ptr * *radius_ptr * 2)/(*dimm_ptr);
	
	return pre_transform - *radius_ptr + *offset_ptr;

}







}//End namespace
