// This file is a part of Demag field code
// This file is free to use but no warranty is provided
// last update: 17th of April, 2017
// (c) author exam number: Y3838878
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
   double l = 0.3; // lattice parameter in nm
   // initially we build a cube 
   double x_size = 5.0;  // size of x component in nm
   double y_size = 5.0;  // size of y component in nm
   double z_size = 5.0;  // size of z component in nm

   // defining radii of ellipsoid particle in nm
   double r_e[3]={2.0,2.0,2.0};
   
   //defining origin of the particle at the middle of the initial bulk 
   double part_origin[3]={x_size*0.5, y_size*0.5,z_size*0.5};

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
      // determining the number of grids in x direction
      int A = int (x_size/l);
      // determining the number of grids in y direction
      int B = int (y_size/l);
      // determining the number of grids in x direction
      int C = int (z_size/l);
      // calculating the total number of grids
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
   // the boundary condition respects following formula:
   // (x-u)^2/rx^2 + (y-v)^2/ry^2 + (z-w)^2/rz^2 <= 1 
   // where u, v, w are the coordinates of the origin of the particle & rx, ry, rz are the radii of the particle
   //------------------------------------------------------------------------------------------------------------
   void elli(double origin[], double radius[]){
      // a test of the parameters of the ellipsoid can be found in test_suite() routine (test.cpp file)
      // 
      // the radius + origin (each component) < x,y,z_size
      // origin - radius >= 0
      if((origin[0]+radius[0])<=create::x_size && (origin[0]-radius[0]) >= 0 &&
         (origin[1]+radius[1])<=create::x_size && (origin[1]-radius[1]) >= 0 &&
         (origin[0]+radius[2])<=create::x_size && (origin[2]-radius[2]) >= 0){
         // print an informative message
         std::cout<<"The inputs parameters for creating the shape are suitable!"<<std::endl;
         }// end of if
      else{ std::cout<<"The inputs parameter for creating the shape are wrong! Please make sure you set up right parameters according to the documentation"<<std::endl; }

      // a loop over all atoms in order to restrict the atoms within the ellipsoid
      for (int i=0; i<index; i++){
         // boundary condition
         if(((st::atom[i].cx - origin[0]) * (st::atom[i].cx - origin[0])/(radius[0]*radius[0])) +
            ((st::atom[i].cy - origin[1]) * (st::atom[i].cy - origin[1])/(radius[1]*radius[1])) +
            ((st::atom[i].cz - origin[2]) * (st::atom[i].cz - origin[2])/(radius[2]*radius[2])) <= 1.0){
               
            // re-initialize the spins and the magnetic moment 
            // we assume that is aligned on z direction
            st::atom[i].sz = 1.0;
            st::atom[i].sy = 0.0;
            st::atom[i].sx = 0.0;
            st::atom[i].mu = 1.0;
            } // end of if
         else{
            // initialize the particles(atoms) out of the ellipsoid with 0 
            st::atom[i].sz = 0.0;
            st::atom[i].sy = 0.0;
            st::atom[i].sx = 0.0;
            st::atom[i].mu = 0.0;
            } //end of else
         }// end of for loop

   } // end of elli  routine
   
}// end of create namespace

