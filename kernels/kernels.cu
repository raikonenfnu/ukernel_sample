// Copyright 2022 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

// This minimal example just has some publicly exported (__global__) kernels.
// It's possible with more build goo to include .cuh files and pull in any
// CUDA functions that do not involve host behavior (kernel launches/etc).
//
// NOTE: kernels must be exported with C naming (no C++ mangling) in order to
// match the names used in the IR declarations.
//
// NOTE: arguments are packed as a dense list of
// ([ordered bindings...], [push constants...]). If a binding is declared as
// read-only the kernel must not write to it as it may be shared by other
// invocations.
//
// NOTE: today all constants must be i32. If larger types are required there are
// packing rules that must line up with compiler expectations - passed i64
// values must be padded to natural 8-byte alignment, for example.
//
// NOTE: IREE ensures that all I/O buffers are legal to have the __restrict__
// keyword defined (no aliasing is induced that is potentially unsafe). It's
// still possible for users to do bad things but such is the case with native
// CUDA programming.
//
// NOTE: I/O buffer base pointers are likely to be nicely aligned (64B minimum
// but usually larger) but the pointers passed in may be offset by any value
// as they represent subranges of the underlying buffers. For example if the
// user slices out elements 3 and 4 out of a 4xf32 tensor then the base buffer
// pointer will be at +8B. In general if the input wasn't trying to be tricky
// (bitcasting/etc) then natural alignment is guaranteed (an f32 tensor will
// always have buffer pointers aligned to 4B).

// `ret = lhs * rhs`
//
// Conforms to ABI:
// #hal.pipeline.layout<push_constants = 1, sets = [
//   <0, bindings = [
//       <0, storage_buffer, ReadOnly>,
//       <1, storage_buffer, ReadOnly>,
//       <2, storage_buffer>
//   ]>
// ]>
// workgroup_size = [64 : index, 1 : index, 1 : index]
extern "C" __global__ void simple_mul(const float* __restrict__ binding0,
                                      const float* __restrict__ binding1,
                                      float* __restrict__ binding2, int dim) {
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  if (tid < dim) {
    binding2[tid] = binding0[tid] * binding1[tid];
  }
}

// `rhs *= lhs`
//
// Conforms to ABI:
// #hal.pipeline.layout<push_constants = 1, sets = [
//   <0, bindings = [
//       <0, storage_buffer, ReadOnly>,
//       <1, storage_buffer>
//   ]>
// ]>
// workgroup_size = [64 : index, 1 : index, 1 : index]
extern "C" __global__ void simple_mul_inplace(
    const float* __restrict__ binding0, float* __restrict__ binding1, int dim) {
  int tid = blockDim.x * blockIdx.x + threadIdx.x;
  if (tid < dim) {
    binding1[tid] *= binding0[tid];
  }
}
