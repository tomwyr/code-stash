import 'package:appwrite/models.dart';
import 'package:appwrite_magic_url/model/user_model.dart';
import 'package:appwrite_magic_url/widgets/logged_in.dart';
import 'package:appwrite_magic_url/widgets/logged_out.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    userModel.initialize();
  }

  @override
  void dispose() {
    userModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Material(
          child: ValueListenableBuilder<User?>(
            valueListenable: userModel.user,
            builder: (_, user, __) => user == null ? const LoggedOut() : LoggedIn(user: user),
          ),
        ),
      );
}
