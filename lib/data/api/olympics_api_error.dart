import 'package:graphql/client.dart';

abstract class OlympicsApiException implements Exception {}

class UnexpectedDocumentFormat extends OlympicsApiException {}

class RequestFailed extends OlympicsApiException {
  RequestFailed({
    required this.exception,
  });

  final OperationException exception;

  @override
  String toString() => 'ResultException(exception: $exception)';
}

class UnknownRequestException extends OlympicsApiException {
  UnknownRequestException({
    required this.exception,
  });

  final Object exception;

  @override
  String toString() => 'UnknownRequestException(exception: $exception)';
}
