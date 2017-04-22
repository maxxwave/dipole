#!/bin/bash

string=$1
if(string='-serial')
then
   g++ -O3 src/create_sc.cpp src/main.cpp src/fields.cpp src/storage.cpp src/test.cpp -o serial
elif(string='-cuda')
then 
   nvcc -O3 src/create_sc.cpp src/cumain.cu src/fields.cpp src/storage.cpp src/cufields.cu -o cuda
fi 
