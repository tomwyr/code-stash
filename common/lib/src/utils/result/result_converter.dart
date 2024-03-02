import 'package:json_annotation/json_annotation.dart';
import 'package:rust_core/result.dart';

import '../../../code_connect_common.dart';
import '../json/json.dart';

class ResultConverter<S, F extends Object>
    extends JsonConverter<Result<S, F>, Map<String, dynamic>> {
  @override
  Result<S, F> fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'type': 'ok' || 'err',
          'data': Map<String, dynamic> data,
        }) {
      if (json['type'] == 'ok') {
        return getFromJson<S>().call(data).toOk();
      } else {
        return getFromJson<F>().call(data).toErr();
      }
    }

    throw NotResultDeserializableError(Result<S, F>);
  }

  @override
  Map<String, dynamic> toJson(Result<S, F> object) {
    return switch (object) {
      Ok(:var ok) => {
          'type': 'ok',
          'data': tryToJson(ok),
        },
      Err(:var err) => {
          'type': 'err',
          'data': tryToJson(err),
        },
    };
  }
}

Map<String, dynamic> tryToJson(dynamic object) {
  try {
    return object?.toJson();
  } on NoSuchMethodError {
    throw NotJsonSerializableError(object);
  }
}

class NotResultDeserializableError extends Error {
  NotResultDeserializableError(this.type);

  final Type type;
}

class NotJsonSerializableError extends Error {
  NotJsonSerializableError(this.object);

  final dynamic object;

  @override
  String toString() {
    return 'An object of type ${object.runtimeType} could not be serialized to json '
        'because it does not implement toJson method';
  }
}
