#include "fractal-generator/generator.h"
#include "settings/settings_loader.h"

#include <unistd.h>
#include <string>
#include <sstream>
#include <iostream>

using namespace fractal_generator;

//Foward declarations
void GetOptions(
	int argc,
	char **argv,
	GraphSettings *graph_settings_ptr,
	FractalSettings *fractal_settings_ptr,
	ColorSettings *color_settings
	);

int main(int argc, char **argv){

	fractal_generator::GraphSettings graph_settings;	
        fractal_generator::FractalSettings fractal_settings;
        fractal_generator::ColorSettings color_settings;
        fractal_generator::SetPixelsResults *results_ptr;
/*
	SettingsLoaderError settings_loader_error = LoadSettingsFromSettingsFile(
							&fractal_settings,
							&color_settings
							);

	if(settings_loader_error != OKAY){
		std::cout << "Settings error: " << settings_loader_error_strings[settings_loader_error] << std::endl;
		return settings_loader_error;
	}

*/

	GetOptions(argc,argv,&graph_settings,&fractal_settings,&color_settings);
	fractal_settings.graph_settings = graph_settings;

	results_ptr = fractal_generator::GenerateFractal(fractal_settings);

	std::string file_name = fractal_generator::GenerateImage(color_settings,fractal_settings, results_ptr);

	return 0;
}


void GetOptions(
	int argc,
	char **argv,
        GraphSettings *graph_settings_ptr,
        FractalSettings *fractal_settings_ptr,
        ColorSettings *color_settings_ptr
        ){

        extern char *optarg;
        extern int optind;

	int error=0;
	int option;
		
	double constant_imag = -0.65;        	
	double constant_real = 0.45;

        /*
                f-fractal type
                d-dimm
                e-escape value
                m-max iterations
		r-radius
		x-x offset
		y-y offset
		c-color option/seed
		I-imagine
		R-real
        */
        while((option = getopt(argc,argv,"f:d:e:m:r:x:y:c:I:R:")) != -1){
		std::stringstream stream;
		double opts_double_holder;
		int opts_int_holder;

		stream << optarg;
		switch(option){
                        case 'f': //Fractal Type
				stream >> opts_int_holder;
	                        fractal_settings_ptr->type = GetFractalTypeFromValue(opts_int_holder);
				break;
			case 'd': //Dimmensions for square
				stream >> opts_int_holder;
				fractal_settings_ptr->dimm = opts_int_holder;
				break;
			case 'e': //Escape range
				stream >> opts_int_holder;
				fractal_settings_ptr->escape_value = opts_int_holder;
				break;	
			case 'm': //Max iterations
				stream >> opts_int_holder;
				fractal_settings_ptr->max_iterations = opts_int_holder;
				break;
			case 'r': //Radius			
				stream >> opts_double_holder;
				graph_settings_ptr->radius = opts_double_holder;
				break;
			case 'x': //X Offset
				stream >> opts_double_holder;
				graph_settings_ptr->x_offset = opts_double_holder;
				break;
			case 'y': //Y Offset
				stream >> opts_double_holder;
				graph_settings_ptr->y_offset = opts_double_holder;
				break;
			case 'c': //Color seed
				stream >> opts_int_holder;
				color_settings_ptr->color_option = opts_int_holder;
				break;
			case 'I': //Image number
				stream >> constant_imag;
				break;
			case 'R': //Real number
				stream >> constant_real;
				break;
			case '?':
				error = 1;
				break;

                }
		stream.clear();

        }

	fractal_settings_ptr->complex_num = complex(constant_real,constant_imag);
	if(error >0){
		std::cout << "usage: " << argv[0] << " [-f type] [-d dimm] [-e escape] [-m iterations] [-r radius] [-x x_offset] [-y y_offset] [-c color] [-I imaginary] [-R real] " << std::endl;
		exit(1);
	}


}
