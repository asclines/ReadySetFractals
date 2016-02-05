#include "generator.h"
#include "kernel.h"
#include <qdbmp/qdbmp.h>
#include <colors/color_gen.h>
#include <stdio.h>
#include <cuda.h>
#include <iostream>

namespace fractal_generator{

SetPixelsResults* GenerateFractal(FractalSettings settings){


/* Setting up device and host  structures */
	SetPixelsResults *d_set_pixels_results_ptr, *h_set_pixels_results_ptr;
        uint *d_x_pixels_ptr, *d_y_pixels_ptr, *d_escape_iterations_ptr;
        uint *h_x_pixels_ptr, *h_y_pixels_ptr, *h_escape_iterations_ptr;

	//Allocate memory
        uint uint_array_size = settings.dimm * settings.dimm * sizeof(uint);
        cudaMalloc((void**)&d_set_pixels_results_ptr,sizeof(SetPixelsResults));
        cudaMalloc((void**)&d_x_pixels_ptr,uint_array_size);
        cudaMalloc((void**)&d_y_pixels_ptr,uint_array_size);
        cudaMalloc((void**)&d_escape_iterations_ptr,uint_array_size);

        h_set_pixels_results_ptr = (SetPixelsResults *)malloc(sizeof(SetPixelsResults));
        h_x_pixels_ptr = (uint*)malloc(uint_array_size);
        h_y_pixels_ptr = (uint*)malloc(uint_array_size);
        h_escape_iterations_ptr = (uint*)malloc(uint_array_size);

        //Set host pointers to device pointers for memcp
        h_set_pixels_results_ptr->x_pixels_ptr = d_x_pixels_ptr;
        h_set_pixels_results_ptr->y_pixels_ptr = d_y_pixels_ptr;
        h_set_pixels_results_ptr->escape_iterations_ptr = d_escape_iterations_ptr;

        //Copy everything over
        cudaMemcpy(d_set_pixels_results_ptr,h_set_pixels_results_ptr,sizeof(SetPixelsResults),cudaMemcpyHostToDevice);

/*Dealing with kernel*/
        //Setting up dim3 for kernel call
        dim3 threads,blocks;
        threads.x=8;//In future, this needs to not be hardcoded
        threads.y=8;
        blocks.x=(settings.dimm/threads.x);
        blocks.y=(settings.dimm/threads.y);

        printf("Starting kernel\n");

        //Calling kernel
	switch(settings.type){
		case FRACTAL::JULIA:
			 SetPixels<FRACTAL::JULIA><<<blocks,threads>>>(settings,d_set_pixels_results_ptr);
		break;
		case FRACTAL::MANDLEBROT:
			SetPixels<FRACTAL::MANDLEBROT><<<blocks,threads>>>(settings,d_set_pixels_results_ptr);
                break;
	}

        //Waiting for kernel to finish  
        cudaDeviceSynchronize();
        printf("Kernel done\n");

        //Getting data back
        cudaMemcpy(h_set_pixels_results_ptr,d_set_pixels_results_ptr,sizeof(SetPixelsResults),cudaMemcpyDeviceToHost);
        cudaMemcpy(h_x_pixels_ptr,d_x_pixels_ptr,uint_array_size,cudaMemcpyDeviceToHost);
        cudaMemcpy(h_y_pixels_ptr,d_y_pixels_ptr,uint_array_size,cudaMemcpyDeviceToHost);
        cudaMemcpy(h_escape_iterations_ptr,d_escape_iterations_ptr,uint_array_size,cudaMemcpyDeviceToHost);

	//Reassign host pointers
        h_set_pixels_results_ptr->x_pixels_ptr = h_x_pixels_ptr;
        h_set_pixels_results_ptr->y_pixels_ptr = h_y_pixels_ptr;
        h_set_pixels_results_ptr->escape_iterations_ptr = h_escape_iterations_ptr;

        //Free memory
        cudaFree(d_set_pixels_results_ptr);
        cudaFree(d_x_pixels_ptr);
        cudaFree(d_y_pixels_ptr);
        cudaFree(d_escape_iterations_ptr);

	return h_set_pixels_results_ptr;
}

std::string GenerateImage(ColorSettings color_settings, FractalSettings fractal_settings, SetPixelsResults *results_ptr){
	BMP* bmp;
        int max_colors = color_gen::get_color_list_size();

	char* image_file_name = "output_image.bmp";	

	bmp = BMP_Create(fractal_settings.dimm,fractal_settings.dimm,8);

	printf("Generating image\n");

        //Setting pixel index //In future, this should be moved onto GPU
	for(int i=0; i<fractal_settings.dimm * fractal_settings.dimm; i++){
		BMP_SetPixelIndex(
			bmp,
			results_ptr->x_pixels_ptr[i],
			results_ptr->y_pixels_ptr[i],
			results_ptr->escape_iterations_ptr[i]
		);

	}
	
        //Setting color palette
	//TODO take color palette setting from user instead of hardcod	
	color_gen::Set_Color_Palette(bmp,fractal_settings.max_iterations,2);


        BMP_WriteFile(bmp,image_file_name);
        BMP_Free(bmp);
       // BMP_CHECK_ERROR(stderr,-2);
	
	
	return "end"; //image_file_name;
}

FRACTAL GetFractalTypeFromValue(int value){
	
	switch(value){
		case 1:
			return FRACTAL::JULIA;
		case 2:
			return FRACTAL::MANDLEBROT;
		default:
			return FRACTAL::ERROR;
	}
}


}//End namepsace
