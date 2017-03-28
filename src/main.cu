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

   // run create
   create::create_sc();
   create::elli(create::part_origin, create::r_e);
   std::cout << create::index << std::endl;
   for(int i =0; i<create::index; i++){
        std::cout<<st::atom[i].cx<<"\t"<<st::atom[i].cy<<"\t"<<st::atom[i].cz <<"\t"<<st::atom[i].sz<<std::endl;
      }

   std::cout<<"Starting to calculate the demag field"<< std::endl;
   std::cout<<"Total number of atoms is:"<<"\t"<<create::index<<std::endl;
  // fields_t::demag_fields();
   //std::cout<<st::H_total[0]<<"T"<<std::endl;



   //---------------------------------------------------------------------------------------
   // Cuda part
   // --------------------------------------------------------------------------------------
   // #ifdef CUDA
   //initialize GPU 
   cuda::initialize_gpu(); 
   cuda::demag_field<<< cuda::block,cuda::grid >>>(create::index,
					   cuda::sx_d,
					   cuda::sy_d,
					   cuda::sz_d,
					   cuda::Hx_d,
					   cuda::Hy_d,
					   cuda::Hz_d,
					   cuda::x_d,
					   cuda::y_d,
					   cuda::z_d,
					   cuda::H_tot_d
					  ); 
   //#endif
   return 0;
}
