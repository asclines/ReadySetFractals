#ifndef COLOR_GEN_H
#define COLOR_GEN_H

#include <vector>
#include <qdbmp/qdbmp.h>

namespace color_gen{

struct RGBColor{
	int red;
	int green;
	int blue;

	void set(int r,int g,int b){
		red=r;
		green = g;
		blue = b;
	}
};

typedef std::vector<RGBColor> RGBColors;

RGBColor Get_RGB_Color(int index);

void Set_Old_Color_Palette(BMP *bmp, int iterations, int offset);

void Set_Color_Palette(BMP *bmp, int iterations, int option);

/*
	Color Palette Methods
*/


//Option 1
RGBColors Preset1_Palette();

//Option 2
RGBColors Katie_Palette();

//Option 3
RGBColors Bee_Palette();



int get_color_list_size();

} //End namespace
#include "color_list.cpp"
#include "color_gen.cpp"
#endif
