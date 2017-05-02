// This file is a part of demag field calculation code 
// (c) author: XXX@york.ac.uk
// last update: 23rd of April, 2017
// this code is free to use but no warranty provided 
//-------------------------------------------------------------
// This routine is dedicated to calculate the magnetostatic field of each particle according to formula given by S. Blundell, Magnetism in Condensed
// Matter, p.74
// In order to do I used some magnetic constants such as magnetic permeability of free space, Bohr-Procopiu magneton found on Wikipedia
//------------------------------------------------------------
#include <iostream>
#include <vector>
#include <cstdlib>
#include <cmath>


//include headers
#include "../hdr/template.h"
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"
#define pi 3.1415926535897932384626433832795028841971693993751058209749445923078


// we declare a namespace for calculation of many types of fields
// for the beginning we start with magnetostatic field
namespace fields_t{
   // here we can add more types of interaction (eg.: exchange interaction, anisotropy, thermal etc.)

   // declaring the distances between atoms
   double rij_x=0.0;
   double rij_y=0.0;
   double rij_z=0.0;
   // defining the module of radius between atoms
   double rij=0.0;
   //declaring the demag field routine
   double demag_fields();
   //------------------------------------------------------------------------------------------------------------------------------------
   // this routine calculates the dipolar field a.k.a magnetostatic field for each site(atom) 
   //
   //
   //         mu_o     (  3.(m.r_hat)r_hat - m   )    [    mu_o m   ])                  4*pi e-7*mu_B 
   // H = ---------- . ( ------------------------) -  [ - --------  ]),   pre-factor = ---------------, mu_B=9.273e-23 J/T (ac. Wikipedia)
   //         4*pi     (         |r|^3           )    [      3V     ])                   4*pi e-30
   //
   //-------------------------------------------------------------------------------------------------------------------------------------

   // declaring the pre-factor in order to optimize the code within the loops
   double pf = 0.0009274;
   // a second pre-factor for internal field (r=0)
   double pf_2 = 8.0*pi/10.0*create::l;
   
   // starting the routine
   double demag_fields(){
      // resize the local dipolar field array
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
              // defining a new variable whose value is pf*1.0/rij^3
              double rij_cube=pf*1.0/(rij*rij*rij);
              // calculate the magnetostatic field corresponding to each atom 
              st::H_dip[i].x += (3.0* rij_x * (rij_x * st::atom[j].sx) - st::atom[j].sx) * (rij_cube);
              st::H_dip[i].y += (3.0* rij_y * (rij_y * st::atom[j].sy) - st::atom[j].sy) * (rij_cube);
              st::H_dip[i].z += (3.0* rij_z * (rij_z * st::atom[j].sz) - st::atom[j].sz) * (rij_cube);
           } // end of if

           if(i==j){    // this case corresponds to internal field  (for r=0)
              st::H_dip[i].x += pf * ( pf_2 *st::atom[i].sx);
              st::H_dip[i].y += pf * ( pf_2 *st::atom[i].sy);
              st::H_dip[i].z += pf * ( pf_2 *st::atom[i].sz);
           }//end of if  
        } //end of j-for

        st::H_total[0] += st::H_dip[i].x;
        st::H_total[1] += st::H_dip[i].y;
        st::H_total[2] += st::H_dip[i].z;
     }// end of i-for
  }// end of demag field routine
            
}// end of fields namespace

