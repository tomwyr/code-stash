import 'package:appwrite/models.dart';
import 'package:appwrite_magic_url/model/user_model.dart';
import 'package:flutter/material.dart';

class LoggedIn extends StatelessWidget {
  const LoggedIn({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.email),
            const SizedBox(height: 12),
            Text("ID: ${user.$id}"),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: userModel.logOut,
              child: const Text("Log Out"),
            ),
          ],
        ),
      );
}
