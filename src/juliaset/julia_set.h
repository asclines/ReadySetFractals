#ifndef JULIA_SET_H
#define JULIA_SET_H

#include <cuda.h>
#include <string>
#include "julia_set_kernel.cuh"

/*
 * 	Julia Fractal
 * 	Equation: f(z) = z^2 + C
 */
class JuliaSet{
public:
/* Typedefs and Enumas */	

	//States of the class, depending the state, different functions can be called
	enum STATE { 
		CLEAN, //The class has just be created
		READY, //Once settings have been loaded, kernel can be started
		GENERATED //The SetPixelsResults has been generated
	};
	
/* Constructors and Destructors */
	JuliaSet():current_state_(CLEAN),
		w_pixels_(500),
		h_pixels_(500),
		xy_radius_(1),
		x_offset_(0),
		y_offset_(0),
		max_iterations_(1),
		escape_range_(2),
		julia_constant_real_(1),
		julia_constant_imag_(1){}
		
/* Public methods */
	int GetGPUInfo(); //Prints out GPU Device information.  Returns number of devices
	
	bool GeneratePixels(); //Preps for and launches kernel. Results true if successful
		
	bool GenerateColorImage(int color_offset, const char* image_file_name); // Generates and writes the BMP to file in color. Returns true if successful

	bool GenerateBWImage(const char* image_file_name);// Generates and writes the BMP to file in B&W. Returns true if successful

/* Getters */
	int get_w_pixels();
	int get_h_pixels();
	double get_xy_radius();
	double get_x_offset(); 
	double get_y_offset();
	
	int get_max_iterations(); 
	int get_escape_range();
	double get_julia_constant_real();
	double get_julia_constant_imag();

/* Setters */
	void set_pixels(int w_pixels,int h_pixels); 
	void set_radius(double xy_radius);
	void set_offset(double x_offset, double y_offset);
	
	void set_max_iterations(int max_iterations);
	void set_escape_range(int escape_range); 

	void set_julia_constant(double julia_constant_real, double julia_constant_imag); 

private:
/* Private typedefs and enums */


/* Private methods */
	bool GenerateImage(bool in_color, int color_offset, const char* image_file_name);//Base function that the public image generation functions will call on

	bool PrepareSettings(); //Takes the data members and adds them to the JuliaSettings struct. Also checks for null data types. If sucessful will return true and change current_state_ to READY

/* Private data members */
	//Size and transformation
	int w_pixels_,h_pixels_; 
	double xy_radius_;
	double x_offset_,y_offset_; 
	
	//Fractal equation
	int max_iterations_; 
	int escape_range_; 
	double julia_constant_real_,julia_constant_imag_;

	julia_set_kernel::JuliaSettings settings_;
	STATE current_state_;
	julia_set_kernel::SetPixelsResults *h_set_pixels_results_ptr_;	

};

#endif
