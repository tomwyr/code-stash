import 'package:flutter/material.dart';

class AppModal extends StatelessWidget {
  const AppModal({
    super.key,
    required this.title,
    required this.content,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final Widget content;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          content,
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onAction,
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
