// This program is a part of demag field calculation 
// 
// 
//-------------------------------------------------------------
//
// This code is dedicated to generate a simple cubic structure
//
//	.  .  .
//	.  .  .
//	.  .  .	
//
// -------------------------------------------------------------


#include <iostream>
#include <vector>
#include "../hdr/create.h"
#include "../hdr/storage.h"
#include "../hdr/template.h"

// this namespace contains more structure types 
namespace create{
   // system parameters
   double l = 1.0; // lattice parameter in nm
   // initially we build a cube 
   double x_size = 10.0;  // size of x component in nm
   double y_size = 10.0;  // size of y component in nm
   double z_size = 10.0;   // size of z component in nm

   // defining radii of ellipsoid particle in nm
   double r_e[3]={5.49,5.49,5.49};
   
   //defining origin of the particle
   double part_origin[3]={x_size/2.0, y_size/2.0,z_size/2.0};

   // current no of atom
   unsigned long int index=0;

   // simple cubic lattice
   void create_sc();

   // create the ellipsoid shape
   void elli();

   //case 0    
   //------------------------------------------------
   // routine that generate a simple cubic lattice
   //------------------------------------------------
   void create_sc(){
      int A = int (x_size/l);
      int B = int (y_size/l);
      int C = int (z_size/l);
      // calculating no of atoms
      long int  N = A * B * C;

      // resize the atom array with total number of atoms
      st::atom.resize(N);
     
      for (int i=0; i < A; i++){
         for (int j=0; j < B; j++){
            for (int k=0; k < C; k++){

               // initialize the direction of spins
               st::atom[index].sx = 0.0;
               st::atom[index].sy = 0.0;
               st::atom[index].sz = 0.0;
               // determining the coordinates of each atom
               st::atom[index].cx = l * i;
               st::atom[index].cy = l * j;
               st::atom[index].cz = l * k;
           
               // count the number of atoms
               index++;

               }// end of k for
            }// end of j for
        }// end of i for   
    }// end of void create sc
   
   //-----------------------------------------------------------------------------------------------------------
   // this routine will generate a ellipsoidal shape by cutting off the cube
   // the boundary condition respects following formula :
   // (x-u)^2/rx^2 + (y-v)^2/ry^2 + (z-w)^2/rz^2 <= 1 
   // where u, v, w are the coordinates of the origin of the particle & rx, ry, rz are the radii of the particle
   //------------------------------------------------------------------------------------------------------------
   void elli(double origin[], double radius[]){
      // test the parameters of the ellipsoid
      // todo
      // implement the test
      // the radius + origin (each component) < x,y,z_size
      // origin - radius >= 0

      // a loop over all atoms in order to restrict the atoms within the ellipsoid
      for (int i=0; i<=index; i++){
         // boundary condition
         if(((st::atom[i].cx - origin[0]) * (st::atom[i].cx - origin[0])/(radius[0]*radius[0])) +
            ((st::atom[i].cy - origin[1]) * (st::atom[i].cy - origin[1])/(radius[1]*radius[1])) +
            ((st::atom[i].cz - origin[2]) * (st::atom[i].cz - origin[2])/(radius[2]*radius[2])) <= 1.0){
               
            // re-initialize the spins and the magnetic moment 
            // we assume that is aligned on z direction
            st::atom[i].sz = 1.0; 
            st::atom[i].mu = 1.0;
             } // end of if
         else{
            st::atom[i].sz = 0.0;
            st::atom[i].mu = 0.0;
             } //end of else
       }// end of for loop
 } // end of elli  routine
   
}// end of create namespace

