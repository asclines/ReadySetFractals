#ifndef SETTINGS_LOADER_H
#define SETTINGS_LOADER_H

#include <generator.h>

#include <iostream>

namespace fractal_generator{

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
SettingsLoaderError LoadSettingsFromSettingsFile(
			FractalSettings *fractal_settings_ptr,
			ColorSettings *color_settings_ptr
			);

SettingsLoaderError LoadSettingsFromFile(
			std::string file_name,
			FractalSettings *fractal_settings_ptr,
                        ColorSettings *color_settings_ptr
                        );

} //end namespace
#endif
