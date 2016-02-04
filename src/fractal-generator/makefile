#Compiler macors
CC = nvcc
CFLAGS = -std=c++11
IN = -I ./ #for includes
DB = -g -G # For cuda debugging


#Make commands
install: gen.o

gen.o: generator.h generator.cu kernel.h kernel_internal.h kernel.inl
	$(CC) $(CFLAGS) $(IN) -c generator.cu $(DB)

clean:
	rm *.o 
