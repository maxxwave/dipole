// This code is dedicated to calculate the magnetostatic field and the demag field and covers the 5th task of Applications of HPC exam
// This code is coming with GNU licence and no warranty  is provided
// This code is accelerated using Cuda platform provided by nVidia 
// (C) Author: exam no Y3833878
// last update: 22nd of April, 2017
// This code is free to use and it can be downloaded from following link: https://github.com/maxxwave/dipole
//
// -----------------------------------------------------------------------------------------------------------------------------------------


#include <iostream>
#include <cuda.h>
#include <fstream>
#include <sstream>
#include <time.h>
#include <cstdlib>
//include demag headers
#include "../hdr/template.h"
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"
#include "../hdr/cufields.h"
#include "../hdr/demag.h"


int main(int argc, char* argv[]){
   //-----------------------------------------------------------------------------------------------------------
   // 1.0: Initialization part & creating the structure
   //-----------------------------------------------------------------------------------------------------------
   create::create_sc();
   
   //-----------------------------------------------------------------------------------------------------------
   // 2.0: Creating the ellipsoid shape
   //-----------------------------------------------------------------------------------------------------------

   // counting the time elapsed for demag routine on CPU
   // declaring the start and stop times
   clock_t start_1, stop_1;

   // calling the structure making routine
   create::elli(create::part_origin, create::r_e);

   // printing an informative message with the total number of particles including the particles outside of the ellipsoid
   std::cout <<"The total number of particles:"<<"\t"<<create::index << std::endl;
   std::cout <<"\n"<<std::endl;
   std::cout <<"Starting to calculate the demag field"<< std::endl;

   //click on start 
   start_1 = clock();
   // calling the field routine on CPU
   fields_t::demag_fields();
   // click on stop
   stop_1 = clock();

   //printing the time elapsed
   std::cout<<"Time on CPU"<<"\t"<<(stop_1-start_1)/CLOCKS_PER_SEC<<std::endl;

   //-------------------------------------------------------------------------------------------------------------
   // 2.1: printing the results
   //-------------------------------------------------------------------------------------------------------------
   // open file for output
   std::ofstream outfile;
   outfile.open("results_on_CPU.data");

   // printing the time elapsed for performing calculation on CPU
   outfile<<"Time on CPU"<<"\t"<<(stop_1-start_1)/CLOCKS_PER_SEC<<std::endl;

   //loop over all sites and print the field values
   for (int i=0; i<create::index; i++){

      // printing the fields values for each particle
      outfile<<st::H_dip[i].x<<"\t"<<st::H_dip[i].y<<"\t"<<st::H_dip[i].z<<std::endl;
      }// end of for

   // close the file
   outfile.close();
   
   //------------------------------------------------------------------------------------------------------------
   // 3.0: CUDA part
   // -----------------------------------------------------------------------------------------------------------
    
   //initialize GPU 
   std::cout<<"Starting calculate the demag field on CUDA:"<<std::endl; 
   // get number of blocks & threads from dee(GPU)
   // each block contains a certain number of threads
   // a device contains a certain number of blocks depending on the device capabilities 
   int block = atoi(argv[1]); // threads per block													
   int grid  = atoi(argv[2]); // blocks per grid
   
   // check right input parameters for getting number of threads and blocks
   if((block !=0) && (grid!=0) && (block<=1024)) { 
      //print an informative message
      std::cout<<"your cuda program has been successfully initialized with:" <<"\t"<<block<<"\t"<<"threads"<<"\t"<<"and"<<"\t"<<grid<<"\t"<<"blocks"<<std::endl;
   }// end of if
   else { //print an error msg
       std::cout<<"Please make sure your parameter are appropriate number for number of threads and blocks!"<<std::endl;
       std::cout<<"Be aware on your gpu card architecture. On Fermi architecture you are allowed to use only 1024 threads per block!"<<std::endl;
   } 

   // declare host arrays corresponding to coordinates, spins values, and fields
   // defining & initializing the pointers corresponding to each host array
   double * d_x=NULL,  * d_y=NULL,  * d_z=NULL;   // coordinates x,y,z
   double * d_Hx=NULL, * d_Hy=NULL, * d_Hz=NULL;  // fields x,y,z
   double * d_sx=NULL, * d_sy=NULL, * d_sz=NULL;  // spin components x,y,z
   double * d_H_total=NULL;                       // total field

   // defining the host vectors (the vectors dedicated to store information on CPU's memory) 
   // coordinates arrays
   std::vector <double> atom_h_x;
   std::vector <double> atom_h_y;
   std::vector <double> atom_h_z;
   // spin arrays
   std::vector <double> atom_h_sx;
   std::vector <double> atom_h_sy;
   std::vector <double> atom_h_sz;
   // fields arrays
   std::vector <double> atom_h_Hx;
   std::vector <double> atom_h_Hy;
   std::vector <double> atom_h_Hz;
   // total field
   std::vector <double> H_total;
   
   // resizing (with the total number of atoms inside the system) & initialization of the host arrays 
   atom_h_x.resize(create::index,0.0);
   atom_h_y.resize(create::index,0.0);
   atom_h_z.resize(create::index,0.0);
   
   atom_h_sx.resize(create::index,0.0);
   atom_h_sy.resize(create::index,0.0);
   atom_h_sz.resize(create::index,0.0);

   atom_h_Hx.resize(create::index,0.0);
   atom_h_Hy.resize(create::index,0.0);
   atom_h_Hz.resize(create::index,0.0);

   H_total.resize(3,0.0);
  
   // within this loop we convert the spin array and coordinates into unidimensional array being more flexible to pass to cuda kernel
   for(int i = 0; i<create::index; i++){ 

      atom_h_x[i]=st::atom[i].cx;
      atom_h_y[i]=st::atom[i].cy;
      atom_h_z[i]=st::atom[i].cz;
      
      atom_h_sx[i]=st::atom[i].sx;
      atom_h_sy[i]=st::atom[i].sy;
      atom_h_sz[i]=st::atom[i].sz;
   }// end of for loop

   // this part of the cumain function is dedicated to allocate memory onto device 
   // we use old directives for cuda making sure that the portability is provided for any Cuda version
   // these directives are a bit faster than thrust tools
   // it has been allocated enough memory to achieve a good accuracy through the double precision offered by Cuda
   // allocate memory for coordinates
   cudaMalloc((void**)&d_x, sizeof(double)*create::index);
   cudaMalloc((void**)&d_y, sizeof(double)*create::index);
   cudaMalloc((void**)&d_z, sizeof(double)*create::index);
   // allocate memory for spin values
   cudaMalloc((void**)&d_sx, sizeof(double)*create::index);
   cudaMalloc((void**)&d_sy, sizeof(double)*create::index);
   cudaMalloc((void**)&d_sz, sizeof(double)*create::index);
   // allocate memory for field values
   cudaMalloc((void**)&d_Hx, sizeof(double)*create::index);
   cudaMalloc((void**)&d_Hy, sizeof(double)*create::index);
   cudaMalloc((void**)&d_Hz, sizeof(double)*create::index);
   cudaMalloc((void**)&d_H_total, sizeof(double)*3);
   // within this step we copy data from host arrays to device array through the device pointers
   cudaMemcpy(d_x, &atom_h_x[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_y, &atom_h_y[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_z, &atom_h_z[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   // copy spins to device
   cudaMemcpy(d_sx, &atom_h_sx[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_sy, &atom_h_sy[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_sz, &atom_h_sz[0], sizeof(double)*create::index, cudaMemcpyHostToDevice);
   // copy fields to device
   cudaMemcpy(d_Hx, &atom_h_Hx[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_Hy, &atom_h_Hy[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_Hz, &atom_h_Hz[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_H_total, &H_total[0], sizeof(double)*3, cudaMemcpyHostToDevice); 

   // it is important to delete the memory while operations are performed on device in order to optimize the memory 
   atom_h_x.clear();
   atom_h_y.clear();
   atom_h_z.clear();
   atom_h_sx.clear();
   atom_h_sy.clear();
   atom_h_sz.clear();
   atom_h_Hx.clear();
   atom_h_Hy.clear();
   atom_h_Hz.clear();
   H_total.clear();
   
   // defining times for measuring the cuda routine
   cudaEvent_t start_2, stop_2;
   //clicking on start
   cudaEventCreate(&start_2);
   cudaEventCreate(&stop_2);
   cudaEventRecord(start_2);

   // synchronization of device in order to ensure that all threads works simultaneously 
   cudaThreadSynchronize();
    
   // we call kernel function and execute it 
   cuda::demag_field <<< grid,block >>> (create::index,
					   d_sx,
					   d_sy,
					   d_sz,
					   d_Hx,
					   d_Hy,
					   d_Hz,
					   d_x,
					   d_y,
					   d_z,
					   d_H_total
					  ); 
   // synchronization point 
   cudaThreadSynchronize();
   // we measure only the time elapsed for execution of kernel function
   cudaEventRecord(stop_2);
   cudaEventSynchronize(stop_2);
   // defining the elapsed time for measuring the bandwidth
   float elapsed_time1 = 0;
   //this will be in milliseconds 

   cudaEventElapsedTime(&elapsed_time1, start_2, stop_2);
   // printing the time elapsed for Cuda kernel
   std::cout<<"Cuda time:" <<"\t"<<elapsed_time1/1000<<"s"<<std::endl;
   
   // we can obtain information of the bandwidth of the device by measuring the time elapsed for copying a certain
   // amount of data
   // defining Cuda times
   cudaEvent_t start_3, stop_3;
   // create events
   cudaEventCreate(&start_3);
   cudaEventCreate(&stop_3);
   // start measuring
   cudaEventRecord(start_3);

   // copy data from device to host and de-allocate the memory into device  
   cudaMemcpy(&atom_h_x[0], d_x, sizeof(double)*create::index, cudaMemcpyDeviceToHost); 
   cudaMemcpy(&atom_h_y[0], d_y, sizeof(double)*create::index, cudaMemcpyDeviceToHost); 
   cudaMemcpy(&atom_h_z[0], d_z, sizeof(double)*create::index, cudaMemcpyDeviceToHost); 
   cudaMemcpy(&atom_h_sx[0], d_sx, sizeof(double)*create::index, cudaMemcpyDeviceToHost);  
   cudaMemcpy(&atom_h_sy[0], d_sy, sizeof(double)*create::index, cudaMemcpyDeviceToHost); 
   cudaMemcpy(&atom_h_sz[0], d_sz, sizeof(double)*create::index, cudaMemcpyDeviceToHost); 
   cudaMemcpy(&atom_h_Hx[0], d_Hx, sizeof(double)*create::index, cudaMemcpyDeviceToHost); 
   cudaMemcpy(&atom_h_Hy[0], d_Hy, sizeof(double)*create::index, cudaMemcpyDeviceToHost); 
   cudaMemcpy(&atom_h_Hz[0], d_Hz, sizeof(double)*create::index, cudaMemcpyDeviceToHost); 
   cudaMemcpy(&H_total[0], d_H_total, sizeof(double)*3, cudaMemcpyDeviceToHost); 
   
   // a synchronization point is needed 
   cudaThreadSynchronize();
   
   // stop the clock
   cudaEventRecord(stop_3);
   cudaEventSynchronize(stop_3);
   
   float elapsed_time2 =0;
   //computing elapsed time
   cudaEventElapsedTime(&elapsed_time2, start_3, stop_3);
   
   // print the bandwidth of the device according to CUDA documentation
   // more information can be found on following website: https://devblogs.nvidia.com/parallelforall/author/mharris/

   std::cout<<"The bandwidth is:"<<"\t"<<
   (sizeof(double)*(9*create::index+3))/(elapsed_time2*1e6)<<"\t"<<"GB/s"<<std::endl;

   // deallocate memory from device: coordinate & spins values & field values & total field
   cudaFree(d_x); 
   cudaFree(d_y); 
   cudaFree(d_z); 
   cudaFree(d_sx); 
   cudaFree(d_sy); 
   cudaFree(d_sz); 
   cudaFree(d_Hx); 
   cudaFree(d_Hy); 
   cudaFree(d_Hz); 
   cudaFree(d_H_total); 
	
   // print out results
   std::ofstream cuoutfile;
   // declaring a separate outputfile for cuda results
   cuoutfile.open("Curesults.data");
   // print the header of results file
   cuoutfile << "x"<<"\t"<<"y"<<"\t"<<"z"<<"\t"<<"Hz"<<std::endl;
   // loop over all sites and print the spin and coordinates values
   for (int i=0; i<create::index; i++){
       cuoutfile << atom_h_x[i]<<"\t"
                 << atom_h_y[i]<<"\t"
                 << atom_h_z[i]<<"\t"
                 << atom_h_Hz[i]<<std::endl;
   }// end of for loop
       
   // close the file
   cuoutfile.close();
   
   return 0;
}
