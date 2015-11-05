#Compiler
CC = nvcc
ID = -I /usr/local/include #for location of qdbmp
IN = -I ./ #for internal files
DB = -g -G

#Locations
C = colors/
J = juliaset/
S = settings/

#Files
DEPS =  
CLRS = $(C)color_gen.h $(C)color_list.cpp
JSK = julia_set_kernel
JS = julia_set
SL = settings_loader

OBJS = $(JS).o $(JSK).o $(SL).o

#Make commands

all: install objclean

install: main.cu $(JSK).o $(JS).o $(SL).o $(DEPS) $(CLRS)
	$(CC) $(ID) $(IN) $(OBJS) -o fractal main.cu $(DB)

$(JS).o: $(J)$(JS).h $(J)$(JS).cu
	$(CC) $(ID) $(IN) -c $(J)$(JS).cu $(DB)

$(JSK).o: $(J)$(JSK).cuh $(J)$(JSK).cu
	$(CC) $(ID) $(IN) -c $(J)$(JSK).cu $(DB)

$(SL).o: $(S)$(SL).h $(S)$(SL).cpp
	$(CC) $(ID) $(IN) -c $(S)$(SL).cpp $(DB)

objclean:
	rm *.o

clean: objclean
	rm image.bmp fractal
