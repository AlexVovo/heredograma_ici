import 'package:flutter/material.dart';
import '../models/pessoa_model.dart';
import '../widgets/linha_painter.dart';

class HeredogramaView extends StatelessWidget {
  final List<Pessoa> pessoas;

  const HeredogramaView({super.key, required this.pessoas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Heredograma')),

      body: Stack(
        children: [
          // 🔥 LINHA (teste)
          Positioned.fill(
            child: CustomPaint(
              painter: LinhaPainter(
                inicio: const Offset(100, 100),
                fim: const Offset(100, 250),
              ),
            ),
          ),

          // 🔥 PESSOAS
          SingleChildScrollView(
            child: Column(
              children: _buildNiveis(),
            ),
          ),
        ],
      ),
    );
  }

  // 🔽 ORGANIZA OS NÍVEIS
  List<Widget> _buildNiveis() {
    return [
      _buildLinha('Avós',
          pessoas.where((p) => p.parentesco == 'avo').toList()),
      _buildLinha('Pais',
          pessoas.where((p) => p.parentesco == 'pai').toList()),
      _buildLinha('Filhos',
          pessoas.where((p) => p.parentesco == 'filho').toList()),
      _buildLinha('Irmãos',
          pessoas.where((p) => p.parentesco == 'irmao').toList()),
      _buildLinha('Tios',
          pessoas.where((p) =>
              p.parentesco == 'tia' || p.parentesco == 'tio').toList()),
    ];
  }

  // 🔽 LINHA DE PESSOAS
  Widget _buildLinha(String titulo, List<Pessoa> lista) {
    if (lista.isEmpty) return const SizedBox();

    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: lista.map((p) => _buildPessoa(p)).toList(),
        ),
      ],
    );
  }

  // 🔽 WIDGET DA PESSOA
  Widget _buildPessoa(Pessoa p) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: p.sexo == 'M'
                  ? BoxShape.rectangle
                  : BoxShape.circle,
              color: p.temCancer ? Colors.black : Colors.white,
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
          const SizedBox(height: 6),
          Text(p.nome, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}