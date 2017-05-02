// This program is a part of Dipolar field calculation
//
//
// This routine is dedicated to create the spin, coordinates and field's array required to pass information to GPU
//
// We used CUSP library in order to have double precision 

#include <iostream>
#include <vector>
#include <cuda.h>


// these are the libraries needed to manage the array for device

// Dipolar headers
#include "../hdr/template.h"
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"
#include "../hdr/typedef.h"


namespace cuda{
	
	void initialize_gpu(){
		
		// get number of blocks & threads from dee(GPU)
		// each block contains a certain number of threads
		// a device contains a certain number of blocks depending on the device capabilities 
		int block = 1024; // 1024 blocks pe grid
													
		int grid  = 128; // 128 grids per device
		///////////////////  1024 X 128 = 131072 threads executed in parallel////////////////
		
		// defining some uni dimensional array
		// in following lines of code we convert the class of spin array and field array into unidimensional array to be able to pass them to kernel
		// coordinates arrays
		std::vector <double> x_coord(create::index);
		std::vector <double> y_coord(create::index);
		std::vector <double> z_coord(create::index);
		// spin arrays
		std::vector <double> sx(create::index);
		std::vector <double> sy(create::index);
		std::vector <double> sz(create::index);
		//demag field arrays	
		std::vector <double> Hx_dip(create::index);
		std::vector <double> Hy_dip(create::index);
		std::vector <double> Hz_dip(create::index);
		// defining a 3-component vector in order to store the summation of all atoms field		 
		std::vector <double> H_total(3,0.0);
	
		// copy the values of the spins and coordinates of the atoms after creating the structure & initialization to new arrays
		for(int i=0; i<create::index ; i++){
			//copying the coordinates
			x_coord[i]=st::atom[i].cx;
			y_coord[i]=st::atom[i].cy;
			z_coord[i]=st::atom[i].cz;
			// copyinh the spins values
			sx[i]=st::atom[i].sx;
			sy[i]=st::atom[i].sy;
			sz[i]=st::atom[i].sz;
			// TODO
			// also for a general case we should create some arrays for the magnitude of the magnetic moment of each atom
		}// end of for loop
		
		// following we create device array and also alocate memory to device
		// a nice way to do it using CUSP library in order to avoid cuMemcpy and other ugly stuff
		// another benefit of this is double precision offered by this typedef (../hdr/typede.h)
		thrust::device_vector<double> sx_d(create::index);
		thrust::device_vector<double> sy_d(create::index);
		thrust::device_vector<double> sz_d(create::index);
		
		// coordinate arrays
		thrust::device_vector<double> x_d(create::index);
		thrust::device_vector<double> y_d(create::index);
		thrust::device_vector<double> z_d(create::index);

		// field arrays
		thrust::device_vector<double> Hx_d(create::index);
		thrust::device_vector<double> Hy_d(create::index);
		thrust::device_vector<double> Hz_d(create::index);
		// total field obtained by summation of each atom	
		thrust::device_vector<double> H_tot_d(create::index);

		// copy data to device 
		// copy spin values
		thrust::copy( sx.begin(), sx.end(), sx_d.begin());
		thrust::copy( sy.begin(), sy.end(), sy_d.begin());
		thrust::copy( sz.begin(), sz.end(), sz_d.begin());
		
		// copy coordinates
		thrust::copy( x_coord.begin(), x_coord.end(), x_d.begin());
		thrust::copy( y_coord.begin(), y_coord.end(), y_d.begin());
		thrust::copy( z_coord.begin(), z_coord.end(), z_d.begin());

		// copy field arrays
		thrust::copy( Hx_dip.begin(), Hx_dip.end(), Hx_d.begin());
		thrust::copy( Hy_dip.begin(), Hy_dip.end(), Hy_d.begin());
		thrust::copy( Hz_dip.begin(), Hz_dip.end(), Hz_d.begin());

		thrust::copy( H_total.begin(), H_total.end(), H_tot_d.begin());

	}// end of routine
}// end of namespace
