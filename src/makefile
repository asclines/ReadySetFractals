#Compiler macors
CC = nvcc
CFLAGS = -std=c++11
IN = -I ./ -I ./include #for includes
DB = -g -G # For cuda debugging

#Locations
F = fractal-generator/
S = settings/
C = colors/

#Names
FUNC = function #  $(f)functions.h $(f)functions.inl 
GEN = generator #$(f)generator.h $(f)generator.cu
FKERN = kernel #$(f)kernel.h $(f)kernel_internal.h $(f)kernel.cu
CMPLX = complex #$(c)complex.h $(c)complex.inl


OBJS = generator.o settings_loader.o


#Make commands

all: install

install: main.cu $(OBJS)
	$(CC) $(CFLAGS) $(IN) $(OBJS) -o program main.cu $(DB) 

generator.o: $(F)generator.h $(F)generator.cu $(F)kernel.h $(F)kernel_internal.h $(F)kernel.inl $(F)kernel.cu
	$(CC) $(CFLAGS) $(IN) -c $(F)generator.cu $(DB)

settings_loader.o: generator.o  $(S)settings_loader.h $(S)settings_loader.cu
	$(CC) $(CFLAGS) $(IN) -c $(S)settings_loader.cu $(DB)

color_gen.o: $(C)color_gen.h $(C)color_list.cpp $(C)color_gen.cpp
	$(CC) $(CFLAGS) $(IN) -c $(C)color_gen.cpp $(DB)

clean: 
	rm  *.o *.bmp program


objclean:
	rm *.o

