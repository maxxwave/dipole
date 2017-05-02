#!/bin/bash

nvcc src/main.cu src/fields.cpp src/initilize_gpu.cu src/storage.cpp src/create_sc.cpp src/cufields.cu -I/cmgdata/rva502/AoHPC_exam/library

