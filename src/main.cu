#include "fractal-generator/generator.h"

#include <string>

int main(int argc, const char *argv[]){
	
	fractal_generator::GraphSettings graph_settings;
	fractal_generator::FractalSettings fractal_settings;
	fractal_generator::ColorSettings color_settings;
	fractal_generator::SetPixelsResults results;

	fractal_settings.graph_settings = graph_settings;

	std::string result = fractal_generator::GenerateFractal(fractal_settings, &results);
	
	std::string file_name = fractal_generator::GenerateImage(color_settings, fractal_settings,results);

	return 0;
}

