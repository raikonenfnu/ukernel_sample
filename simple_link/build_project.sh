# Recipe 1, output: :0:rocdevice.cpp:2726: 3989311591661 us: [pid:3667426 tid:0x7f73e7bff640] Callback: Queue 0x7f72e5000000
# aborting with error : HSA_STATUS_ERROR_ILLEGAL_INSTRUCTION: The agent attempted to execute an illegal shader instruction. code: 0x2a
# Uncomment below to use recipe 1.
# ./generate_o.sh inner_loop
# ./generate_o.sh outer_loop
#  ~/nod/iree-build-notrace/llvm-project/bin/ld.lld -flavor gnu -shared inner_loop.o -o inner_loop.hsaco
#  ~/nod/iree-build-notrace/llvm-project/bin/ld.lld -flavor gnu -shared inner_loop.hsaco outer_loop.o -o integrated.hsaco


# Recipe 2, output: Memory access fault by GPU node-4 (Agent handle: 0x765d40) on address 0x1800000000. Reason: Unknown.
# Uncomment below to use recipe 2.
./generate_o.sh inner_loop
./generate_o.sh outer_loop
 ~/nod/iree-build-notrace/llvm-project/bin/ld.lld -flavor gnu -shared inner_loop.o outer_loop.o -o integrated.hsaco

rm *.bc *.o