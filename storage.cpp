// This program is a part of demag field calculation 
// 
// 
//-------------------------------------------------------------

#include <iostream>
#include <vector>
#include "../hdr/template.h"
#include "../hdr/storage.h"

// within this namespace we aim to storage the field and atom's information
namespace st{ 
   // here is declared the dipolar value according to a specific template created in "../hdr/template.h"
   // this contains 3 components: x, y, and z

   std::vector <template_t::H_internal> H_dip;


   std::vector <double> H_total(3,0.0);
   //std::vector <double> H_applied;
   // std::vector <template_t::H_internal> H_int;

   // here we defined the atom array which contains: coordinate, spin value on each component and magnetic moment 
   std::vector <template_t::atom> atom;

}
