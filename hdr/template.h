#include <iostream>
#include <vector>
#ifndef __template
#define __template
namespace template_t{
   // declaring the template for a typical field
   // this must contain 3 components
   class H_internal{
      public:
      // components of field
      double   x;
      double   y;
      double   z;
      }; // end of class

   class atom{
      // defining the template for atom array
      // this must contain coordinates + spin values + magnetic moment 
      public:
      // spin components
      double   sx;
      double   sy;
      double   sz;
      // coordinates
      double   cx;
      double   cy;
      double   cz;
      //value for magnetic moment
      double mu;
      }; // end of class
}//end of template_t
#endif
