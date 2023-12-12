func.func @forward(%arg0: tensor<1x?xf32>) -> tensor<1x1xi64> {
  %c0 = arith.constant 0 : index
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0xFF800000 : f32
  %cst_0 = arith.constant 0.000000e+00 : f16
  %c-1_i64 = arith.constant -1 : i64
  %15 = tensor.empty() : tensor<1xi64>
  %16 = linalg.fill ins(%c0_i64 : i64) outs(%15 : tensor<1xi64>) -> tensor<1xi64>
  %17 = tensor.empty() : tensor<1xf32>
  %18 = linalg.fill ins(%cst : f32) outs(%17 : tensor<1xf32>) -> tensor<1xf32>
  %19:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%arg0 : tensor<1x?xf32>) outs(%18, %16 : tensor<1xf32>, tensor<1xi64>) {
  ^bb0(%in: f32, %out: f32, %out_2: i64):
    %20 = linalg.index 1 : index
    %21 = arith.index_cast %20 : index to i64
    %22 = arith.maximumf %in, %out : f32
    %23 = arith.cmpf ogt, %in, %out : f32
    %24 = arith.select %23, %21, %out_2 : i64
    linalg.yield %22, %24 : f32, i64
  } -> (tensor<1xf32>, tensor<1xi64>)
  %expanded_1 = tensor.expand_shape %19#1 [[0, 1]] : tensor<1xi64> into tensor<1x1xi64>
  return %expanded_1 : tensor<1x1xi64>
}

func.func @forward_f16(%arg0: tensor<1x?xf16>) -> tensor<1x1xi64> {
  %c0 = arith.constant 0 : index
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0xFC00 : f16
  %cst_0 = arith.constant 0.000000e+00 : f16
  %c-1_i64 = arith.constant -1 : i64
  %15 = tensor.empty() : tensor<1xi64>
  %16 = linalg.fill ins(%c0_i64 : i64) outs(%15 : tensor<1xi64>) -> tensor<1xi64>
  %17 = tensor.empty() : tensor<1xf16>
  %18 = linalg.fill ins(%cst : f16) outs(%17 : tensor<1xf16>) -> tensor<1xf16>
  %19:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%arg0 : tensor<1x?xf16>) outs(%18, %16 : tensor<1xf16>, tensor<1xi64>) {
  ^bb0(%in: f16, %out: f16, %out_2: i64):
    %20 = linalg.index 1 : index
    %21 = arith.index_cast %20 : index to i64
    %22 = arith.maximumf %in, %out : f16
    %23 = arith.cmpf ogt, %in, %out : f16
    %24 = arith.select %23, %21, %out_2 : i64
    linalg.yield %22, %24 : f16, i64
  } -> (tensor<1xf16>, tensor<1xi64>)
  %expanded_1 = tensor.expand_shape %19#1 [[0, 1]] : tensor<1xi64> into tensor<1x1xi64>
  return %expanded_1 : tensor<1x1xi64>
}

func.func @forward_bench() -> tensor<1x1xi64> {
  %arg0 = util.unfoldable_constant dense<5.0> : tensor<1x32000xf32>
  %c0 = arith.constant 0 : index
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0xFF800000 : f32
  %cst_0 = arith.constant 0.000000e+00 : f16
  %c-1_i64 = arith.constant -1 : i64
  %15 = tensor.empty() : tensor<1xi64>
  %16 = linalg.fill ins(%c0_i64 : i64) outs(%15 : tensor<1xi64>) -> tensor<1xi64>
  %17 = tensor.empty() : tensor<1xf32>
  %18 = linalg.fill ins(%cst : f32) outs(%17 : tensor<1xf32>) -> tensor<1xf32>
  %19:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%arg0 : tensor<1x32000xf32>) outs(%18, %16 : tensor<1xf32>, tensor<1xi64>) {
  ^bb0(%in: f32, %out: f32, %out_2: i64):
    %20 = linalg.index 1 : index
    %21 = arith.index_cast %20 : index to i64
    %22 = arith.maximumf %in, %out : f32
    %23 = arith.cmpf ogt, %in, %out : f32
    %24 = arith.select %23, %21, %out_2 : i64
    linalg.yield %22, %24 : f32, i64
  } -> (tensor<1xf32>, tensor<1xi64>)
  %expanded_1 = tensor.expand_shape %19#1 [[0, 1]] : tensor<1xi64> into tensor<1x1xi64>
  return %expanded_1 : tensor<1x1xi64>
}

func.func @forward_batch(%arg0: tensor<16x?xf32>) -> tensor<16x1xi64> {
  %c0 = arith.constant 0 : index
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0xFF800000 : f32
  %cst_0 = arith.constant 0.000000e+00 : f16
  %c-1_i64 = arith.constant -1 : i64
  %15 = tensor.empty() : tensor<16xi64>
  %16 = linalg.fill ins(%c0_i64 : i64) outs(%15 : tensor<16xi64>) -> tensor<16xi64>
  %17 = tensor.empty() : tensor<16xf32>
  %18 = linalg.fill ins(%cst : f32) outs(%17 : tensor<16xf32>) -> tensor<16xf32>
  %19:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%arg0 : tensor<16x?xf32>) outs(%18, %16 : tensor<16xf32>, tensor<16xi64>) {
  ^bb0(%in: f32, %out: f32, %out_2: i64):
    %20 = linalg.index 1 : index
    %21 = arith.index_cast %20 : index to i64
    %22 = arith.maximumf %in, %out : f32
    %23 = arith.cmpf ogt, %in, %out : f32
    %24 = arith.select %23, %21, %out_2 : i64
    linalg.yield %22, %24 : f32, i64
  } -> (tensor<16xf32>, tensor<16xi64>)
  %expanded_1 = tensor.expand_shape %19#1 [[0, 1]] : tensor<16xi64> into tensor<16x1xi64>
  return %expanded_1 : tensor<16x1xi64>
}