import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../models/auth_state.dart';
import '../../../stores/auth.dart';

class AuthNavigator extends StatefulWidget {
  const AuthNavigator({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  State<AuthNavigator> createState() => _AuthNavigatorState();
}

class _AuthNavigatorState extends State<AuthNavigator> {
  late final ReactionDisposer _disposer;

  var _lastAuthState = authStore.authState;

  @override
  void initState() {
    super.initState();
    _disposer = reaction(
      (_) => authStore.authState,
      _onAuthStateChanged,
    );
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  void _onAuthStateChanged(AuthState authState) {
    final nextRoute = switch (authStore.authState) {
      LoggedIn() => _lastAuthState is! LoggedIn ? '/issues' : null,
      LoggedOut() => _lastAuthState is! LoggedOut ? '/login' : null,
      Unknown() => _lastAuthState is! Unknown ? '/' : null,
    };

    _lastAuthState = authState;

    if (nextRoute != null) {
      widget.navigatorKey.currentState?.pushReplacementNamed(nextRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
