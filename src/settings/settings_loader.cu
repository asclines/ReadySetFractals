#include "settings_loader.h"
#include <fractal-generator/generator.h>

#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <vector>

namespace fractal_generator{

/* Structs & Enums */
struct Settings{
	int dimm;
	double radius_xy;
	double x_offset;
	double y_offset;
	int iterations;
	int escape_range;
	double constant_real;
	double constant_imag;
	FRACTAL type;
	
	int color_offset;
	bool image_in_bw;
};



/* Foward Declarations For Private Methods */

SettingsLoaderError SetFractalSettings(
	const Settings settings,
	FractalSettings *fractal_settings_ptr,
	ColorSettings *color_settings_ptr );

SettingsLoaderError ExtractSettingsFromVector(std::vector<std::string> settings_list, Settings *settings_ptr);

/* Method Definitions */

SettingsLoaderError LoadSettingsFromSettingsFile(
			FractalSettings *fractal_settings_ptr,
                        ColorSettings *color_settings_ptr
                        ){
	
	return LoadSettingsFromFile("settings.txt",fractal_settings_ptr,color_settings_ptr);

}



SettingsLoaderError LoadSettingsFromFile(
			std::string file_name,
                        FractalSettings *fractal_settings_ptr,
                        ColorSettings *color_settings_ptr
                        ){
	std::vector<std::string> settings_list; //All even indices are the setting key and the following odd index is the setting value
	std::ifstream settings_file(file_name.c_str());
	if(settings_file.is_open()){
		std::string settings_line;
		while(std::getline(settings_file,settings_line)){ 
			std::stringstream stream(settings_line);
			std::string settings_item;
			while(getline(stream,settings_item,'=')){
				settings_list.push_back(settings_item);
			}						
		}
		settings_file.close();

		Settings settings;
		SettingsLoaderError error = ExtractSettingsFromVector(settings_list, &settings);
		if(error == OKAY){
			return SetFractalSettings(settings, fractal_settings_ptr, color_settings_ptr);
		} else{
			return error;
		}
	} else{
		std::cout << "Cannot open file " << file_name << std::endl;
		return COULD_NOT_OPEN_FILE;
	}
	return OKAY;
}


SettingsLoaderError SetFractalSettings(
const Settings settings, 
        FractalSettings *fractal_settings_ptr, 
        ColorSettings *color_settings_ptr ){

	fractal_settings_ptr->graph_settings.radius = settings.radius_xy;
	fractal_settings_ptr->graph_settings.x_offset = settings.x_offset;
	fractal_settings_ptr->graph_settings.y_offset = settings.y_offset;

	fractal_settings_ptr->type = settings.type;
	fractal_settings_ptr->complex_num = complex(settings.constant_real,settings.constant_imag);
	fractal_settings_ptr->dimm = settings.dimm;
	fractal_settings_ptr->escape_value = settings.escape_range;
	fractal_settings_ptr->max_iterations = settings.iterations;

	color_settings_ptr->is_bw = settings.image_in_bw;
	color_settings_ptr->color_offset = settings.color_offset;

	return OKAY;	
}

	
/*
* Go through the settings list in order of appearance
* Assume that settings_list vector contains data in order of appearence in settings file
* If assumption is false, create error
*/
SettingsLoaderError ExtractSettingsFromVector(std::vector<std::string> settings_list, Settings *settings_ptr){	
	std::stringstream stream;
	std::string settings_key_holder; //A temporary string holder to analyze each part of the retrieved settings file before adding to struct
	int settings_int_value_holder;
	double settings_double_value_holder;
	bool settings_bool_value_holder;

	//Only go through the odd indices as they are the ones that contain the values needed for settings struct

	//Expected: value for dimm
	stream << settings_list[1];
	stream >> settings_int_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-dimension" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->dimm = settings_int_value_holder;
	
	//Expected: value for radius xy	
	stream << settings_list[3];
	stream >> settings_double_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-radius-xy" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->radius_xy = settings_double_value_holder;
				
	//Expected: value for x offset
	stream << settings_list[5];
	stream >> settings_double_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-graph-x-offset" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->x_offset = settings_double_value_holder;
	
	//Expected: value for y offset
	stream << settings_list[7];
	stream >> settings_double_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-graph-y-offset" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->y_offset = settings_double_value_holder;
	
	//Expected: value for color offset
	stream << settings_list[9];
	stream >> settings_int_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-color-offset" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->color_offset = settings_int_value_holder;

	//Expected: value for image in color		
	stream << settings_list[11];
	stream >> settings_int_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-in-color" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	if(settings_int_value_holder == 1){
		settings_bool_value_holder = true;
	} else if(settings_int_value_holder == 0){
		settings_bool_value_holder = false;
	} else{
		std::cout << "Invalid settings value for image-in-bw" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}	
	settings_ptr->image_in_bw = settings_bool_value_holder;
	
	//Expected: value for max iterations
	stream << settings_list[13];
	stream >> settings_int_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for max-iterations" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->iterations = settings_int_value_holder;

	//Expected: value for escape range
	stream << settings_list[15];
	stream >> settings_int_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for escape-range" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->escape_range = settings_int_value_holder;
	
	//Expected: value for fractal type
	stream << settings_list[17];
	stream >> settings_int_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for fractal-type-value" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->type = GetFractalTypeFromValue(settings_int_value_holder);


	//Expected: value for constant real
	stream << settings_list[19];
	stream >> settings_double_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for constant-real" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->constant_real = settings_double_value_holder;

	//Expected: value for constant imag
	stream << settings_list[21];
	stream >> settings_double_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for constant-imag" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->constant_imag = settings_double_value_holder;
	
	return OKAY;

}


} //End namespace
