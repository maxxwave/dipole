
#include <iostream>
#include <vector>
#include <cuda.h>

//
// Dipolar headers
#include "../hdr/template.h"
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"
#include "../hdr/typedef.h"
#include "../hdr/cufields.h"




namespace cuda{
	// defining and block and grid of the device
	extern int block;
	extern int grid;
	// definint the coordinates uni-dimensional arrays
	extern std::vector <double> x_coord;
	extern std::vector <double> y_coord;
	extern std::vector <double> z_coord;
	// defining the spin array
	extern std::vector <double> sx;
	extern std::vector <double> sy;
	extern std::vector <double> sz;
	// defining the field arrays	
	extern std::vector <double> Hx_dip;
	extern std::vector <double> Hy_dip;
	extern std::vector <double> Hz_dip;
	// defininf the total field	
	extern std::vector <double> H_total;
	// defining the device arrays (spin values)
	extern cu_real_array_t sx_d;
	extern cu_real_array_t sy_d;
	extern cu_real_array_t sz_d;
	// defining the device array for coordinates
	extern cu_real_array_t x_d;
	extern cu_real_array_t y_d;
	extern cu_real_array_t z_d;
	// defining the field array device
	extern cu_real_array_t Hx_d;
	extern cu_real_array_t Hy_d;
	extern cu_real_array_t Hz_d;

	extern cu_real_array_t H_tot_d;
	//definimg the initialization routing of GPU
	extern void initialize_gpu();
	

}// end of namespace

