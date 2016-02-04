#include "settings_loader.h"

#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <vector>

#include <juliaset/julia_set.h>

/* Structs & Enums */
struct Settings{
	int width;
	int height;
	double radius_xy;
	double x_offset;
	double y_offset;
	int iterations;
	int escape_range;
	double constant_real;
	double constant_imag;
	
	int color_offset;
	bool image_in_color;
};



/* Foward Declarations For Private Methods */

SettingsLoaderError SetJuliaSettings(const Settings settings, JuliaSet *julia_set_ptr);

SettingsLoaderError ExtractSettingsFromVector(std::vector<std::string> settings_list, Settings *settings_ptr);

/* Method Definitions */

SettingsLoaderError LoadSettingsFromSettingsFile(JuliaSet *julia_set_ptr, bool *image_in_color, int *color_offset){
	
	return LoadSettingsFromFile("settings.txt",julia_set_ptr,image_in_color,color_offset);

}



SettingsLoaderError LoadSettingsFromFile(std::string file_name, JuliaSet *julia_set_ptr, bool *image_in_color, int *color_offset){
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
			*image_in_color = settings.image_in_color;
			*color_offset = settings.color_offset;
			return SetJuliaSettings(settings, julia_set_ptr);
		} else{
			return error;
		}
	} else{
		std::cout << "Cannot open file " << file_name << std::endl;
		return COULD_NOT_OPEN_FILE;
	}
	return OKAY;
}


SettingsLoaderError SetJuliaSettings(const Settings settings, JuliaSet *julia_set_ptr){
	julia_set_ptr->set_pixels(settings.width, settings.height);
	julia_set_ptr->set_radius(settings.radius_xy);
	julia_set_ptr->set_offset(settings.x_offset, settings.y_offset);
	julia_set_ptr->set_max_iterations(settings.iterations);
	julia_set_ptr->set_escape_range(settings.escape_range);
	julia_set_ptr->set_julia_constant(settings.constant_real, settings.constant_imag);
	

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

	//Expected: value for width
	stream << settings_list[1];
	stream >> settings_int_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-dimension-width" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->width = settings_int_value_holder;
	
	//Expected: value for height		
	stream << settings_list[3];
	stream >> settings_int_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-dimension-height" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->height = settings_int_value_holder;

	//Expected: value for radius xy	
	stream << settings_list[5];
	stream >> settings_double_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-radius-xy" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->radius_xy = settings_double_value_holder;
				
	//Expected: value for x offset
	stream << settings_list[7];
	stream >> settings_double_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-graph-x-offset" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->x_offset = settings_double_value_holder;
	
	//Expected: value for y offset
	stream << settings_list[9];
	stream >> settings_double_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-graph-y-offset" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->y_offset = settings_double_value_holder;
	
	//Expected: value for color offset
	stream << settings_list[11];
	stream >> settings_int_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for image-color-offset" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->color_offset = settings_int_value_holder;

	//Expected: value for image in color		
	stream << settings_list[13];
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
		std::cout << "Invalid settings value for image-in-color" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}	
	settings_ptr->image_in_color = settings_bool_value_holder;
	
	//Expected: value for max iterations
	stream << settings_list[15];
	stream >> settings_int_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for julia-calc-max-iterations" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->iterations = settings_int_value_holder;

	//Expected: value for escape range
	stream << settings_list[17];
	stream >> settings_int_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for julia-calc-escape-range" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->escape_range = settings_int_value_holder;

	//Expected: value for constant real
	stream << settings_list[19];
	stream >> settings_double_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for julia-calc-constant-real" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->constant_real = settings_double_value_holder;

	//Expected: value for constant imag
	stream << settings_list[21];
	stream >> settings_double_value_holder;
	if(stream.fail()){
		std::cout << "Invalid settings value for julia-calc-constant-imag" << std::endl;
		return INVALID_SETTINGS_VALUE;
	}
	stream.clear();
	settings_ptr->constant_imag = settings_double_value_holder;
	
	return OKAY;

}
