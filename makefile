#LIBS=-lm -lfftw3
all: DIPOLAR
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


