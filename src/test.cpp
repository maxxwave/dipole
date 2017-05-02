// This code is dedicated to test the routines of demag field code
// (c) author: exam number Y3833878
// On this routine we aim to test the correctness of the routines as a individual identity and also to test the overall
// correctness of the code
// We implement some particular cases where the analytical solution is known in literature[1]
// [1]: "Demagnetizing Factor of the General Ellipsoid", Physical Review, 1945, J. A. Osborn
// last update: 1st of May, 2017



#include <iostream>
#include <vector>
#include <cmath>
#include <fstream>
//include headers
#include "../hdr/create.h"
#include "../hdr/fields.h"
#include "../hdr/storage.h"
#include "../hdr/demag.h"

double test_suite(){
   // defining a file to store all error messages
   std::ofstream log;
   log.open("log_file.txt");
   //----------------------------------------------------------------------------------------------------------------------
   // 1.0  first we will test if there is no intermediate point or disordered lattice
   //-----------------------------------------------------------------------------------------------------------------------
   // we need to make sure that is a perfect simple cubic lattice
   std::cerr<< "Test the order of the lattice. ...             "<<std::endl;
   // a intermediate points will be passed. If any point match with that then the test will fail
   // declare bad points arrays
   std::vector<double> bad_x(create::index, 0.0);

   // loop over all bad and initialize
   for (int i=0; i<create::index; i++){

      // initialize bad arrays with bad points as half of lattice parameter
      bad_x[i] = create::l *0.25;
    } // end of for loop

    for(int i=0; i<create::index; i++){
      //compare  with the actual points on the lattice 
      if(bad_x[i]==st::atom[i].cx && bad_x[i]==st::atom[i].cy && bad_x[i]==st::atom[i].cz){
         // print the error message
         std::cerr<< "Your lattice is not perfect simple cubic!" << std::endl;
      }// end of if
      else{ 
         std::cerr<<"pass"<<std::endl;
      }// 
      break ;
   } // end of for loop

   //------------------------------------------------------------------------------------------------------------------------
   // 2.0: test the inputs parameters for creating the ellipsoid
   //------------------------------------------------------------------------------------------------------------------------
   
   // we need to make sure that the radius leaving from origin is not exceeding the total size of the initial cube
   if(create::r_e[0]+create::part_origin[0] <= create::x_size) log<<"The particle dimensions on x are correct!"<<std::endl;
   else log<<"Error on setting the particle size!"<<std::endl; // print the error message
   if(create::r_e[1]+create::part_origin[1] <= create::y_size) log<<"The particle dimensions on y are correct!"<<std::endl;
   else log<<"Error on setting the particle size!"<<std::endl; // print the error message
   if(create::r_e[2]+create::part_origin[2] <= create::y_size) log<<"The particle dimensions on z are correct!"<<std::endl;
   else log<<"Error on setting the particle size!"<<std::endl; // print the error message

   //--------------------------------------------------------------------------------------------------------------------------
   // 3.0: Testing the overall correctness of the code
   //-------------------------------------------------------------------------------------------------------------------------
   std::cout<<"The program started to test the overall correctness ........."<<std::endl;
   // This part consists in comparison the calculated demag factor on z component for couple particular cases where exists analytical solutions
   // Here we can distinguish 3 cases according to reference mentioned above:
   // **********************************************************************
   // define an acceptance parameter
   double epsilon = 0.1;
   // 3.1______________________________________
   // for a oblate spheroid where the analytical solution is: Dz=1/(1-k0)[1-k0/sqrt(1-ko^2)*arcos(k0)], where k0<1,
   // k0=rz/rx, rx=ry

   // re-initialize the radius keeping in mind that rx>rz for case 1
   create::r_e[0]=2.4;
   create::r_e[1]=2.4;
   create::r_e[2]=0.5;
   create::create_sc();
   // calling the shape routine
   create::elli(create::part_origin, create::r_e);
   // calculate the fields
   fields_t::demag_fields();
   // calculate the demag factor
   demag::Demag_cpu();
   // calculate k = rz/rx
   double k=create::r_e[2]/create::r_e[0]; //this is the ratio of z and x radii
   // calculate the theoretical value of Dz for this case
   double Dz_th1=1.0/(1.0-pow(k,2.0))*(1-k*acos(k)/(sqrt(1.0 - pow(k,2.0)))); 
   // compare calculated pre-factor with analytical solution
   if(demag::Dz+epsilon>=Dz_th1 && demag::Dz-epsilon<=Dz_th1){
      log<<"Overall correctness proved!"<<std::endl;
   }// end of if
   else{
      log<<"Of course this program fails this test!! ...... "<<std::endl;
      log<<"The calculated demag factor doesn't match with analytical solution for the oblate case :("<<std::endl;
   }// end of else
   std::cout<<"The magnetic field " <<"\t"<<st::H_total[2]<<std::endl;
   // print the value of theoretical and calculated Dz
   log<<"The value of Dz analytical is:"<<"\t"<<Dz_th1<< "\t"<<"and the calculated Dz is:"<<"\t"<<demag::Dz<<std::endl;

   // 3.2_____________________________________________
   // second case correspond to a perfect sphere
   // here Dz = 0.333333
   // The procedure is the same

   // re-initialize the radii(rx=ry=rz)
   create::r_e[0]=2.5; create::r_e[1]=2.5; create::r_e[2]=2.5;
   // calling the shape routine
   create::elli(create::part_origin, create::r_e);
   // calculate the fields
   fields_t::demag_fields();
   // calculate the demag factor
   demag::Demag_cpu();
   // compare calculated pre-factor with analytical solution
   if(demag::Dz+epsilon>=(1.0/3.0) && demag::Dz-epsilon<=(1.0/3.0)){
      log<<"Overall correctness proved!"<<std::endl;
   }// end of if
   else{
      log<<"Overall correctness test failed! "<<std::endl;
      log<<"The dmag factor corresponding to a sphere doesn't correspond to analytical solution :("<<std::endl;
   }// end of else
   // print the value of theoretical and calculated Dz
   log<<"The value of Dz analytical is:"<<"\t"<<"0.(3)"<< "\t"<<"and the calculated Dz is:"<<"\t"<<demag::Dz<<std::endl;

   // 3.3_______________________________________________
   // case 3: prolate spheroid rz>rx=ry 
   // here the analytical solution is Dz = 1/(k^2-1)(k/sqrt(k^2-1) *acosh(k)-1)
   // the procedure is the same
   
   // re-initialize the radii
   create::r_e[0]=1.5; create::r_e[1]=1.5; create::r_e[2]=2.5;
   // re-model the shape
   create::elli(create::part_origin, create::r_e);
   // re-calculate the field
   fields_t::demag_fields();
   // re-calculate the demag factor
   demag::Demag_cpu();
   // defining the k0 = rz/rx 
   double k0=create::r_e[2]/create::r_e[0]*(180.0/3.14); // transform it in radians 
   // calculate the analytical value for Dz
   double Dz_th3 = (1.0/(k0*k0-1))*(k0*acosh(k0))/(sqrt(k0*k0-1) -1);
   // compare the analytical solution with the calculated Dz
   if(demag::Dz==Dz_th3){
      // print informative message on log file
      log<<"The overall correctness is proved for prolate case! :)"<<std::endl;
   }// end of if
   else{
      // print error message
      log<<"The correctness test for prolate case failed! :("<<std::endl;
   }// end of else
   // print the value of theoretical and calculated Dz
   log<<"The value of Dz analytical is:"<<"\t"<<Dz_th3<< "\t"<<"and the calculated Dz is:"<<"\t"<<demag::Dz<<std::endl;
  
   // close the log file
   log.close();
}// end of namespace
