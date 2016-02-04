#include "fractal-generator/generator.h"

#include <string>

using namespace fractal_generator;

int main(int argc, const char *argv[]){
		
	fractal_generator::GraphSettings graph_settings;	

	fractal_generator::FractalSettings fractal_settings;
	fractal_generator::ColorSettings color_settings;
	fractal_generator::SetPixelsResults *results_ptr;

	graph_settings.radius = 1;
	graph_settings.x_offset = 0.0;
	graph_settings.y_offset = 0.0;

	fractal_settings.graph_settings = graph_settings;
	fractal_settings.type = FRACTAL::JULIA;
	fractal_settings.complex_num = complex(-0.45,0.6);
	fractal_settings.dimm = 1024;
	fractal_settings.escape_value = 2;
	fractal_settings.max_iterations = 100;

	color_settings.is_bw = false;
	color_settings.color_offset = 100;

	results_ptr = fractal_generator::GenerateFractal(fractal_settings);//, &results_ptr);

	std::string file_name = fractal_generator::GenerateImage(color_settings,fractal_settings, results_ptr);

	return 0;
}

