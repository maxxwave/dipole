#LIBS=-lm -lfftw3
all: DIPOLAR
<<<<<<< HEAD
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
=======
CXX=g++
EXE= DIPOLAR
DIPOLAR: main.o create_sc.o  fields.o storage.o  

	g++ main.o create_sc.o fields.o  storage.o -o DIPOLAR
main.o: src/main.cpp

	g++ -c src/main.cpp

create.o: src/create_sc.cpp

	g++ -c src/create_sc.cpp

fields.o: src/fields.cpp

	g++ -c src/fields.cpp

storage.o: src/storage.cpp
	 
	 g++ -c src/storage.cpp

clean:
	rm ./*.o 


>>>>>>> 6551780858f46e4d66a2861ab68cb5fed9b41527
