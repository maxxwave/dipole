
#include <iostream>
#include <cuda.h>
#include "storage.h"
#include "template.h"
#include "create.h"

namespace cuda{
	// double pf;	
	__global__ void demag_field(const unsigned long int,
					      double * sx_d, double * sy_d,
					      double * sz_d, double * Hx_d, 
					      double * Hy_d, double * Hz_d ,
			 		      double * x_d, double * y_d,
					      double * z_d, double * H_tot_d) ; 
}
