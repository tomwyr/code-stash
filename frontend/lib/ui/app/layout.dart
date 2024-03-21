import 'package:flutter/material.dart';

import 'theme.dart';
import 'tokens.dart';
import 'widgets.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return context.mobileLayout ? _Mobile(child: child) : _Desktop(child: child);
  }
}

class _Mobile extends StatelessWidget {
  const _Mobile({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.background,
      child: Scaffold(
        endDrawer: Drawer(
          child: AppSideBar(),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                _DesktopAppBar(),
                _BodyItem(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: AppIcon(),
      title: AppHeader(),
      titleSpacing: 0,
      actions: [
        IconButton(
          onPressed: Scaffold.of(context).openEndDrawer,
          icon: Icon(Icons.history),
        ),
      ],
    );
  }
}

class _Desktop extends StatelessWidget {
  const _Desktop({
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
          _BodyItem(child: child),
          AppSideBar(),
        ],
      ),
    );
  }
}

class _BodyItem extends StatelessWidget {
  const _BodyItem({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: child,
      ),
    );
  }
}

extension BuildContextLayout on BuildContext {
  bool get mobileLayout => MediaQuery.of(this).size.width < 900;

  AppTokens get appTokens => mobileLayout ? appTokensCompact : appTokensDefault;
}
