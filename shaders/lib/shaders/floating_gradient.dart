import 'dart:ui';

import 'package:flutter/material.dart';

// https://stegu.github.io/webgl-noise/webdemo/
// https://rtouti.github.io/graphics/perlin-noise-algorithm
// https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83

class FloatingGradient extends StatefulWidget {
  const FloatingGradient({super.key});

  @override
  State<FloatingGradient> createState() => _FloatingGradientState();
}

class _FloatingGradientState extends State<FloatingGradient> with SingleTickerProviderStateMixin {
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
      duration: const Duration(seconds: 500),
      upperBound: 250,
    )..repeat();
  }

  void _loadShaderAsset() async {
    final program = await FragmentProgram.fromAsset('shaders/floating_gradient.frag');
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
          blendMode: BlendMode.src,
          shaderCallback: (rect) => _createShader(rect),
          child: const SizedBox.square(
            dimension: 300,
            child: ColoredBox(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
