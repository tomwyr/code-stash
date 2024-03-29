import 'package:flutter/material.dart';

typedef DisplayError = void Function(String message);

class ErrorDisplayer extends StatefulWidget {
  const ErrorDisplayer({
    super.key,
    required this.onInit,
    required this.child,
  });

  final void Function(DisplayError displayError) onInit;
  final Widget child;

  static ErrorDisplayerState of(BuildContext context) {
    return context.findAncestorStateOfType()!;
  }

  @override
  State<ErrorDisplayer> createState() => ErrorDisplayerState();
}

class ErrorDisplayerState extends State<ErrorDisplayer> {
  @override
  void initState() {
    super.initState();
    widget.onInit(showError);
  }

  void showError(String message) {
    late VoidCallback closeBanner;
    final banner = MaterialBanner(
      content: Text(message),
      actions: [
        CloseButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: () => closeBanner(),
        ),
      ],
    );

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearMaterialBanners();
    final controller = messenger.showMaterialBanner(banner);
    closeBanner = controller.close;
  }

  @override
  Widget build(BuildContext context) => Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => widget.child,
          ),
        ],
      );
}

extension BuildContextErrorDisplayer on BuildContext {
  DisplayError get showError => ErrorDisplayer.of(this).showError;
}
