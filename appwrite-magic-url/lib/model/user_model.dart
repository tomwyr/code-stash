import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:appwrite_magic_url/model/auth_client.dart';
import 'package:appwrite_magic_url/model/deep_link_listener.dart';
import 'package:flutter/foundation.dart';

final userModel = UserModel();

class UserModel {
  final _authClient = AuthClient();
  final _deepLinkListener = DeepLinkListener();

  final _user = ValueNotifier<User?>(null);
  final _didSendEmail = ValueNotifier(false);

  late final StreamSubscription _deepLinkSubscription;

  ValueListenable<User?> get user => _user;
  ValueListenable<bool> get didSendEmail => _didSendEmail;

  void initialize() {
    _loadUser();
    _deepLinkSubscription = _deepLinkListener.listenFinishLogIn(_onFinishLogIn);
  }

  void dispose() {
    _deepLinkSubscription.cancel();
  }

  void logIn({
    required String email,
  }) async {
    await _authClient.initiateLogIn(email: email);
    _didSendEmail.value = true;
  }

  void logOut() async {
    await _authClient.logOut();
    _user.value = null;
    _didSendEmail.value = false;
  }

  void _loadUser() async {
    _user.value = await _authClient.getUser();
  }

  void _onFinishLogIn(String userId, String secret) async {
    await _authClient.finishLogIn(userId: userId, secret: secret);
    _user.value = await _authClient.getUser();
  }
}
