#include <iostream>
#include <vector>
#include "create.h"
#include "storage.h"
#include "template.h"

//this statement are dedicated to help the compiler
#ifndef __FIELDS
#define _FIELDS

//this is the header corresponding to "../src/fields.cpp"
namespace fields_t{
   // declaring the demag routine
   extern double demag_fields();

   // declaring the variables needed for demag routine
   extern double rij_x;    //x-component of distance betweeen atoms
   extern double rij_y;    //y-component
   extern double rij_z;    //z-component
   extern double rij;      //module of distance between atoms
   //declaring the prefactor
   extern double pf;
} //end of namespace
#endif
