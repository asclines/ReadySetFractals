#Compiler macors
CC = nvcc
CFLAGS = -std=c++11
IN = -I ./ -I ./include #for includes
DB = -g -G # For cuda debugging

#Locations
F = fractal-generator/

#Names
FUNC = function #  $(f)functions.h $(f)functions.inl 
GEN = generator #$(f)generator.h $(f)generator.cu
FKERN = kernel #$(f)kernel.h $(f)kernel_internal.h $(f)kernel.cu
C = complex
CMPLX = complex #$(c)complex.h $(c)complex.inl


OBJS = generator.o


#Make commands

all: install objclean

install: main.cu $(OBJS)
	$(CC) $(CFLAGS) $(IN) generator.o -o program main.cu $(DB) 

generator.o: $(F)generator.h $(F)generator.cu $(F)kernel.h $(F)kernel_internal.h $(F)kernel.inl $(F)kernel.cu
	$(CC) $(CFLAGS) $(IN) -c $(F)generator.cu $(DB)

clean: 
	rm  *.o *.bmp program


objclean:
	rm *.o

