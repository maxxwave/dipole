
#include <iostream>
#include <cuda.h>
#include "storage.h"
#include "template.h"
#include "create.h"
<<<<<<< HEAD

namespace cuda{
	// double pf;	
	__global__ void demag_field(const unsigned long int,
					      double * sx_d, double * sy_d,
					      double * sz_d, double * Hx_d, 
					      double * Hy_d, double * Hz_d ,
			 		      double * x_d, double * y_d,
					      double * z_d, double * H_tot_d) ; 
=======
#include "typedef.h"

namespace cuda{
	// float pf;	
	__global__ void demag_field(long int, cu_real_t * sx_d, cu_real_t * sy_d,
					      cu_real_t * sz_d, cu_real_t * Hx_d, 
					      cu_real_t * Hy_d, cu_real_t * Hz_d ,
			 		      cu_real_t * x_d, cu_real_t * y_d,
					      cu_real_t * z_d, cu_real_t * H_tot_d) ; 
>>>>>>> 46dfe907eb4023dfbf695598181d2ddab87c09d9
}
