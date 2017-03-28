
#include <iostream>
#include <cuda.h>
#include "storage.h"
#include "template.h"
#include "create.h"
#include "typedef.h"

namespace cuda{
	// float pf;	
	__global__ void demag_field(long int, double*, double*, double*, double*, double*, double*, double*, double*, double*, double*); 
}
