import 'package:flutter/material.dart';

class SimpleHeredogramaDemo extends StatelessWidget {
  const SimpleHeredogramaDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        title: const Text('Heredograma simples'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildPedigreeCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exemplo visual de heredograma',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Homens em quadrado, mulheres em círculo, afetados em azul e não afetados em branco.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPedigreeCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(double.infinity, 760),
              painter: _SimplePedigreePainter(),
            ),
            Column(
              children: [
                _buildGeneration('Geração 1', [
                  _PessoaNode(
                    nome: 'Carlos',
                    sexo: 'M',
                    afetado: true,
                  ),
                  _PessoaNode(
                    nome: 'Maria',
                    sexo: 'F',
                    afetado: false,
                  ),
                ]),
                const SizedBox(height: 24),
                _buildGeneration('Geração 2', [
                  _PessoaNode(
                    nome: 'Paulo',
                    sexo: 'M',
                    afetado: true,
                  ),
                  _PessoaNode(
                    nome: 'Ana',
                    sexo: 'F',
                    afetado: false,
                  ),
                ]),
                const SizedBox(height: 24),
                _buildGeneration('Geração 3', [
                  _PessoaNode(
                    nome: 'Pedro',
                    sexo: 'M',
                    afetado: true,
                  ),
                  _PessoaNode(
                    nome: 'Lucia',
                    sexo: 'F',
                    afetado: false,
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneration(String titulo, List<_PessoaNode> pessoas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: pessoas
              .map((pessoa) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildPessoaCard(pessoa),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPessoaCard(_PessoaNode pessoa) {
    final isMale = pessoa.sexo == 'M';
    final backgroundColor =
        pessoa.afetado ? Colors.blue.shade800 : Colors.white;
    final textColor = pessoa.afetado ? Colors.white : Colors.black87;

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: isMale ? BoxShape.rectangle : BoxShape.circle,
            color: backgroundColor,
            border: Border.all(
              color: pessoa.afetado
                  ? Colors.blue.shade900
                  : Colors.indigo.shade200,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            pessoa.nome.substring(0, 1).toUpperCase(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 84,
          child: Text(
            pessoa.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _PessoaNode {
  final String nome;
  final String sexo;
  final bool afetado;

  const _PessoaNode({
    required this.nome,
    required this.sexo,
    required this.afetado,
  });
}

class _SimplePedigreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.indigo.withValues(alpha: 0.4)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Linha vertical conectando gerações
    canvas.drawLine(
      Offset(size.width / 2, 110),
      Offset(size.width / 2, 260),
      paint,
    );

    // Linhas horizontais de cada geração
    canvas.drawLine(
      Offset(70, 115),
      Offset(size.width - 70, 115),
      paint,
    );

    canvas.drawLine(
      Offset(70, 250),
      Offset(size.width - 70, 250),
      paint,
    );

    canvas.drawLine(
      Offset(70, 385),
      Offset(size.width - 70, 385),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 2, 115),
      Offset(size.width / 2, 250),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 2, 250),
      Offset(size.width / 2, 385),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
