#include <iostream>
#include <fstream>
#include <vector>
#include <hip/hip_runtime.h>
#include <hip/hip_fp16.h>
#include <mutex>
#include <chrono>

#ifndef CHECK_HIP_ERROR
#define CHECK_HIP_ERROR(status)                   \
    if(status != hipSuccess)                      \
    {                                             \
        fprintf(stderr,                           \
                "hip error: '%s'(%d) at %s:%d\n", \
                hipGetErrorString(status),        \
                status,                           \
                __FILE__,                         \
                __LINE__);                        \
        exit(EXIT_FAILURE);                       \
    }
#endif

std::vector<char> readFileIntoVector(const std::string& filename) {
    std::ifstream file(filename, std::ios::binary | std::ios::ate);

    if (!file.is_open()) {
        std::cerr << "Unable to open file: " << filename << std::endl;
        return std::vector<char>();
    }

    std::streamsize size = file.tellg();
    file.seekg(0, std::ios::beg);

    std::vector<char> buffer(size);
    file.read(buffer.data(), size);
    file.close();
    return buffer;
}

void run_module() {
    // Initialize input matrices
    // TODO: Add support for parallel dimension.
    const int kDimSize = 128;
    float lhs_val = 5.0;
    float rhs_val = 2.0;
    std::vector<float> lhsBuffer(kDimSize, lhs_val);
    std::vector<float> rhsBuffer(kDimSize, rhs_val);
    std::vector<float> outBuffer(kDimSize);

    float *d_lhs;
    float *d_rhs;
    float *d_out;

    const size_t bytesSize = kDimSize * sizeof(float);

    CHECK_HIP_ERROR(hipMalloc(&d_lhs, bytesSize));
    CHECK_HIP_ERROR(hipMalloc(&d_rhs, bytesSize));
    CHECK_HIP_ERROR(hipMalloc(&d_out, bytesSize));

    CHECK_HIP_ERROR(hipMemcpy(d_lhs, lhsBuffer.data(), bytesSize, hipMemcpyHostToDevice));
    CHECK_HIP_ERROR(hipMemcpy(d_rhs, rhsBuffer.data(), bytesSize, hipMemcpyHostToDevice));

    hipModule_t module;
    hipFunction_t kernel;
    std::vector<char> hsacoVec = readFileIntoVector("integrated.hsaco");
    if (hipModuleLoadDataEx(&module, hsacoVec.data(), 0, NULL, NULL) != hipSuccess) {
      std::cout<<"Failed to load module!\n";
      return;
    }
    if (hipModuleGetFunction(&kernel, module, "simple_mul_wrap") != hipSuccess) {
      std::cout<<"Failed to get function!\n";
      return;
    }

    // Setting up grid dim, block size, and pointer.
    size_t block_dimx = kDimSize;
    size_t block_dimy = 1;
    int gridX = 1;
    int gridY = 1;
    void* kernelParam[] = {d_lhs, d_rhs, d_out};
    auto size = sizeof(kernelParam);
    void* config[] = {HIP_LAUNCH_PARAM_BUFFER_POINTER, &kernelParam,
                      HIP_LAUNCH_PARAM_BUFFER_SIZE, &size,
                      HIP_LAUNCH_PARAM_END};

    std::cout << "Launching Argmax kernel..." << std::endl;
    hipEvent_t startEvent, stopEvent;
    constexpr uint32_t recordRuns = 100u;
    CHECK_HIP_ERROR(hipEventCreate(&startEvent));
    CHECK_HIP_ERROR(hipEventCreate(&stopEvent));

    CHECK_HIP_ERROR(hipEventRecord(startEvent));

    // Launching Kernel Begin
    for (uint32_t i = 0; i < recordRuns; ++i) {
      assert (hipModuleLaunchKernel(
          kernel, gridX, gridY, 1, block_dimx, block_dimy, 1,
          0, nullptr, nullptr, config) == 0);
    }
    CHECK_HIP_ERROR(hipEventRecord(stopEvent));
    CHECK_HIP_ERROR(hipEventSynchronize(stopEvent));

    auto elapsedTimeMs = 0.0f;
    CHECK_HIP_ERROR(hipEventElapsedTime(&elapsedTimeMs, startEvent, stopEvent));
    CHECK_HIP_ERROR(hipEventDestroy(startEvent));
    CHECK_HIP_ERROR(hipEventDestroy(stopEvent));

    hipMemcpy(outBuffer.data(), d_out, bytesSize, hipMemcpyDeviceToHost);
    std::cout<<"Argmax result:"<<outBuffer[0]<<"\n";
    assert(outBuffer[0] == lhs_val * rhs_val && "Expected argmax to match label!");
    std::cout<<"argmax kernel successfully match label!\n";

    // Release device memoryv
    CHECK_HIP_ERROR(hipFree(d_lhs));
    CHECK_HIP_ERROR(hipFree(d_rhs));
    CHECK_HIP_ERROR(hipFree(d_out));
    std::cout<< "Average time per run is:" << elapsedTimeMs/recordRuns <<" ms/iter\n";
    std::cout << "Finished!" << std::endl;
}

int main(int argc, char *argv[]) {
  run_module();
  return 0;
}