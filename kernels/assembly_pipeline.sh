# Generate .S
name=ukernel
arch=gfx940
# ~/nod/iree-build-notrace/llvm-project/bin/clang -x hip --offload-arch=$arch --offload-device-only -nogpulib \
# -D_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH -O3 -fvisibility=protected -S -o $name.s $name.c

# # Generate .o
# ~/nod/iree-build-notrace/llvm-project/bin/clang -x assembler -target amdgcn-amd-amdhsa -mcode-object-version=5 -mcpu=$arch -mwavefrontsize64 -c -o $name.o $name.s

# # Generate hsaco
# ~/nod/iree-build-notrace/llvm-project/bin/clang -target amdgcn-amd-amdhsa $name.o -o $name.co

# ~/nod/iree-build-notrace/llvm-project/bin/ld.lld -flavor gnu -shared -o $name.co $name.o

~/nod/iree-build-notrace/llvm-project/bin/clang -x hip --offload-arch=$arch --offload-device-only -nogpulib -D_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH -O3 -fvisibility=protected -emit-llvm -c $name.c -o $name.bc
~/nod/iree-build-notrace/llvm-project/bin/clang -target amdgcn-amd-amdhsa -mcpu=$arch -c $name.bc -o $name.o
~/nod/iree-build-notrace/llvm-project/bin/clang -target amdgcn-amd-amdhsa $name.o -o $name.co

~/nod/iree-build-notrace/tools/iree-compile --iree-hal-target-backends=rocm --iree-rocm-target-chip=$arch ukernel_example.mlir -o ukernel.vmfb
~/nod/iree-build-notrace/install/bin/iree-run-module --module=ukernel.vmfb --device=rocm --function=ukernel_example
rm $name.o $name.bc $name.co
