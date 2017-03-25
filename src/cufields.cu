
#include <iostream>
#include <cuda.h>
#include <cmath>
#include <cufft.h>

// include headers
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/cufields.h"

namespace cuda{
	// defining the prefactor constant as a register for speed up the access
	//__constant__ float pf = 10e23;

	__global__ void demag_field(int index,
				    cu_real_array_t * sx_d,
				    cu_real_array_t * sy_d)
	{

		//defining the index
		int tdx = blockIdx.x * blockDim.x + threadIdx.x;

		//return EXIT_SUCCESS;
	} // end of demag kernel


}//end of namepscare
