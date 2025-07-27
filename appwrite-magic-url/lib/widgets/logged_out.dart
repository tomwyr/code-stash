import 'package:appwrite_magic_url/model/user_model.dart';
import 'package:flutter/material.dart';

class LoggedOut extends StatelessWidget {
  const LoggedOut({Key? key}) : super(key: key);

  static final _emailKey = GlobalKey<FormFieldState<String>>();

  String get _emailValue => _emailKey.currentState?.value ?? '';

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              key: _emailKey,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => userModel.logIn(email: _emailValue),
              child: const Text("Log In"),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: userModel.didSendEmail,
              builder: (_, didSendEmail, __) => didSendEmail
                  ? const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text("Check Your Email!"),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
}
