import 'package:flutter/material.dart';

import 'shaders/floating_gradient.dart';
import 'shaders/smooth_clip.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ShaderList(
          children: [
            const FloatingGradient(),
            SmoothClip(
              child: Image.asset(
                'assets/graph.png',
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShaderList extends StatelessWidget {
  const ShaderList({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        for (final shader in children) ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: SizedBox.square(
              dimension: 300,
              child: shader,
            ),
          ),
        ],
      ],
    );
  }
}
