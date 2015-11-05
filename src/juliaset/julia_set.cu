#include "julia_set.h"

#include <stdio.h>
#include <cuda.h>
#include <cuComplex.h>
#include <iostream>
#include <string>
#include <qdbmp/qdbmp.h>

#include <colors/color_gen.h>

/* Class JuliaSet member function defintions */
int JuliaSet::GetGPUInfo(){
	int devices_count;
	
	cudaGetDeviceCount(&devices_count);
	printf("CUDA Device count: %d\n",devices_count);
	for(int i=0; i<devices_count;i++){
		cudaDeviceProp prop;
		cudaGetDeviceProperties(&prop,i);
		printf("Device Number: %d\n",i);
		printf("\tDevice Name: %s\n",prop.name);
	}
	return devices_count;
}

bool JuliaSet::GeneratePixels(){
	PrepareSettings();
	if(current_state_ != READY){
		std::cout << "JuliaSet::GeneratePixels() : current_state_ is NOT READY " << std::endl;
		exit(1);
	}
	julia_set_kernel::PrintJuliaSettings(settings_);

	typedef julia_set_kernel::var var;
	typedef julia_set_kernel::Complex Complex;

/* Setting up device and host  structures */
	julia_set_kernel::SetPixelsResults *d_set_pixels_results_ptr;
	var *d_x_pixels_ptr, *d_y_pixels_ptr, *d_escape_iterations_ptr;
	var *h_x_pixels_ptr, *h_y_pixels_ptr, *h_escape_iterations_ptr;

	//Allocate memory
	var var_array_size = settings_.w_pixels * settings_.h_pixels * sizeof(var);
	cudaMalloc((void**)&d_set_pixels_results_ptr,sizeof(julia_set_kernel::SetPixelsResults));
	cudaMalloc((void**)&d_x_pixels_ptr,var_array_size);
	cudaMalloc((void**)&d_y_pixels_ptr,var_array_size);
	cudaMalloc((void**)&d_escape_iterations_ptr,var_array_size);

	h_set_pixels_results_ptr_ = (julia_set_kernel::SetPixelsResults*)malloc(sizeof(julia_set_kernel::SetPixelsResults));
	h_x_pixels_ptr = (var*)malloc(var_array_size);
	h_y_pixels_ptr = (var*)malloc(var_array_size);
	h_escape_iterations_ptr = (var*)malloc(var_array_size);

	//Set host pointers to device pointers for memcp
	h_set_pixels_results_ptr_->x_pixels_ptr = d_x_pixels_ptr;
	h_set_pixels_results_ptr_->y_pixels_ptr = d_y_pixels_ptr;
	h_set_pixels_results_ptr_->escape_iterations_ptr = d_escape_iterations_ptr;

	//Copy everything over
	cudaMemcpy(d_set_pixels_results_ptr,h_set_pixels_results_ptr_,sizeof(julia_set_kernel::SetPixelsResults),cudaMemcpyHostToDevice);

	/*Dealing with kernel*/
	//Setting up dim3 for kernel call
	dim3 threads,blocks;
	threads.x=16;//In future, this needs to not be hardcoded
	threads.y=16;
	blocks.x=(settings_.w_pixels/threads.x);
	blocks.y=(settings_.h_pixels/threads.y);
	
	printf("Starting kernel\n");

	//Calling kernel
	julia_set_kernel::SetPixels<<<blocks,threads>>>(settings_,d_set_pixels_results_ptr);

	//Waiting for kernel to finish	
	cudaDeviceSynchronize();
	printf("Kernel done\n");


	//Getting data back
	cudaMemcpy(h_set_pixels_results_ptr_,d_set_pixels_results_ptr,sizeof(julia_set_kernel::SetPixelsResults),cudaMemcpyDeviceToHost);
	cudaMemcpy(h_x_pixels_ptr,d_x_pixels_ptr,var_array_size,cudaMemcpyDeviceToHost);
	cudaMemcpy(h_y_pixels_ptr,d_y_pixels_ptr,var_array_size,cudaMemcpyDeviceToHost);
	cudaMemcpy(h_escape_iterations_ptr,d_escape_iterations_ptr,var_array_size,cudaMemcpyDeviceToHost);

	//Reassign host pointers
	h_set_pixels_results_ptr_->x_pixels_ptr = h_x_pixels_ptr;
	h_set_pixels_results_ptr_->y_pixels_ptr = h_y_pixels_ptr;
	h_set_pixels_results_ptr_->escape_iterations_ptr = h_escape_iterations_ptr;

	//Free memory
	cudaFree(d_set_pixels_results_ptr);
	cudaFree(d_x_pixels_ptr);
	cudaFree(d_y_pixels_ptr);
	cudaFree(d_escape_iterations_ptr);

	current_state_ = GENERATED;	
	return true;
}


