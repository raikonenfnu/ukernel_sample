#include <hip/hip_runtime.h>
#include <hip/hip_fp16.h>
// #include "inner_loop.h"

// Forward declaration.
extern "C" {
// Without extern "C" region, clang will try to
// rename fn name to _Z20simple_mul_workgroupPfS_S_m.
 __device__ void simple_mul_workgroup(float *,
                                                float *,
                                                float *,
                                                size_t);
}

extern "C" __global__ void simple_mul_wrap(float *lhs,
                                                float *rhs,
                                                float *result,
                                                size_t size) {
  simple_mul_workgroup(lhs, rhs, result, size);
}

// __device__ void simple_mul_workgroup(float *lhs,
//                                                 float *rhs,
//                                                 float *result,
//                                                 size_t size) {
//   int threadId = threadIdx.x;
//   if (threadId < size) {
//     result[threadId] =
//         lhs[threadId] * rhs[threadId];
//   }
// }
