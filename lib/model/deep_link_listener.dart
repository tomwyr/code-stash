import 'dart:async';

import 'package:appwrite_magic_url/config.dart';
import 'package:uni_links/uni_links.dart';

typedef FinishLogInCallback = void Function(String userId, String secret);

class DeepLinkListener {
  StreamSubscription listenFinishLogIn(FinishLogInCallback callback) {
    return uriLinkStream.listen((uri) {
      final isLoginCallback = uri != null && uri.toString().startsWith(magicUrlCallbackUrl);

      if (!isLoginCallback) return;

      final userId = uri.queryParameters['userId'];
      final secret = uri.queryParameters['secret'];

      if (userId == null || secret == null) return;

      callback(userId, secret);
    });
  }
}
