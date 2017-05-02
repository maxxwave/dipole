// This code is dedicated to calculate the magnetostatic field of an ellipsoid particle in order to achieve the 3rd task of Applications of HPC exam
// license provided by GNU
// this code is free to use and it can be downloaded from https://github.com/maxxwave/dipole 
// users must be aware this code is coming without any warranty 
// (c) author: exam number Y3833878
// last update: 22nd of April
//----------------------------------------------------------------------------------------------------------------------------------------------


#include <iostream>
#include <fstream>
#include <sstream>
#include <time.h>
// include headers
#include "../hdr/template.h"
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"
#include "../hdr/test.h"
#include "../hdr/demag.h"


int main(int argc, char* argv[]){
   //------------------------------------------------------------------------------------------------------------------------------
   // 1.0 Testing part
   //------------------------------------------------------------------------------------------------------------------------------

   // capture command line argument for testing 
   if(argc>1){
      // print an informative message
      std::cout<<"You have activated the testing module......." <<std::endl;
      // declaring the string for storing the passed argument when the executable is run 
      std::string arg = argv[1];
      // initializing the string with a specific name of the flag wanted 
      std::string test_arg="--test";
      // check the string passed by user 
      if(arg==test_arg){
         //call test routine
         test_suite();
         // print an informative message related to results of testing and where these can be found
         std::cout<<"The testing module has ended successfully and the results can be seen in log_file.txt"<<std::endl;
      }// end of 2nd if
   }// end of 1st if
   
   //------------------------------------------------------------------------------------------------------------------------------
   // 2.0 Computation part
   //------------------------------------------------------------------------------------------------------------------------------

   // 2.1 Initialization part & creating the structure
   else{
      create::create_sc();
   }// end of else 

   // 2.2 creating the ellipsoid shape
   create::elli(create::part_origin, create::r_e);

   // informative message with the total number of particles(atoms) generated
   std::cout <<"The total number of atoms including the particles out of ellipsoid region is:"<<"\t"<<create::index << std::endl;
   
   // 2.3 informative message &calling the routine of calculation the field
   std::cout<<"Starting to calculate the demag field"<< std::endl;

   // counting the time consumed by field calculation routine
   // defining start and stop time
   clock_t start, stop;
   // click on start
   start=clock();

   // calling the routine of demag field calculatio
   fields_t::demag_fields();

   // click on stop
   stop=clock();

   // print the magnetic field of the particle
   std::cout<<"The simulation ended successfully!"<<std::endl;
   std::cout<<"The results can be seen in the 'results.data'" <<std::endl;
   std::cout<<"Time elapsed for the calculation is"<<"\t"<<(stop-start)/CLOCKS_PER_SEC<<"s"<<std::endl;
  
   //------------------------------------------------------------------------------------------------------------------------------
   // 3.0 printing the results part
   //------------------------------------------------------------------------------------------------------------------------------
   // open file for output
   std::ofstream outfile;
   outfile.open("results.data");

   // loop over all sites and print the field values
   for (int i=0; i<create::index; i++){
      outfile<<st::H_dip[i].x<<"\t"<<st::H_dip[i].y<<"\t"<<st::H_dip[i].z<<std::endl;
   }// end of for

   // close the file
   outfile.close();
   //-------------------------------------------------------------------------------------------------------------------------------
   // 4.0: Calculating and printing the demag factor
   //-------------------------------------------------------------------------------------------------------------------------------
   demag::Demag_cpu();
   // printing the demag factor
   std::cout<<"The value of demagnetizing factor is"<<"\t"<<demag::Dz<<std::endl;
   return 0;
}
