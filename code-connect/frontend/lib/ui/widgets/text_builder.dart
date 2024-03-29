import 'package:flutter/material.dart';

class TextBuilder extends StatelessWidget {
  const TextBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });

  final TextEditingController controller;
  final Widget Function(String text) builder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) => builder(controller.text),
    );
  }
}
