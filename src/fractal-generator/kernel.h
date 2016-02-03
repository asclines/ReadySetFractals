#ifndef FRACTAL_KERNEL_H
#define FRACTAL_KERNEL_H

#include "generator.h"

#include <cuda.h>

namespace fractal_generator{

<template FRACTAL type>
__global__ void SetPixels(FractalSettings settings);


} //End namespace


#endif
