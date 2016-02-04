#include "generator.h"

namespace fractal_generator{


//Returns depth
template<FRACTAL type>
__device__ uint FractalCalc(
        double *x_point_ptr,
        double *y_point_ptr,
        FractalSettings *settings_pointer
        ){
	return 0;
};


//Julia Fractal
template<>
__device__ uint FractalCalc<FRACTAL::JULIA>(
        double *x_point_ptr,
        double *y_point_ptr,
        FractalSettings *settings_pointer
        ){
	//TODO actually do the calculation

	return 1;
};




}//end namespace

