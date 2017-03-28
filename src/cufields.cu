
#include <iostream>
#include <cuda.h>
#include <cmath>
#include <cufft.h>

// include headers
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/cufields.h"
#include "../hdr/typedef.h"
#include "../hdr/initialize_gpu.h"

namespace cuda{
	// defining the prefactor constant as a register for speed up the access
	
	 //check_cuda_errors (__FILE__, __LINE__);
	// we declare this constat as a register to be very fast each time when it is called
	__device__ __constant__ double cupf = 10e23;	// this is the prefactor that incorporates the magnetic moment and other constants

	__global__ void demag_field(long int  index,
				    cu_real_t * sx_d,
				    cu_real_t * sy_d,
				    cu_real_t * sz_d,
				    cu_real_t * Hx_d,
				    cu_real_t * Hy_d,
				    cu_real_t * Hz_d,
				    cu_real_t * x_d,
				    cu_real_t * y_x,
				    cu_real_t * z_d,
				    cu_real_t * H_tot_d )
	{
		// loop over all threads and assign a thread per atom
		// this loop is dedicated to cover all atoms(sites) if the number of atoms is larger than the maximum number of threads allowed
		for ( int tdx = blockIdx.x * blockDim.x + threadIdx.x;	//here we define the index
			tdx < index;
			tdx += blockDim.x * gridDim.x // we load a maximum threads allowed
		){

			for(int j=0; j < index; j++){
				
				cu_real_t dx = sx_d[j] - sx_d[tdx];
				cu_real_t dy = sy_d[j] - sy_d[tdx];
				cu_real_t dz = sx_d[j] - sz_d[tdx];
				
				cu_real_t r = sqrt(dx*dx + dy*dy + dz*dz);	
				cu_real_t r_cube = 1.0/r*r*r;

				Hx_d[tdx] += cupf * (3.0*dx*(dx*sx_d[j]) - sx_d[j])*r_cube; 	
				Hy_d[tdx] += cupf * (3.0*dy*(dy*sy_d[j]) - sy_d[j])*r_cube; 	
				Hz_d[tdx] += cupf * (3.0*dz*(dz*sz_d[j]) - sz_d[j])*r_cube; 	
	
		
			} // end of j for	
			H_tot_d[0] += Hx_d[tdx];
			H_tot_d[1] += Hy_d[tdx];
			H_tot_d[2] += Hz_d[tdx];
		} //end of tdx for 
		//return EXIT_SUCCESS;
	} // end of demag kernel


}//end of namepscare

