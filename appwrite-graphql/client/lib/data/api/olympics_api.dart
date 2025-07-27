import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart';

import 'package:appwrite_graphql_client/utils/typedefs.dart';
import 'olympics_api_error.dart';

class OlympicsApi {
  OlympicsApi({
    required this.graphQLClient,
  });

  static const _baseUrl = '127.0.0.1:4000/graphql';
  static const httpUrl = 'http://$_baseUrl';
  static const webSocketUrl = 'ws://$_baseUrl';

  final GraphQLClient graphQLClient;

  Future<JsonObject> request(String document, {JsonObject? input}) async {
    final resultData = await _tryRequest(document, input: input);

    return resultData as JsonObject;
  }

  Future<JsonArray> requestMany(String document, {JsonObject? input}) async {
    final resultData = await _tryRequest(document, input: input);

    return (resultData as List).cast<JsonObject>();
  }

  Stream<JsonObject> observe(String document, {JsonObject? input}) {
    final documentNode = gql(document);

    final actionName = _getActionName(documentNode);

    final options = SubscriptionOptions(
      document: documentNode,
      variables: {
        if (input != null) 'input': input,
      },
    );

    final resultTransformer = StreamTransformer<QueryResult, JsonObject>.fromHandlers(
      handleData: (result, sink) {
        if (result.hasException) {
          sink.addError(RequestFailed(exception: result.exception!));
        } else {
          sink.add(result.data![actionName]);
        }
      },
      handleError: (error, stackTrace, sink) {
        sink.addError(UnknownRequestException(exception: error));
      },
    );

    return graphQLClient.subscribe(options).transform(resultTransformer);
  }

  Future _tryRequest(String document, {JsonObject? input}) async {
    try {
      return await _request(document, input: input);
    } catch (e) {
      throw UnknownRequestException(exception: e);
    }
  }

  Future _request(String document, {JsonObject? input}) async {
    final documentNode = gql(document);

    final actionName = _getActionName(documentNode);

    final options = QueryOptions(
      document: documentNode,
      variables: {
        if (input != null) 'input': input,
      },
    );

    final result = await graphQLClient.query(options);

    if (result.hasException) throw RequestFailed(exception: result.exception!);

    return result.data![actionName];
  }

  String _getActionName(DocumentNode documentNode) {
    final error = UnexpectedDocumentFormat();

    final definitions = documentNode.definitions;
    if (definitions.length != 1) throw error;

    final actionDefinition = definitions[0];
    if (actionDefinition is! OperationDefinitionNode) throw error;

    final fieldSelections = actionDefinition.selectionSet.selections
        .whereType<FieldNode>()
        .where((selection) => selection.name.value != '__typename');
    if (fieldSelections.length != 1) throw error;

    return fieldSelections.first.name.value;
  }
}
