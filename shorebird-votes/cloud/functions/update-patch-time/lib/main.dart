import 'package:dart_appwrite/dart_appwrite.dart';

Future<void> start(final req, final res) async {
  const endpoint = 'https://cloud.appwrite.io/v1';
  const documentId = 'current';

  final apiKey = req.env['APPWRITE_UPDATE_PATCH_TIME_KEY'];
  final projectId = req.env['APPWRITE_PROJECT_ID'];
  final databaseId = req.env['APPWRITE_DATABASE_ID'];
  final collectionId = req.env['APPWRITE_APP_INFO_ID'];

  final client =
      Client().setEndpoint(endpoint).setProject(projectId).setKey(apiKey).setSelfSigned();

  final databases = Databases(client);

  final doc = await databases.updateDocument(
    databaseId: databaseId,
    collectionId: collectionId,
    documentId: documentId,
    data: {
      'patchTime': DateTime.now().toIso8601String(),
    },
  );

  return res.json(doc.data);
}
