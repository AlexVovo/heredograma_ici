import 'package:flutter/material.dart';

class LinhaPainter extends CustomPainter {
  final Offset inicio;
  final Offset fim;

  LinhaPainter({required this.inicio, required this.fim});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4
      ..color = Colors.red; // deixa vermelho pra testar

    canvas.drawLine(inicio, fim, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}