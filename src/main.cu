#include "fractal-generator/generator.h"
#include "settings/settings_loader.h"

#include <unistd.h>
#include <string>
#include <sstream>

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
	graph_settings.radius = 1;
	graph_settings.x_offset = 0.0;
	graph_settings.y_offset = 0.0;

	fractal_settings.graph_settings = graph_settings;
	fractal_settings.type = GetFractalTypeFromValue(1);
	fractal_settings.complex_num = complex(-0.45,0.6);
	fractal_settings.dimm = 1024;
	fractal_settings.escape_value = 2;
	fractal_settings.max_iterations = 100;

	color_settings.is_bw = false;
	color_settings.color_option = 100;
*/

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

	 std::cout << "Settings" << std::endl
                << "\tRadius: " << fractal_settings.graph_settings.radius << std::endl
		<< "\tIterations: " << fractal_settings.max_iterations << std::endl;




	results_ptr = fractal_generator::GenerateFractal(fractal_settings);

	std::string file_name = fractal_generator::GenerateImage(color_settings,fractal_settings, results_ptr);

	return 0;
}


void GetOptions(
	int argc,
	char **argv,
        GraphSettings *graph_settings_ptr,
        FractalSettings *fractal_settings_ptr,
        ColorSettings *color_settings
        ){

        extern char *optarg;
        extern int optind;

	int error=0;
	int option;
	
	std::stringstream stream;
		
	int opts_int_holder;

        /*
                f-fractal type
                d-dimm
                e-escape value
                m-max iterations
        */
        while((option = getopt(argc,argv,"f:d:e:m:")) != -1){
                switch(option){
                        case 'f': //Fractal Type
        			stream << optarg;
				stream >> opts_int_holder;
	                        fractal_settings_ptr->type = GetFractalTypeFromValue(opts_int_holder);
				stream.clear();
				break;
			case 'd': //Dimmensions for square
				stream << optarg;
				stream >> opts_int_holder;
				fractal_settings_ptr->dimm = opts_int_holder;
				stream.clear();
				break;
			case 'e': //Escape range
				stream << optarg;
				stream >> opts_int_holder;
				fractal_settings_ptr->escape_value = opts_int_holder;
				stream.clear();
				break;	
			case 'm': //Max iterations
				stream << optarg;
				stream >> opts_int_holder;
				fractal_settings_ptr->max_iterations = opts_int_holder;
				stream.clear();
				break;
			case '?':
				error = 1;
				break;

                }

        }

	if(error >0){
		//TODO Print usage
	}


}
