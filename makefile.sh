#!/bin/bash

<<<<<<< HEAD
g++ -O3  -g src/main.cpp src/create_sc.cpp src/storage.cpp src/fields.cpp src/test.cpp src/demag.cpp -o Serial

nvcc -g -O3 src/cumain.cu src/cufields.cu src/create_sc.cpp src/storage.cpp src/fields.cpp -o CUDA
=======
nvcc src/main.cu src/fields.cpp src/initilize_gpu.cu src/storage.cpp src/create_sc.cpp src/cufields.cu -I/cmgdata/rva502/AoHPC_exam/library

>>>>>>> 46dfe907eb4023dfbf695598181d2ddab87c09d9
