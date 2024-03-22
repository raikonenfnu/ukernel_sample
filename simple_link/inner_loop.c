#include <hip/hip_runtime.h>
#include <hip/hip_fp16.h>

// device for ukernel, global for code object link.
extern "C" __global__ void simple_mul_workgroup(float *lhs,
                                                float *rhs,
                                                float *result,
                                                size_t size) {
  int threadId = threadIdx.x;
  if (threadId < size) {
    result[threadId] =
        lhs[threadId] * rhs[threadId];
  }
}
