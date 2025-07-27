// ignore_for_file: avoid_print

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_magic_url/config.dart';

class AuthClient {
  late final _client = Client().setEndpoint(projectEndpoint).setProject(projectId).setSelfSigned();
  late final _account = Account(_client);

  Future<User?> getUser() async {
    try {
      return await _account.get();
    } on AppwriteException catch (e) {
      if (e.code == 401) return null;

      rethrow;
    }
  }

  Future<void> initiateLogIn({
    required String email,
  }) async {
    await _account.createMagicURLSession(
      userId: 'unique()',
      email: email,
      url: magicUrlCallbackUrl,
    );
  }

  Future<void> finishLogIn({
    required String userId,
    required String secret,
  }) async {
    await _account.updateMagicURLSession(
      userId: userId,
      secret: secret,
    );
  }

  Future<void> logOut() async {
    await _account.deleteSessions();
  }
}
