#LIBS=-lm -lfftw3
all: DIPOLAR
CXX=nvcc
EXE= DIPOLAR
DIPOLAR: main.o create_sc.o  fields.o storage.o  cufields.o

	nvcc main.o create_sc.o fields.o  storage.o cufields.o -o DIPOLAR

main.o: src/main.cu

	nvcc  src/main.cu

create_sc.o: src/create_sc.cpp

	nvcc src/create_sc.cpp

fields.o: src/fields.cpp

	nvcc src/fields.cpp

storage.o: src/storage.cpp
	 
	 nvcc  src/storage.cpp

cufields.o: src/cufields.cu
	
	nvcc cufields.cu

clean:
	rm *.o 
