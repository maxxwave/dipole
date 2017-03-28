#include <iostream>
#include <cuda.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <curand_kernel.h>
#include <thrust/copy.h>
#include <thrust/device_ptr.h>
#include <thrust/device_vector.h>
#include <thrust/fill.h>
#include <thrust/host_vector.h>
#include <thrust/iterator/constant_iterator.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/tuple.h>
#include <cusp/copy.h>
#include <cusp/csr_matrix.h>
#include <cusp/dia_matrix.h>
#include <cusp/ell_matrix.h>
#include <cusp/multiply.h>


#include "../hdr/template.h"
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"
#include "../hdr/typedef.h"
#include "../hdr/cufields.h"
#include "../hdr/initialize_gpu.h"

int main(){

   // Iinitialization part & creating the structure----------------------------------------------------------
   create::create_sc();
   // creating the ellipsoid shape
   create::elli(create::part_origin, create::r_e);
   //
   std::cout << create::index << std::endl;
   // --------------------------------------------------------------------------------------------------------
/*   for(int i =0; i<create::index; i++){
        std::cout<<st::atom[i].cx<<"\t"<<st::atom[i].cy<<"\t"<<st::atom[i].cz <<"\t"<<st::atom[i].sz<<std::endl;
      }

   std::cout<<"Starting to calculate the demag field"<< std::endl;
   std::cout<<"Total number of atoms is:"<<"\t"<<create::index<<std::endl;
  // fields_t::demag_fields();
   //std::cout<<st::H_total[0]<<"T"<<std::endl;

*/

   //---------------------------------------------------------------------------------------
   // Cuda part
   // --------------------------------------------------------------------------------------
   // #ifdef CUDA
   //initialize GPU 
   cuda::initialize_gpu();

   // in this step we create some associated pointers to our arrays on device to be able to pass into kernel
   //------------------------------------------------------------------------------------------------------
   cuda::cu_real_t * d_sx = thrust::raw_pointer_cast(cuda::sx_d.data());
   cuda::cu_real_t * d_sy = thrust::raw_pointer_cast(cuda::sy_d.data());
   cuda::cu_real_t * d_sz = thrust::raw_pointer_cast(cuda::sz_d.data());
 
   cuda::cu_real_t * d_x = thrust::raw_pointer_cast(cuda::x_d.data());
   cuda::cu_real_t * d_y = thrust::raw_pointer_cast(cuda::y_d.data());
   cuda::cu_real_t * d_z = thrust::raw_pointer_cast(cuda::z_d.data());

   cuda::cu_real_t * d_Hx = thrust::raw_pointer_cast(cuda::Hx_d.data());
   cuda::cu_real_t * d_Hy = thrust::raw_pointer_cast(cuda::Hy_d.data());
   cuda::cu_real_t * d_Hz = thrust::raw_pointer_cast(cuda::Hz_d.data());
   cuda::cu_real_t * d_H_total = thrust::raw_pointer_cast(cuda::H_tot_d.data());
   //-----------------------------------------------------------------------------------------------------
  
   // we call kernel function and execution--------------------------------------------------------------
   cuda::demag_field<<< cuda::block,cuda::grid >>>(create::index,
					   d_sx,
					   d_sy,
					   d_sz,
					   d_Hx,
					   d_Hy,
					   d_Hz,
					   d_x,
					   d_y,
					   d_z,
					   d_H_total
					  ); 
   //------------------------------------------------------------------------------------------------------
  
   // copy data from device to host and de-allocate the memory into device 
   
   
   //#endif

   // print the results part!
   // TODO
   return 0;
}
