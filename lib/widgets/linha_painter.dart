import 'package:flutter/material.dart';

enum ConexaoTipo { parentesco, casamento }

class LinhaConnection {
  final Offset inicio;
  final Offset fim;
  final ConexaoTipo tipo;

  LinhaConnection(this.inicio, this.fim, {this.tipo = ConexaoTipo.parentesco});
}

class LinhaPainter extends CustomPainter {
  final List<LinhaConnection> conexoes;

  LinhaPainter({required this.conexoes});

  @override
  void paint(Canvas canvas, Size size) {
    for (var conexao in conexoes) {
      final paint = Paint()
        ..strokeWidth = conexao.tipo == ConexaoTipo.casamento ? 2 : 3
        ..color = conexao.tipo == ConexaoTipo.casamento ? Colors.blueAccent : Colors.redAccent
        ..style = PaintingStyle.stroke;

      if (conexao.tipo == ConexaoTipo.casamento) {
        // simulação de linha tracejada
        const dashWidth = 8.0;
        const dashSpace = 6.0;
        final path = Path()..moveTo(conexao.inicio.dx, conexao.inicio.dy);
        path.lineTo(conexao.fim.dx, conexao.fim.dy);

        final pathMetrics = path.computeMetrics();
        for (final metric in pathMetrics) {
          double distance = 0.0;
          while (distance < metric.length) {
            final next = distance + dashWidth;
            final extractPath = metric.extractPath(distance, next.clamp(0.0, metric.length));
            canvas.drawPath(extractPath, paint);
            distance = next + dashSpace;
          }
        }
      } else {
        canvas.drawLine(conexao.inicio, conexao.fim, paint);
      }
    }
  }

  @override
  bool shouldRepaint(LinhaPainter oldDelegate) => oldDelegate.conexoes != conexoes;
}
