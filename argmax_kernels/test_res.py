import numpy as np
a = np.load("actual_out_f32i64.npy")
a0 = np.load("actual_out_f32i32.npy")
b = np.load("argmax_3d_output_f32.npy")
print("F32I64 max error", np.max(abs(a-b)))
print("F32I64 max error", np.max(abs(a0-b)))

a = np.load("actual_out_f16i64.npy")
a0 = np.load("actual_out_f16i32.npy")
b = np.load("argmax_3d_output_f16.npy")
print("F16I64 max error", np.max(abs(a-b)))
print("F16I32 max error", np.max(abs(a0-b)))
