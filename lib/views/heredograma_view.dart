import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:heredograma_ici/widgets/branded_app_bar.dart';

import '../models/pedigree_layout.dart';
import '../models/pessoa_model.dart';

class HeredogramaView extends StatelessWidget {
  final List<Pessoa> pessoas;

  const HeredogramaView({super.key, required this.pessoas});

  @override
  Widget build(BuildContext context) {
    final layout = PedigreeLayout.fromPeople(pessoas);
    return Scaffold(
      appBar: const BrandedAppBar(title: 'Heredograma clínico'),
      backgroundColor: const Color(0xFFF7F7F4),
      body: pessoas.isEmpty
          ? const Center(child: Text('Nenhuma pessoa para visualizar.'))
          : Column(
              children: [
                Material(
                  color: Theme.of(context).colorScheme.surface,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.zoom_in, size: 18),
                        SizedBox(width: 6),
                        Text(
                            'Arraste para mover • Use pinça ou roda para ampliar'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InteractiveViewer(
                    constrained: false,
                    minScale: 0.35,
                    maxScale: 3,
                    boundaryMargin: const EdgeInsets.all(300),
                    child: CustomPaint(
                      size: Size(layout.width, layout.height),
                      painter: _ClinicalPedigreePainter(pessoas, layout),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ClinicalPedigreePainter extends CustomPainter {
  static const symbolSize = 42.0;
  final List<Pessoa> people;
  final PedigreeLayout layout;

  _ClinicalPedigreePainter(this.people, this.layout);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFFDFCF8), BlendMode.src);
    final linePaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    for (final line in layout.relationshipLines) {
      canvas.drawLine(
        Offset(line.start.x, line.start.y),
        Offset(line.end.x, line.end.y),
        linePaint,
      );
    }

    final rows = layout.positions.values
        .map((point) => point.y)
        .toSet()
        .toList()
      ..sort();
    for (var i = 0; i < rows.length; i++) {
      _text(canvas, _roman(i + 1), const Offset(24, 0),
          y: rows[i] - 8, bold: true, size: 15);
    }

    for (var index = 0; index < people.length; index++) {
      final person = people[index];
      final point = layout.positions[person.id];
      if (point == null) continue;
      _drawPerson(canvas, person, point, index + 1);
    }
    _drawLegend(canvas, size);
  }

  void _drawPerson(
      Canvas canvas, Pessoa person, PedigreePoint point, int index) {
    final center = Offset(point.x, point.y);
    final fill = person.temCancer
        ? _diagnosisColor(person.tipoCancer)
        : person.portador
            ? Colors.orange.shade300
            : Colors.white;
    final paint = Paint()
      ..color = fill
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final rect =
        Rect.fromCenter(center: center, width: symbolSize, height: symbolSize);
    if (person.sexo == 'F') {
      canvas.drawCircle(center, symbolSize / 2, paint);
      canvas.drawCircle(center, symbolSize / 2, border);
    } else if (person.sexo == 'I' || person.sexo == 'N') {
      final path = Path()
        ..moveTo(center.dx, center.dy - symbolSize / 2)
        ..lineTo(center.dx + symbolSize / 2, center.dy)
        ..lineTo(center.dx, center.dy + symbolSize / 2)
        ..lineTo(center.dx - symbolSize / 2, center.dy)
        ..close();
      canvas.drawPath(path, paint);
      canvas.drawPath(path, border);
    } else {
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, border);
    }
    _text(canvas, '$index', Offset(center.dx - symbolSize / 2, 0),
        y: center.dy - symbolSize / 2 - 18, size: 10);
    if (_isDeceased(person)) {
      canvas.drawLine(
        Offset(center.dx - 27, center.dy + 27),
        Offset(center.dx + 27, center.dy - 27),
        border,
      );
    }
    if (_isProband(person)) {
      final arrow = Paint()
        ..color = Colors.black87
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      final start = Offset(center.dx - 45, center.dy + 48);
      final end = Offset(center.dx - 22, center.dy + 22);
      canvas.drawLine(start, end, arrow);
      canvas.drawLine(end, Offset(end.dx - 2, end.dy + 9), arrow);
      canvas.drawLine(end, Offset(end.dx - 9, end.dy + 2), arrow);
    }
    final details = <String>[
      person.nome,
      if (person.tipoCancer?.trim().isNotEmpty == true) person.tipoCancer!,
      if (person.idadeDiagnostico != null)
        'Diagnóstico: ${person.idadeDiagnostico} anos',
    ];
    for (var i = 0; i < details.length; i++) {
      _text(canvas, details[i], Offset(center.dx - 66, 0),
          y: center.dy + 29 + i * 14,
          bold: i == 0,
          size: i == 0 ? 11 : 9,
          width: 132);
    }
  }

  void _drawLegend(Canvas canvas, Size size) {
    final diagnoses = people
        .where((p) => p.temCancer && p.tipoCancer?.trim().isNotEmpty == true)
        .map((p) => p.tipoCancer!)
        .toSet()
        .toList();
    if (diagnoses.isEmpty) return;
    final x = math.max(50.0, size.width / 2 - 90);
    var y = size.height - 38 - diagnoses.length * 18;
    _text(canvas, 'LEGENDA', Offset(x, 0), y: y, bold: true, size: 11);
    y += 18;
    for (final diagnosis in diagnoses) {
      canvas.drawRect(
        Rect.fromLTWH(x, y + 2, 10, 10),
        Paint()..color = _diagnosisColor(diagnosis),
      );
      _text(canvas, diagnosis, Offset(x + 16, 0), y: y, size: 9, width: 220);
      y += 18;
    }
  }

  Color _diagnosisColor(String? diagnosis) {
    final value = diagnosis?.toLowerCase() ?? '';
    if (value.contains('sarcoma de ewing')) {
      return const Color(0xFF258A3E);
    }
    if (value.contains('leucemia')) return const Color(0xFF6A4C93);
    if (value.contains('linfoma')) return const Color(0xFF2673B8);
    if (value.contains('nenhum') || value.contains('desconhecido')) {
      return Colors.white;
    }
    return const Color(0xFFB4413E);
  }

  bool _isProband(Pessoa person) {
    final value = person.parentesco.toLowerCase();
    return value == 'filho' || value == 'filha' || value == 'filho(a)';
  }

  bool _isDeceased(Pessoa person) {
    // The compact Pessoa model does not yet persist vital status separately.
    return false;
  }

  void _text(
    Canvas canvas,
    String text,
    Offset offset, {
    required double y,
    double size = 10,
    bool bold = false,
    double width = 80,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black87,
          fontSize: size,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '…',
    )..layout(maxWidth: width);
    painter.paint(canvas, Offset(offset.dx, y));
  }

  String _roman(int value) {
    const numerals = ['I', 'II', 'III', 'IV', 'V', 'VI'];
    return value <= numerals.length ? numerals[value - 1] : '$value';
  }

  @override
  bool shouldRepaint(covariant _ClinicalPedigreePainter oldDelegate) => true;
}
