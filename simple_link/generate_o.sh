# -mllvm --print-after-all 2> $1.ll for debugging.
~/nod/iree-build-notrace/llvm-project/bin/clang -x hip --offload-arch=gfx940 --offload-device-only -nogpulib -D_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH -O3 -fvisibility=protected -emit-llvm -c $1.c -o $1.bc
~/nod/iree-build-notrace/llvm-project/bin/clang -target amdgcn-amd-amdhsa -mcpu=gfx940 -c $1.bc -o $1.o
# ~/nod/iree-build-notrace/llvm-project/bin/clang -target amdgcn-amd-amdhsa $1.o -o $1.hsaco
