
#include <iostream>
#include <cuda.h>
#include "storage.h"
#include "template.h"
#include "create.h"
#include "typedef.h"

namespace cuda{
	// float pf;	
	__global__ void demag_field(long int, cu_real_t * sx_d, cu_real_t * sy_d,
					      cu_real_t * sz_d, cu_real_t * Hx_d, 
					      cu_real_t * Hy_d, cu_real_t * Hz_d ,
			 		      cu_real_t * x_d, cu_real_t * y_d,
					      cu_real_t * z_d, cu_real_t * H_tot_d) ; 
}
