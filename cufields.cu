// This code is dedicated to calculate the magnetostatic field and the demag field and covers the 5th task of Applications of HPC exam
// This code is coming with GNU licence and no warranty  is provided
// This code is accelerated using Cuda platform provided by nVidia 
// (C) Author exam number: Y3833878
// last update: 22nd of April, 2017
// This code is free to use and it can be downloaded from following link: https://github.com/maxxwave/dipole
//
// -----------------------------------------------------------------------------------------------------------------------------------------

#include <iostream>
#include <cuda.h>
#include <cmath>
// this library is needed for our further fft method which is under progress
#include <cufft.h>
#include <stdio.h>
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/cufields.h"
namespace cuda{
   // defining the pre-factor constant as a register for speed up the access
   //check_cuda_errors (__FILE__, __LINE__);
   // we declare this constant as a register to be very fast each time when it is called

   __device__ __constant__ double cupf =  0.00009274;;	// this is the pre-factor that incorporates the magnetic moment
   // and other. See field.cpp line 51
   __device__ __constant__ double cupf_2 = 8.0*3.14*0.3333333333333;
   __global__ void demag_field(const unsigned long int  index,
				    double * sx_d,
				    double * sy_d,
				    double * sz_d,
                double * Hx_d,
				    double * Hy_d,
				    double * Hz_d,
				    double * x_d,
				    double * y_d,
				    double * z_d,
				    double * H_tot_d ){
       // declaring the radii components as a register in order to speed up the calculations 
       register double dx=0.0;
       register double dy=0.0;
       register double dz=0.0;
       register double r=0.0;
       register double r_cube=0.0;             

      // a synchronization point is needed to ensure all threads will work simultaneously 
      __syncthreads();

      // loop over all threads and assign a thread per atom
      // this loop is dedicated to cover all atoms(sites) if the number of atoms is larger than the maximum number of threads allowed
      for ( register int tdx = blockIdx.x * blockDim.x + threadIdx.x;	//here we define the index
         tdx < index;
         tdx += blockDim.x * gridDim.x // we load a maximum threads allowed
         ){	
         for(int j=0; j < index; j++){
	        if(tdx!=j){
	           dx = x_d[j] - x_d[tdx];
	           dy = y_d[j] - y_d[tdx];
		       dz = z_d[j] - z_d[tdx];
		       r =  sqrt(dx*dx + dy*dy + dz*dz);	
		       r_cube = 1.0/r*r*r;
		       Hx_d[tdx] += cupf * (3.0*dx*(dx*sx_d[j]) - sx_d[j])*r_cube; 	
		       Hy_d[tdx] += cupf * (3.0*dy*(dy*sy_d[j]) - sy_d[j])*r_cube; 	
		       Hz_d[tdx] += cupf * (3.0*dz*(dz*sz_d[j]) - sz_d[j])*r_cube; 	
               
             }// end of if 
             else{
                 Hx_d[tdx] += cupf*(cupf_2*sx_d[tdx]);
                 Hy_d[tdx] += cupf*(cupf_2*sy_d[tdx]);
                 Hz_d[tdx] += cupf*(cupf_2*sz_d[tdx]);
             }// end of else 
               
               // synchronization point 
               __syncthreads();

          } // end of j for	


          H_tot_d[0] += Hx_d[tdx];
	      H_tot_d[1] += Hy_d[tdx];
	      H_tot_d[2] += Hz_d[tdx];

          //synchronization point 
          __syncthreads();

      } //end of tdx for 

   } // end of demag kerne


}//end of namepscare

