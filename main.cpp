// This code is dedicated to calculate the magnetostatic field of an ellipsoid particle in order to achieve the 3rd task of Applications of HPC exam
// license provided by GNU
// this code is free to use and it can be downloaded from https://github.com/maxxwave/dipole 
// users must be aware this code is coming without any warranty 
// author: xxxxxx@york.ac.uk
// last update: 22nd of April
//----------------------------------------------------------------------------------------------------------------------------------------------


#include <iostream>
#include <fstream>
#include <sstream>

// include headers
#include "../hdr/template.h"
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"
#include "../hdr/test.h"

int main(int argc, char* argv[]){

   // capture command line argument for testing 
   if(argc>1){
      std::string arg = argv[1];
      std::string test_arg="--test";
      if(arg==test_arg){
         //call test routine
         test_suite();
      }// end of 2nd if
   }// end of 1st if

   // Initialization part & creating the structure
   create::create_sc();
   // creating the ellipsoid shape
   create::elli(create::part_origin, create::r_e);
   
   std::cout << create::index << std::endl;
   
   for(int i =0; i<create::index; i++){
        std::cout<<st::atom[i].cx<<"\t"<<st::atom[i].cy<<"\t"<<st::atom[i].cz <<"\t"<<st::atom[i].sz<<std::endl;
   }

   std::cout<<"Starting to calculate the demag field"<< std::endl;
   std::cout<<"Total number of atoms is:"<<"\t"<<create::index<<std::endl;
   fields_t::demag_fields();
   std::cout<<st::H_total[0]<<"\t"<<st::H_total[1]<<"\t"<<st::H_total[2]<<std::endl;

   //#endif

   // print the results part!
   // TODO
   return 0;
}
