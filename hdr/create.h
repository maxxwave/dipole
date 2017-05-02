// This is a header that take part from demag code
// 

#include <iostream>
#include <vector>


// this statement will help the compiler
#ifndef __CREARE
#define __CREARE
namespace create{
   //declaring the total number of atoms
<<<<<<< HEAD
   extern unsigned long int index;
   // boundary parameters
   extern int A;
   extern int B;
   extern int C;
=======
	extern long int index;
	// boundary parameters
	extern int A;
	extern int B;
	extern int C;
>>>>>>> 46dfe907eb4023dfbf695598181d2ddab87c09d9
   // size of initial cube
   extern double x_size;
   extern double y_size;
   extern double z_size;
   // lattice parameter
   extern double l;
   // declare the radius of particle
   extern double r_e[3];
   //declare the origin of particle
   extern double part_origin[3];
   // functions into create namespace  
   extern void single_spin();
   extern void create_sc();
   extern void create_bcc();
   // function that create an ellipsoid shape
   extern void elli(double origin[], double radius[]);
   //so on
}
#endif
