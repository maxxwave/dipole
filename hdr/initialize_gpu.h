
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
	extern std::vector <double> x_coord();
	extern std::vector <double> y_coord();
	extern std::vector <double> z_coord();
	// defining the spin array
	extern std::vector <double> sx();
	extern std::vector <double> sy();
	extern std::vector <double> sz();
	// defining the field arrays	
	extern std::vector <double> Hx_dip();
	extern std::vector <double> Hy_dip();
	extern std::vector <double> Hz_dip();
	// defininf the total field	
	extern std::vector <double> H_total();
	// defining the device arrays (spin values)
	extern double sx_d();
	extern double sy_d();
	extern double sz_d();
	// defining the device array for coordinates
	extern double x_d();
	extern double y_d();
	extern double z_d();
	// defining the field array device
	extern double Hx_d();
	extern double Hy_d();
	extern double Hz_d();

	extern double H_tot_d();
	//definimg the initialization routing of GPU
	extern void initialize_gpu();
	

}// end of namespace

