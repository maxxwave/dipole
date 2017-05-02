#!/bin/bash

g++ -O3  -g src/main.cpp src/create_sc.cpp src/storage.cpp src/fields.cpp src/test.cpp src/demag.cpp -o Serial

nvcc -g -O3 src/cumain.cu src/cufields.cu src/create_sc.cpp src/storage.cpp src/fields.cpp -o CUDA
