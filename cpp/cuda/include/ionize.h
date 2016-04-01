#ifndef _IONIZE_
#define _IONIZE_

#include "cudaParticle.h"
#include "thrust/random.h"
//const double B[3] = {0.0,0.0,-2.0};
//
__host__ 
double randgen  () {
	double r=((double)rand()/(double)RAND_MAX);
    return r;
}

    __device__
	double randgen2 () {
        thrust::default_random_engine rng(12345);
	//thrust::uniform_int_distribution<double> dist(0.0, 1.0);
        //rng.discard(2*12345);
	double r;
	r = (double)rng() / thrust::default_random_engine::max;
	//r = (double)rng() / thrust::default_random_engine::max;   
	//r = (double)rng() / thrust::default_random_engine::max; 
    	return r;
    }

struct ionize { 

         __device__ 
                void operator()(cudaParticle &p) const { 
	double dt = 1e-9;
        	double tion;
	double trec;
	double P1;
	double Prec;
	double Coeffs[10] = {3.0875e-13, 9.6970e-14,3.8631e-14,2.0649e-14,3.5021e-15,1.6037e-15,7.0230e-17,1.7442e-17,6.1966e-18,1.8790e-18};
	double CoeffsRe[10] = {6.1164e-18, 5.1210e-17,1.2572e-16,1.9488e-16,2.5243e-16,3.0015e-16,3.3111e-16,3.5005e-16,3.5897e-16,3.5928e-16};
	double density = 1e19;
	double Temp_eV = 20;
	tion = 1/(Coeffs[int(floor(p.Z+ 0.5f))]*density);
	
	if(p.Z > 0)
	{
	trec = 1/(CoeffsRe[int(floor(p.Z- 0.5f))]*density);
	Prec = 1-exp(-dt/trec);
	}
	else 
	{
	Prec = 0.0;
	}
	
	P1 = 1-exp(-dt/tion);
	
	double r1;
	r1=randgen2();
	p.vx = r1;
	//double r2=randgen;
//	
//
//	if(r1 <= P1)
//	{
//		p.Z = p.Z+1;
//	} 
//						
//	if(r2 <= Prec)
//	{
//		p.Z = p.Z-1;
//	}         
	} 
};

#endif