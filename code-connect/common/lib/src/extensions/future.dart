import 'package:dio/dio.dart';
import 'package:rust_core/result.dart';

import '../utils/result/response_result.dart';

extension ResponseToResult on Future<Response> {
  Future<Result<S, F>> toResult<S, F extends Object>() => ResponseResult<S, F>().convert(this);
}
