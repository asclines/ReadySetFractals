#ifndef FRACTAL_FUNCTIONS_H
#define FRACTAL_FUNCTIONS_H

namespace fractal_generator{


//Returns depth
template<FRACTAL type>
double fractal_calc(
	double *x_point_ptr,
	double *y_point_ptr,
	FractalSettings *settings_pointer
	);


//Julia Fractal
template<>
double fractal_calc<FRACTAL::JULIA>(
        double *x_point_ptr,
        double *y_point_ptr,
        FractalSettings *settings_pointer
        );

	


}//end namespace

#endif
