#include <iostream>


// CUDA and thrust headers
#include <curand_kernel.h>
#include <thrust/copy.h>
#include <thrust/device_ptr.h>
#include <thrust/device_vector.h>
#include <thrust/fill.h>
#include <thrust/host_vector.h>
#include <thrust/iterator/constant_iterator.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/tuple.h>

#include <../library/cusp/copy.h>
#include <../library/cusp/csr_matrix.h>
#include <../library/cusp/dia_matrix.h>
//#include <cusp/ell_matrix.h>
//#include <cusp/multiply.h>

namespace cuda{
	typedef cusp::array1d <cu_real_t, cusp::dvice_memory> cu_real_array_t;
	typedef double cu_real_t;

}
