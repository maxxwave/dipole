
#include <iostream>
#include <cuda.h>
#include <cmath>
#include <cufft.h>

// include headers
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/cufields.h"
#include "../hdr/typedef.h"


namespace cuda{
	// defining the prefactor constant as a register for speed up the access
	//__constant__ cu_real_t pf = 10e23;

	__global__ void demag_field(long int  index,
				    double * sx_d,
				    double * sy_d,
				    double * sz_d,
				    double * Hx_d,
				    double * Hy_d,
				    double * Hz_d,
				    double * x_d,
				    double * y_x,
				    double * z_d,
				    double * H_tot_d )
	{
		
		//defining the index
		int tdx = blockIdx.x * blockDim.x + threadIdx.x;
		

		//return EXIT_SUCCESS;
	} // end of demag kernel


}//end of namepscare

