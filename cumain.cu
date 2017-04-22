// This code is dedicated to calculate the magnetostatic field and the demag field and covers the 5th task of Applications of HPC exam
// This code is coming with GNU licence and no guaranty is provided
// This code is accelerated using Cuda platform provided by nVidia 
// Author: XXX@york.ac.uk 
// last update: 22nd of April
// This code is free to use and it can be downloaded from following link: https://github.com/maxxwave/dipole
//
// -----------------------------------------------------------------------------------------------------------------------------------------


#include <iostream>
#include <cuda.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>


#include "../hdr/template.h"
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"
//#include "../hdr/typedef.h"
#include "../hdr/cufields.h"
//#include "../hdr/initialize_gpu.h"

int main(){

   // Initialization part & creating the structure----------------------------------------------------------
   create::create_sc();
   // creating the ellipsoid shape
   create::elli(create::part_origin, create::r_e);
   //
   std::cout << create::index << std::endl;
   // --------------------------------------------------------------------------------------------------------
   //for(int i =0; i<create::index; i++){
   //     std::cout<<st::atom[i].cx<<"\t"<<st::atom[i].cy<<"\t"<<st::atom[i].cz <<"\t"<<st::atom[i].sz<<std::endl;
   //   }

   std::cout<<"Starting to calculate the demag field"<< std::endl;
   std::cout<<"Total number of atoms is:"<<"\t"<<create::index<<std::endl;
   fields_t::demag_fields();
   std::cout<<st::H_total[0]<<"\t"<<st::H_total[1]<<"\t"<<st::H_total[2]<<std::endl;

   //---------------------------------------------------------------------------------------
   // Cuda part
   // --------------------------------------------------------------------------------------
   // #ifdef CUDA
   //initialize GPU 
   std::cout<<"Starting calculate the demag field on CUDA:"<<std::endl; 
   // get number of blocks & threads from dee(GPU)
	// each block contains a certain number of threads
	// a device contains a certain number of blocks depending on the device capabilities 
	const unsigned int block = 1024; // threads per block													
	const unsigned int grid  = 1; // blocks per grid
	

   // declare host arrays corresponding to coordinates, spins values, and fields
   //-----------------------------------------------------------------------------------------------------
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
   //----------------------------------------------------------------------------------------------------------
   cudaMalloc((void**)&d_x, sizeof(double)*create::index);
   cudaMalloc((void**)&d_y, sizeof(double)*create::index);
   cudaMalloc((void**)&d_z, sizeof(double)*create::index);

   cudaMalloc((void**)&d_sx, sizeof(double)*create::index);
   cudaMalloc((void**)&d_sy, sizeof(double)*create::index);
   cudaMalloc((void**)&d_sz, sizeof(double)*create::index);

   cudaMalloc((void**)&d_Hx, sizeof(double)*create::index);
   cudaMalloc((void**)&d_Hy, sizeof(double)*create::index);
   cudaMalloc((void**)&d_Hz, sizeof(double)*create::index);
   cudaMalloc((void**)&d_H_total, sizeof(double)*3);
  
   // within this step we copy data from host arrays to device array through the device pointers
   cudaMemcpy(d_x, &atom_h_x[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_y, &atom_h_y[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_z, &atom_h_z[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 

   cudaMemcpy(d_sx, &atom_h_sx[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_sy, &atom_h_sy[0], sizeof(double)*create::index, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_sz, &atom_h_sz[0], sizeof(double)*create::index, cudaMemcpyHostToDevice);

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

   // synchronization of device in order to ensure that all threads works simultaneously 
   cudaThreadSynchronize();

   // we call kernel function and execution--------------------------------------------------------------
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
   //------------------------------------------------------------------------------------------------------
   cudaThreadSynchronize();
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
   cudaThreadSynchronize();
   // dellocate memory from device
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

	for(int i =0; i<create::index; i++){
	   std::cout<<atom_h_x[i]<<"\t"
		<<atom_h_y[i]<<"\t"
		<<atom_h_z[i]<<"\t"
		<<atom_h_sx[i]<<"\t"
		<<atom_h_sy[i]<<"\t"
		<<atom_h_sz[i]<<"\t"
		<<atom_h_Hx[i]<<"\t"
		<<atom_h_Hy[i]<<"\t"
		<<atom_h_Hz[i]<<"\t"
		<<std::endl;
      } 

    std::cout<<H_total[0]<<"\t"<<H_total[1]<<"\t"<<H_total[2]<<std::endl;
   
   //#endif

   // print the results part!
   // TODO
   return 0;
}
