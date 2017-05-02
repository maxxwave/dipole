#include <iostream>
#include <vector>
#include "template.h"
#ifndef __STORAGE
#define __STORAGE
namespace st{
   // declaring the dipolar field array

   extern std::vector <template_t::H_internal> H_dip;

   // total field by sum up over all atoms within the system 
   extern std::vector <double> H_total;
   // can be added other types of fields such as: anisotropy, exchange and so on

   //declaring the atom arrays
   extern std::vector <template_t::atom> atom;
   extern std::vector <template_t::atom> atom_k;
}
#endif 
