#include "generator.h"
#include "complex/complex.h"

namespace fractal_generator{


//Returns depth
template<FRACTAL type>
__device__ uint FractalCalc(
        double *x_point_ptr,
        double *y_point_ptr,
        FractalSettings *settings_ptr,
	SetPixelsResults *results_ptr
        ){
	return 0;
};


//Julia Fractal
template<>
__device__ uint FractalCalc<FRACTAL::JULIA>(
        double *x_point_ptr,
        double *y_point_ptr,
        FractalSettings *settings_ptr,
	SetPixelsResults *results_ptr
        ){
	complex complex_z = complex(*x_point_ptr,*y_point_ptr);
	complex complex_c = settings_ptr->complex_num;
	int depth = 0; 

	while((complex_z.abs() <= settings_ptr->escape_value) 
		&& (depth <= settings_ptr->max_iterations)){
		depth++;
		complex_z = complex_z * complex_z;
		complex_z = complex_z + complex_c;
	}

	if(complex_z.abs() <= settings_ptr->escape_value){
		return 0;
	} else{
		return depth;
	}
};


//Mandlebrot
template<>
__device__ uint FractalCalc<FRACTAL::MANDLEBROT>(
        double *x_point_ptr,
        double *y_point_ptr,
        FractalSettings *settings_ptr,
        SetPixelsResults *results_ptr
        ){
	
	complex complex_z = complex(0,0);
	complex complex_c = complex(*x_point_ptr, *y_point_ptr);
	int depth = 0;

	while((complex_z.abs() <= settings_ptr->escape_value)
		&& (depth <= settings_ptr->max_iterations)){
			depth++;
			complex_z = complex_z * complex_z;
			complex_z = complex_z + complex_c;
	}
	
        if(complex_z.abs() <= settings_ptr->escape_value){
                return 0;
        } else{
                return depth;
        }

}

//Tri Symmetric Julia Fractal   
template<>
__device__ uint FractalCalc<FRACTAL::TRI_JULIA>(
        double *x_point_ptr,
        double *y_point_ptr,
        FractalSettings *settings_ptr,
        SetPixelsResults *results_ptr
        ){

        complex complex_z = complex(*x_point_ptr,*y_point_ptr);
        complex complex_c = settings_ptr->complex_num;
        int depth = 0;

        while((complex_z.abs() <= settings_ptr->escape_value)
                && (depth <= settings_ptr->max_iterations)){
                depth++;
                complex_z = complex_z * complex_z * complex_z;
                complex_z = complex_z + complex_c;
        }

        if(complex_z.abs() <= settings_ptr->escape_value){
                return 0;
        } else{
                return depth;
        }
};







}//end namespace

