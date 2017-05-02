#include <iostream>
#include <vector>
#include <cmath>

// include  headers

#include "storage.h"
#include "fields.h"
#include "template.h"
#include "create.h"

namespace demag{

    //declaring the demag factors
    extern double Dx;
    extern double Dy;
    extern double Dz;
    // declaring a pre-factor
    extern double pf_demag;

    // declaring the functions
    extern double Demag_cpu();
    extern double Demag_CUDA();
 
}// end of namespace

