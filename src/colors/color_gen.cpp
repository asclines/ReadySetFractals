#include "color_gen.h"
#include <vector>
#include <qdbmp/qdbmp.h>

#include <iostream>

namespace color_gen{

void Set_Old_Color_Palette(BMP *bmp, int iterations, int offset){
	int max_colors = get_color_list_size();

	if(offset>=0){
	        for(int i = 0; i < iterations; i++){
                RGBColor color = Get_RGB_Color((i+offset)%max_colors);
                BMP_SetPaletteColor(bmp,i,color.red,color.green,color.blue);
	        }
	} else{
		for(int i=0; i<iterations; i++){
			BMP_SetPaletteColor(bmp,i,i,i,i);
		}
	}

}
void Set_Color_Palette(BMP *bmp, int iterations, int option){
	
	RGBColors colors;
	switch(option){
		case 1:
			colors = Preset1_Palette();
			break;
		case 2:
			colors = Katie_Palette();
			break;
		case 3:
			colors = Bee_Palette();
			break;
		default:
			for(int i=0; i<iterations; i++){
				BMP_SetPaletteColor(bmp,i,i,i,i);
			}
			return;
	}


//	BMP_SetPaletteColor(bmp,0,0,0,0);
	BMP_SetPaletteColor(bmp,0,255,255,255);
	
	int delta = iterations/colors.size() + 1;
	int index = 1;
	int color_index = 0;

	while(index <= iterations){
		for(int i=0; i<delta; i++){
			if(index<=iterations){
				BMP_SetPaletteColor(
					bmp,
					index,
					colors[color_index].red,
					colors[color_index].green,
					colors[color_index].blue
				);
			}
		}	
		index = index+delta;
		color_index++;
	}

}

RGBColors Katie_Palette(){
	RGBColors result;
	result.resize(100);
	for(int i=0; i<100; i++){
		result.push_back(Get_RGB_Color(50+i));
	}
	return result;
}


RGBColors Bee_Palette(){
        RGBColors result;
        result.resize(100);
        for(int i=0; i<100; i++){
                result.push_back(Get_RGB_Color(250+i));
        }
        return result;
}
		
RGBColors Preset1_Palette(){
	RGBColors result;
	result.resize(100);
	for(int i=0; i<100; i++){
		result.push_back(Get_RGB_Color(250+i));
	}
	return result;
}













} //End namespace
