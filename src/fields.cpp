// This file is a part of demag field calculation code 
// 
//-------------------------------------------------------------
#include <iostream>
#include <vector>
#include <cstdlib>
#include <cmath>


//include headers
#include "../hdr/template.h"
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"

// we declare a namespace for calculation of many types of fields
// for the beginning we start with magnetostatic field
namespace fields_t{

   // declaring the distances between atoms
   double rij_x=0;
   double rij_y=0;
   double rij_z=0;
   // defining the module of radius between atoms
   double rij=0;
   // defining a temporal variable to store the magnetic field between two atoms
  
   //declaring the demag field routine
   double demag_fields();
   //declaring other sort of magnetic fields
   //------------------------------------------------------------------------------------------------------
   // resize the magnetic field array
   //st::H_dip.resize(create::index);
   //st::H_total.resize(create::index,0); 
   // this routine calculates the dipolar field a.k.a magnetostatic field for eacth site(atom) 
   //
   //
   //         mu_o     (  3.(m.r_hat)r_hat - m   )    [    mu_o m   ])                4*pi e-7
   // H = ---------- . ( ------------------------) -  [ - --------  ]),   pre-factor = ---------- = e+23
   //         4*pi     (         |r|^3           )    [      3V     ])                4*pi e-30
   //
   // declaring the prefactor in order to optimize the code within the loops
   double pf = 10e+23;

   //-------------------------------------------------------------------------------------------------------
   double demag_fields(){
   st::H_dip.resize(create::index);
  

      // loop over atoms i
      // these are the atoms that we calculate the Mag field
      for (int i=0; i<create::index; i++){
      
        // loop over the interaction atoms (j-sort)
        for (int j=0; j<create::index; j++){
        
           // we calculate the Mag field excluding the interaction with itself
           if(i!=j){
              // we calculate the radius on each component between two atoms
              rij_x = st::atom[i].cx - st::atom[j].cx;
              rij_y = st::atom[i].cy - st::atom[j].cy;
              rij_z = st::atom[i].cz - st::atom[j].cz;

              // now we calculate the module of radius between atoms i and j
              rij = sqrt(rij_x*rij_x + rij_y*rij_y + rij_z*rij_z);

              // calculate the magnetostatic field corresponding to each atom 
              st::H_dip[i].x += pf * (3* rij_x * (rij_x * st::atom[j].cx) - st::atom[j].cx) / (rij*rij*rij);
              st::H_dip[i].y += pf * (3* rij_y * (rij_y * st::atom[j].cy) - st::atom[j].cy) / (rij*rij*rij);
              st::H_dip[i].z += pf * (3* rij_z * (rij_z * st::atom[j].cz) - st::atom[j].cz) / (rij*rij*rij);
           } // end of if 
              //TODO:implement the case for i==j
           
        } //end of j-for
           st::H_total[0] += st::H_dip[i].x;
           st::H_total[1] += st::H_dip[i].y;
           st::H_total[2] += st::H_dip[i].z;
     } //end of i-for
  } //end of demag field routine
            
} // end of fields namespace

