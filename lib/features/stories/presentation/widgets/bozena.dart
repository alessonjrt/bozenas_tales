import 'package:flutter/material.dart';

class Bozena extends StatelessWidget {
  final double? width;
  final double? height;
  const Bozena({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/bozenalogo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
