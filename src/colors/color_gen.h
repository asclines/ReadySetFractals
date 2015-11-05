#ifndef COLOR_GEN_H
#define COLOR_GEN_H

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


RGBColor get_rgb_color(int index);

int get_color_list_size();

#include "color_list.cpp"
#endif
