// This code is takes part of demag field calculation code
// (c) author exam number: Y3833878
// this routine is dedicated to calculate the demag factor after the field calculation 
// last update: 24th of April, 2017


#include <iostream>
#include <vector>
#include <cmath>

// include demag headers
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"
#include "../hdr/template.h"


namespace demag{
   // defining the demag factors
   double Dx=0.0;
   double Dy=0.0;
   double Dz=0.0;
   // declaring a pf that incorporate mu_B/l
   double pf_demag= pow(create::l,3.0)*1e-27/(4*3.14*9.274*1e-31);

   // defining a routine to compute the demag factor for cpu arrays
   double Demag_cpu(){
      // defining a counter in order to average the demag factor
      int counter = 1;
      // loop over atoms and compute demag factors
      for (int i=0; i<create::index; i++){
         // it is possible the particles outside of the ellipsoid to feel the magnetic field
         // we need therefore to restrict the demag factor only to particles inside of ellipsoid
         if(st::atom[i].mu != 0.0){
             // calculating by summing up all demag factors corresponding to each particle
             if(st::atom[i].sz!=0.0) Dz += (1.0 - st::H_dip[i].z*pf_demag/st::atom[i].sz); counter++;
          }// end of if
      } // end of for
      // re-scale the demag factor
      Dz /= counter;
   } // end of Demag_cpu routine

   // this function is dedicated to calculate the demag factor for a passed arrays of spins and fields used in cuda part
   double Demag_CUDA(int N, double sx[], double sy[], double sz[], double hx[], double hy[], double hz[]){
      // declaring a counter in order to obtain the average
      int count=1;
      for (int i =0; i<N; i++){
         Dz += (1.0 - hz[i] * pf_demag/sz[i]); count++;
      } // end of for
      // re-scale the demag factor
      Dz /= count;
      return Dz;
   }// end of Demag_CUDA
}// end of namespace

             
