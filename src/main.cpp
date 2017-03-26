#include <iostream>
#include "../hdr/storage.h"
#include "../hdr/create.h"
#include "../hdr/fields.h"
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
   fields_t::demag_fields();
   std::cout<<st::H_total[0]<<"T"<<std::endl;
   return 0;
}