bool JuliaSet::GenerateColorImage(int color_offset, const char* image_file_name){
	return GenerateImage(true,color_offset,image_file_name);
}

bool JuliaSet::GenerateBWImage(const char* image_file_name){
	return GenerateImage(false,0,image_file_name);
}

bool JuliaSet::GenerateImage(bool in_color, int color_offset, const char* image_file_name){
	if(current_state_ != GENERATED){
		std::cout << "JuliaSet::GenerateImage() : current_state_ is NOT GENERATED" << std::endl;
		exit(1);
	}

	BMP* bmp;
	int max_colors = get_color_list_size();

	bmp = BMP_Create(settings_.w_pixels,settings_.h_pixels,8);

	//Setting pixel index //In future, this should be moved onto GPU
	for(int i = 0; i < settings_.w_pixels * settings_.h_pixels; i++){
		BMP_SetPixelIndex(
			bmp,
			h_set_pixels_results_ptr_->x_pixels_ptr[i],
			h_set_pixels_results_ptr_->y_pixels_ptr[i],
			h_set_pixels_results_ptr_->escape_iterations_ptr[i]
		);
	}

	//Setting color palette
	BMP_SetPaletteColor(bmp,1,0,0,0);
	for(int i = 1; i < settings_.max_iterations; i++){
		if(in_color){
			RGBColor color = get_rgb_color((i+color_offset)%max_colors);
			BMP_SetPaletteColor(bmp,i,color.red,color.green,color.blue);
		} else{ //Not in color
			BMP_SetPaletteColor(bmp,i,i,i,i);
		}
	}

	BMP_WriteFile(bmp,image_file_name);
	BMP_Free(bmp);
	BMP_CHECK_ERROR(stderr,-2);

return true;
}

bool JuliaSet::PrepareSettings(){
	settings_.w_pixels = w_pixels_;
	settings_.h_pixels = h_pixels_;
	settings_.xy_radius = xy_radius_;
	settings_.x_offset = x_offset_;
	settings_.y_offset = y_offset_;
	settings_.max_iterations = max_iterations_;
	settings_.escape_range = escape_range_;
	settings_.complex_constant = make_cuDoubleComplex(julia_constant_real_,julia_constant_imag_);

	current_state_ = READY;
	return true;
}

/* Getters */

int JuliaSet::get_w_pixels(){
	return w_pixels_;
}


int JuliaSet::get_h_pixels(){
	return h_pixels_;
}

double JuliaSet::get_xy_radius(){
	return xy_radius_;
}

double JuliaSet::get_x_offset(){
	return x_offset_;
}

double JuliaSet::get_y_offset(){
	return y_offset_;
}

int JuliaSet::get_max_iterations(){
	return max_iterations_;
}

int JuliaSet::get_escape_range(){
	return escape_range_;
}


double JuliaSet::get_julia_constant_real(){
	return julia_constant_real_;
}

double JuliaSet::get_julia_constant_imag(){
	return julia_constant_imag_;
}


/* Setters */

void JuliaSet::set_pixels(int w_pixels,int h_pixels){
	w_pixels_ = w_pixels;
	h_pixels_ = h_pixels;
}

void JuliaSet::set_radius(double xy_radius){
	xy_radius_ = xy_radius;
}

void JuliaSet::set_offset(double x_offset, double y_offset){
	x_offset_ = x_offset;
	y_offset_ = y_offset;
}

void JuliaSet::set_max_iterations(int max_iterations){
	max_iterations_ = max_iterations;
}

void JuliaSet::set_escape_range(int escape_range){
	escape_range_ = escape_range;
}

void JuliaSet::set_julia_constant(double julia_constant_real,double julia_constant_imag){
	julia_constant_real_ = julia_constant_real;
	julia_constant_imag_ = julia_constant_imag;
}
