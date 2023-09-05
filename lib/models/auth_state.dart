import 'user.dart';

sealed class AuthState {}

class Unknown extends AuthState {}

class LoggedOut extends AuthState {}

class LoggedIn extends AuthState {
  LoggedIn({
    required this.user,
  });

  final User user;
}
