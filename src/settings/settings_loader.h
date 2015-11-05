#ifndef SETTINGS_LOADER_H
#define SETTINGS_LOADER_H

#include <iostream>

/* Forward Declarations */
class JuliaSet;

/* Structs & Enums */
enum SettingsLoaderError{
	OKAY = 0,
	COULD_NOT_OPEN_FILE = 1,
	INVALID_SETTINGS_KEY = 2,
	INVALID_SETTINGS_VALUE = 3,
};


const std::string settings_loader_error_strings[] = {
					"Okay",
					"Could not open file",
					"Invalid settings key",
					"Invalid settings value"
						};


/* Public Methods */
SettingsLoaderError LoadSettingsFromSettingsFile(JuliaSet *julia_set_ptr, bool *image_in_color, int *color_offset);

SettingsLoaderError LoadSettingsFromFile(std::string file_name, JuliaSet *julia_set_ptr, bool *image_in_color, int *color_offset);


#endif
