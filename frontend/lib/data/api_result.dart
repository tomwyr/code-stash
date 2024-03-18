import 'package:code_connect_common/code_connect_common.dart';
import 'package:dio/dio.dart';
import 'package:rust_core/result.dart';

typedef ApiResult<S> = Future<Result<S, AppError>>;

extension ApiErrorResult<S, F extends AppError> on Future<Result<S, F>> {
  ApiResult<S> toApiResult() async {
    try {
      return await this;
    } on DioException catch (_) {
      return OtherError().toErr();
    }
  }
}
