#include "julia_set_kernel.cuh"
#include <cuComplex.h>
#include <cuda.h>
#include <iostream>
#include <stdio.h>

namespace julia_set_kernel{

__global__ void SetPixels(JuliaSettings settings, SetPixelsResults *results_ptr){

/* Setting up required variables */
	//Getting thread id
	var thread_id = ( blockIdx.y*gridDim.x+blockIdx.x)*(blockDim.x*blockDim.y)+(threadIdx.y*blockDim.x)+threadIdx.x;

	//Image variables xPixel/yPixel is the x/y coordinate for the current pixel
	var x_pixel = ((blockIdx.x * blockDim.x) + threadIdx.x);
	var y_pixel = (blockIdx.y * blockDim.y) + threadIdx.y;
		
	//Julia calculation variables
	Complex complex_num;
	int depth = 0;
	

/* Performing all calculations */
	if((x_pixel<settings.w_pixels)&&(y_pixel<settings.h_pixels)){

		results_ptr->x_pixels_ptr[thread_id] = x_pixel;
		results_ptr->y_pixels_ptr[thread_id] = y_pixel;

		//Graph variables
		double x_point,y_point; //To be set later

		// Get Points from pixels 
		x_point = (double)(x_pixel*settings.xy_radius*2)/settings.w_pixels;
		y_point = (double)(y_pixel*settings.xy_radius*2)/settings.h_pixels;		

		// Transform points 
		x_point = x_point - settings.xy_radius + settings.x_offset;
		y_point = y_point - settings.xy_radius + settings.y_offset;

		// Julia Calculations 
		complex_num = make_cuDoubleComplex(x_point,y_point);

		while((cuCabs(complex_num) <= settings.escape_range) && (depth <= settings.max_iterations)){
			depth++;
			complex_num = cuCmul(complex_num,complex_num);
			complex_num = cuCadd(complex_num,settings.complex_constant);
		} 

		// Set values in devicePackage 
		if(cuCabs(complex_num) <=settings.escape_range){
			results_ptr->escape_iterations_ptr[thread_id] = 0;
		} else{
			results_ptr->escape_iterations_ptr[thread_id] = depth;	
		}

	}
}


void PrintJuliaSettings(JuliaSettings settings){
	using namespace std;
	cout << "Printing Julia Settings" << endl;
	cout << "\tImage Size Settings" << endl;
	cout << "\t\tWidth(Pixels): " << settings.w_pixels << endl;
	cout << "\t\tHeight(Pixels): " << settings.h_pixels << endl;
	cout << "\t\tRadius(Points): " << settings.xy_radius << endl;
	cout << "\t\tX Direction Offset(Points): " << settings.x_offset << endl;
	cout << "\t\tY Direction Offset(Points): " << settings.y_offset << endl;
	cout << "\tJulia Fractal Settings" << endl;
	cout << "\t\tMax Iterations: " << settings.max_iterations << endl;
	cout << "\t\tEscape Range(Point): " << settings.escape_range << endl;
	cout << "\t\tJulia Constant Real: " << cuCreal(settings.complex_constant) << endl;
	cout << "\t\tJulia Constant Imag: " << cuCimag(settings.complex_constant) << endl;

}		

} //End namespace
	
