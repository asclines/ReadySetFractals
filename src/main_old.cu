#include <iostream>
#include <fstream>
#include <string>
#include <vector>

#include <juliaset/julia_set.h>
#include <settings/settings_loader.h>


int main(int argc, const char *argv[]){
	JuliaSet julia_set;
	bool image_in_color;
	int color_offset;

	SettingsLoaderError settings_loader_error = LoadSettingsFromSettingsFile(&julia_set, &image_in_color, &color_offset);

	if(settings_loader_error != OKAY){
		std::cout << "Settings error: " << settings_loader_error_strings[settings_loader_error] << std::endl;
		return settings_loader_error;
	}
		
	julia_set.GeneratePixels();
	
	if(image_in_color){
		julia_set.GenerateColorImage(color_offset,"image.bmp");
	}else{	
		julia_set.GenerateBWImage("image.bmp"); 
	}

	return 0;
}


