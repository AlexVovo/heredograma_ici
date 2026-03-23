import 'package:flutter/material.dart';
import '../models/pessoa_model.dart';

class RelacaoPainter extends CustomPainter {
  final Map<String, Offset> posicoes;
  final List<Pessoa> pessoas;

  RelacaoPainter(this.posicoes, this.pessoas);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.black;

    for (var p in pessoas) {
      if (p.parentesco == 'pai') {
        final filhos = pessoas.where((p) =>
    p.parentesco == 'filho' || p.parentesco == 'filha').toList();

        for (var filho in filhos) {
          final paiPos = posicoes[p.id];
          final filhoPos = posicoes[filho.id];

          if (paiPos != null && filhoPos != null) {
            canvas.drawLine(paiPos, filhoPos, paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(_) => true;
}