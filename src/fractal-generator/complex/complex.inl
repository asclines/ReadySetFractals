#define __both__ __device__ __host__

#include <math.h>

/*
 * Addition
 */
template<typename T>
__both__ Complex<T> Complex<T>::operator+(const Complex<T>& other)const{
        T r=real+other.Real();
        T i=imag+other.Imag();
        Complex tmp(r,i);
        return tmp;
};


/*
 * Subtraction
 */
template<typename T>
__both__ Complex<T> Complex<T>::operator-(const Complex<T>& other)const{
        T r = real-other.Real();
        T i = imag-other.Imag();
        Complex result(r,i);
        return result;
};


/*
 * Complex Multiplication done algebraically
 *
 * (x+yi)(u+vi) = (xu-yv) + (xv + yu)i
 */
template<typename T>
__both__ Complex<T> Complex<T>::operator*(const Complex<T>& other)const{
        T x = real;
        T y = imag;
        T u = other.Real();
        T v = other.Imag();

        T r = x*u - y*v;
        T i = x*v + y*u;

        Complex result(r,i);
        return result;
};

template<typename T>
__both__ T abs()const{
	T r = real * real;
	T i = imag * imag;

	return sqrt(r+i);
	
};


#undef __both__                
