import 'package:mobx/mobx.dart';

import '../data/appwrite.dart';
import '../models/auth_state.dart';
import '../models/user.dart';

part 'auth.g.dart';

final authStore = AuthStore();

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final _account = createAccount();

  @readonly
  AuthState _authState = Unknown();

  @readonly
  bool _loading = false;

  @computed
  User get user {
    if (_authState case LoggedIn(:var user)) {
      return user;
    }

    throw Exception('User is not logged in.');
  }

  @action
  Future<void> initialize() async {
    if (_loading || _authState is! Unknown) return;
    _loading = true;

    try {
      final user = await _getCurrentUser();

      _authState = LoggedIn(user: user);
    } catch (_) {
      _authState = LoggedOut();
    } finally {
      _loading = false;
    }
  }

  @action
  Future<void> logIn() async {
    if (_loading || _authState is! LoggedOut) return;
    _loading = true;

    try {
      await _account.createOAuth2Session(provider: 'google');

      final user = await _getCurrentUser();

      _authState = LoggedIn(user: user);
    } finally {
      _loading = false;
    }
  }

  @action
  Future<void> logOut() async {
    if (_loading || _authState is! LoggedIn) return;
    _loading = true;

    try {
      await _account.deleteSession(sessionId: SessionId.current);

      _authState = LoggedOut();
    } finally {
      _loading = false;
    }
  }

  Future<User> _getCurrentUser() async {
    final currentAccount = await _account.get();
    return User.fromJson(currentAccount.toMap());
  }
}
