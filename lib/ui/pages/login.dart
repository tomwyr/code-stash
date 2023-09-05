import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../stores/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Observer(
          builder: (context) => ElevatedButton(
            onPressed: !authStore.loading ? authStore.logIn : null,
            child: const Text('Google'),
          ),
        ),
      ),
    );
  }
}
