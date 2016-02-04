#include "fractal-generator/generator.h"

#include <string>

#include <iostream>

int main(int argc, const char *argv[]){
	
	fractal_generator::GraphSettings graph_settings;
	fractal_generator::FractalSettings fractal_settings;
	fractal_generator::ColorSettings color_settings;
	fractal_generator::SetPixelsResults *results_ptr;

	fractal_settings.graph_settings = graph_settings;

	results_ptr = fractal_generator::GenerateFractal(fractal_settings);//, &results_ptr);

	std::cout << "X2"<< results_ptr->escape_iterations_ptr[5] << std::endl;
	
	std::string file_name = fractal_generator::GenerateImage(color_settings,fractal_settings, results_ptr);

	return 0;
}

