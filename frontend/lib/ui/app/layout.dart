import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/env.dart';
import '../features/find_history/list.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLogo(),
          Flexible(
            child: AppBody(child: child),
          ),
          AppSideBar(),
        ],
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(_tokens.contentMargin) + EdgeInsets.only(top: 8),
      alignment: Alignment.topRight,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrlString(Env.projectRepoUrl),
          child: Padding(
            padding: EdgeInsets.all(_tokens.contentPadding),
            child: Image.asset(
              'assets/icon-name.png',
              height: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class AppBody extends StatelessWidget {
  const AppBody({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(_tokens.contentMargin),
      constraints: BoxConstraints(
        maxWidth: 600,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        clipBehavior: Clip.hardEdge,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(_tokens.contentPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AppSideBar extends StatelessWidget {
  const AppSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Padding(
        padding: EdgeInsets.all(_tokens.contentMargin),
        child: FindHistoryList(),
      ),
    );
  }
}

const _tokens = (
  contentMargin: 8.0,
  contentPadding: 12.0,
);

const appTokens = _tokens;
