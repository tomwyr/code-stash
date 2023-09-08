import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

const endpoint = 'https://cloud.appwrite.io/v1';
final projectId = dotenv.get('APPWRITE_PROJECT_ID');
final databaseId = dotenv.get('APPWRITE_DATABASE_ID');
final issuesId = dotenv.get('APPWRITE_ISSUES_ID');
final appInfoId = dotenv.get('APPWRITE_APP_INFO_ID');

final issuesChannel = 'databases.$databaseId.collections.$issuesId.documents';
final appInfoChannel = 'databases.$databaseId.collections.$appInfoId.documents';

final client = Client().setEndpoint(endpoint).setProject(projectId).setSelfSigned();

Account createAccount() => Account(client);
Databases createDatabases() => Databases(client);
Realtime createRealtime() => Realtime(client);

const idKey = JsonKey(name: '\$id');

abstract class SessionId {
  static const current = 'current';
}

abstract class DocumentId {
  static const unique = 'unique()';
  static const appInfo = 'current';
}
