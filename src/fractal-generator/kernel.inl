#include "kernel.h"
#include "kernel_internal.h"
#include "generator.h"
#include "functions.h"

#include <stdio.h>

namespace fractal_generator{


template<FRACTAL type>
__global__ void SetPixels(FractalSettings settings, SetPixelsResults *results_ptr){
	uint x_pixel, y_pixel;
	double x_point, y_point;


	uint thread_id = GetThreadId();

//	printf("%u\n",thread_id);	

	GetPixels(&x_pixel, &y_pixel);

	if((x_pixel < settings.dimm)&&(y_pixel < settings.dimm)){
		x_point = GetPoint(&x_pixel,&(settings.graph_settings.radius),&(settings.dimm),&(settings.graph_settings.x_offset));

		y_point = GetPoint(&y_pixel,&(settings.graph_settings.radius),&(settings.dimm),&(settings.graph_settings.y_offset));

		uint depth = FractalCalc<type>(&x_point, &y_point, &settings);

		results_ptr->x_pixels_ptr[thread_id] = x_pixel;
		results_ptr->y_pixels_ptr[thread_id] = y_pixel;
		results_ptr->escape_iterations_ptr[thread_id] = depth;	
//		printf("%u\n",depth);
	}	

}






} //End namespace
