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
//#include <cusp/copy.h>
//#include <cusp/csr_matrix.h>
//#include <cusp/dia_matrix.h>
//#include <cusp/ell_matrix.h>
//#include <cusp/multiply.h>


#include "../hdr/template.h"
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"
<<<<<<< HEAD
#include "../hdr/typedef.h"
=======
>>>>>>> 6551780858f46e4d66a2861ab68cb5fed9b41527
//#include "../hdr/cufields.h"
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

   //int N=1024;
   int block=128;
   int grid=1024;
   std::vector <double> x_coord;
   x_coord.resize(create::index);
   std::vector <double> y_coord;
   y_coord.resize(create::index);
   std::vector <double> z_coord;
   z_coord.resize(create::index);
   std::vector <double> H_dip_x;
   H_dip_x.resize(create::index);
   std::vector <double> H_dip_y;
   H_dip_y.resize(create::index);
   std::vector <double> H_dip_z;
   H_dip_z.resize(create::index);
   std::vector <double> sx;
   sx.resize(create::index);
   std::vector <double> sy;
   sy.resize(create::index);
   std::vector <double> sz;
   sz.resize(create::index);
   for (int i=0; i<create::index; i++){
       x_coord[i] = st::atom[i].cx;
       y_coord[i] = st::atom[i].cy;
       z_coord[i] = st::atom[i].cz;
       sx[i]      = st::atom[i].sx;
       sy[i]      = st::atom[i].sx;
       sz[i]      = st::atom[i].sx;
   }

<<<<<<< HEAD
  thrust::device_vector<double> H_d(create::index);
  thrust::device_vector<double> sx_d(create::index);
  thrust::device_vector<double> sy_d(create::index);
  thrust::device_vector<double> sz_d(create::index);
 // cu_real_array_t sx_d(0UL);
 // cu_real_array_t sy_d(0UL);
 // cu_real_array_t sx_d(0UL);
=======
//   thrust::device_vector<double> H_d(create::index);
 //  thrust::device_vector<double> sx_d(create::index);
  // thrust::device_vector<double> sy_d(create::index);
  // thrust::device_vector<double> sz_d(create::index);
  cu_real_array_t sx_d(0UL);
  cu_real_array_t sy_d(0UL);
  cu_real_array_t sx_d(0UL);
>>>>>>> 6551780858f46e4d66a2861ab68cb5fed9b41527

   thrust::copy( sx.begin(),
                 sx.end(),
                 sx_d.begin()
                 );

   thrust::copy( sy.begin(),
                 sy.end(),
                 sy_d.begin()
                 );


   //H_d = thrust::raw_pointer_cast(st::H_dip.data());
   // * d_H_dip = thrust::raw_pointer_cast(st::H_dip.data());
   //int size = sizeof(double);
   //cudaMalloc((void**)&atom_d, size*3*size);
  // cudaMalloc((void**)&H_dip_d, size*3*size);
  // cudaMemcpy(atom_d, st::atom, 3*create::index*size, cudaMemcpyHostToDevice);
   //cudaMemcpy(H_dip_d, st::H_dip, 3*create::index*size, cudaMemcpyHostToDevice);
  // cuda::demag_field <<< grid,block >>> (create::index,sx_d,sy_d );

   //#endif
   return 0;
}
<<<<<<< HEAD
=======

>>>>>>> 6551780858f46e4d66a2861ab68cb5fed9b41527
