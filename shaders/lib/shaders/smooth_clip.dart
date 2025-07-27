import 'dart:ui';

import 'package:flutter/material.dart';

class SmoothClip extends StatefulWidget {
  const SmoothClip({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<SmoothClip> createState() => _SmoothClipState();
}

class _SmoothClipState extends State<SmoothClip> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  FragmentShader? shader;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _loadShaderAsset();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _setupAnimation() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void _loadShaderAsset() async {
    final program = await FragmentProgram.fromAsset('shaders/smooth_clip.frag');
    final shader = program.fragmentShader();

    setState(() {
      this.shader = shader;
    });
  }

  Shader _createShader(Rect rect) {
    return shader!
      ..setFloat(0, controller.value)
      ..setFloat(1, rect.width)
      ..setFloat(2, rect.height);
  }

  @override
  Widget build(BuildContext context) {
    if (shader == null) {
      return const SizedBox.shrink();
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) => ShaderMask(
          blendMode: BlendMode.dstOut,
          shaderCallback: (rect) => _createShader(rect),
          child: widget.child,
        ),
      ),
    );
  }
}
