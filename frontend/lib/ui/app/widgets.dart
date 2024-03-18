import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/env.dart';
import '../features/find_history/list.dart';
import 'layout.dart';
import 'theme.dart';
import 'tokens.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.translate(
          offset: Offset(-8, 0),
          child: Icon(
            Icons.keyboard_arrow_right,
            color: colors.complementary,
            size: 28,
          ),
        ),
        Flexible(
          child: Transform.translate(
            offset: Offset(-12, 0),
            child: Text(
              _texts.header,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RepoLink(
        child: Image.asset(
          'assets/icon.png',
          height: 24,
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Container(
      width: 200,
      padding: EdgeInsets.all(tokens.contentMargin) + EdgeInsets.only(top: 8),
      alignment: Alignment.topRight,
      child: RepoLink(
        child: Padding(
          padding: EdgeInsets.all(tokens.contentPadding),
          child: Image.asset(
            'assets/logo.png',
            height: 32,
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
    final tokens = context.appTokens;

    return Container(
      margin: EdgeInsets.all(tokens.contentMargin),
      constraints: BoxConstraints(maxWidth: 600),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        clipBehavior: Clip.hardEdge,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(tokens.contentPadding),
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
        padding: EdgeInsets.all(appTokensDefault.contentMargin),
        child: FindHistoryList(),
      ),
    );
  }
}

class RepoLink extends StatelessWidget {
  const RepoLink({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrlString(Env.projectRepoUrl),
        child: child,
      ),
    );
  }
}

const _texts = (header: 'Form Teams Effortlessly');
