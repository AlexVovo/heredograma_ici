import 'package:flutter/material.dart';
import '../models/pessoa_model.dart';
import '../widgets/linha_painter.dart';

class HeredogramaView extends StatefulWidget {
  final List<Pessoa> pessoas;

  const HeredogramaView({super.key, required this.pessoas});

  @override
  State<HeredogramaView> createState() => _HeredogramaViewState();
}

class _HeredogramaViewState extends State<HeredogramaView> {
  final GlobalKey _stackKey = GlobalKey();
  final Map<String, GlobalKey> _pessoaKeys = {};
  List<LinhaConnection> _conexoes = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _atualizaConexoes());
  }

  void _atualizaConexoes() {
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null) return;

    final offsetStack = stackBox.localToGlobal(Offset.zero);
    final conexoes = <LinhaConnection>[];

    for (var filho in widget.pessoas) {
      if (filho.paiId != null) {
        final pai = widget.pessoas.where((p) => p.id == filho.paiId).toList();
        if (pai.isNotEmpty) {
          _adicionaConexao(pai.first, filho, offsetStack, conexoes,
              tipo: ConexaoTipo.parentesco);
        }
      }
      if (filho.maeId != null) {
        final mae = widget.pessoas.where((p) => p.id == filho.maeId).toList();
        if (mae.isNotEmpty) {
          _adicionaConexao(mae.first, filho, offsetStack, conexoes,
              tipo: ConexaoTipo.parentesco);
        }
      }
    }

    for (var pessoa in widget.pessoas) {
      if (pessoa.conjugeId != null) {
        final conjuge =
            widget.pessoas.where((p) => p.id == pessoa.conjugeId).toList();
        if (conjuge.isNotEmpty && pessoa.id.compareTo(conjuge.first.id) < 0) {
          _adicionaConexao(pessoa, conjuge.first, offsetStack, conexoes,
              tipo: ConexaoTipo.casamento);
        }
      }
    }

    setState(() => _conexoes = conexoes);
  }

  void _adicionaConexao(
    Pessoa parente,
    Pessoa filho,
    Offset offsetStack,
    List<LinhaConnection> conexoes, {
    required ConexaoTipo tipo,
  }) {
    final parenteKey = _pessoaKeys[parente.id];
    final filhoKey = _pessoaKeys[filho.id];
    if (parenteKey == null || filhoKey == null) return;

    final parenteBox =
        parenteKey.currentContext?.findRenderObject() as RenderBox?;
    final filhoBox = filhoKey.currentContext?.findRenderObject() as RenderBox?;
    if (parenteBox == null || filhoBox == null) return;

    final parenteCenter =
        parenteBox.localToGlobal(parenteBox.size.center(Offset.zero)) -
            offsetStack;
    final filhoCenter =
        filhoBox.localToGlobal(filhoBox.size.center(Offset.zero)) - offsetStack;

    conexoes.add(LinhaConnection(parenteCenter, filhoCenter, tipo: tipo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Heredograma')),
      backgroundColor: const Color(0xFFF4F7FB),
      body: Stack(
        key: _stackKey,
        children: [
          Positioned.fill(
            child: CustomPaint(painter: LinhaPainter(conexoes: _conexoes)),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: _buildNiveis(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNiveis() {
    return [
      _buildLinha(
          'Avós',
          widget.pessoas
              .where((p) => p.parentesco == 'avo' || p.parentesco == 'ava')
              .toList()),
      _buildLinha(
          'Pais',
          widget.pessoas
              .where((p) => p.parentesco == 'pai' || p.parentesco == 'mae')
              .toList()),
      _buildLinha(
          'Filhos',
          widget.pessoas
              .where((p) => p.parentesco == 'filho' || p.parentesco == 'filha')
              .toList()),
      _buildLinha(
          'Irmãos',
          widget.pessoas
              .where((p) => p.parentesco == 'irmao' || p.parentesco == 'irma')
              .toList()),
      _buildLinha(
          'Tios',
          widget.pessoas
              .where((p) => p.parentesco == 'tia' || p.parentesco == 'tio')
              .toList()),
    ];
  }

  Widget _buildLinha(String titulo, List<Pessoa> lista) {
    if (lista.isEmpty) return const SizedBox();

    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          titulo,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.indigo[900],
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 16,
          children: lista.map((p) => _buildPessoa(p)).toList(),
        ),
      ],
    );
  }

  Widget _buildPessoa(Pessoa p) {
    _pessoaKeys.putIfAbsent(p.id, () => GlobalKey());

    return Container(
      key: _pessoaKeys[p.id],
      width: 95,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildIconPessoa(p),
          const SizedBox(height: 8),

          Text(
            p.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),

          // 🔥 Info clínica
          if (p.temCancer && p.tipoCancer != null)
            Text(
              '${p.tipoCancer} (${p.idadeDiagnostico ?? "-"})',
              style: const TextStyle(fontSize: 10, color: Colors.red),
              textAlign: TextAlign.center,
            ),

          if (p.portador && !p.temCancer)
            const Text(
              'Portador',
              style: TextStyle(fontSize: 10, color: Colors.orange),
            ),

          Text(
            p.parentesco,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildIconPessoa(Pessoa p) {
    final shape = p.sexo == 'M' ? BoxShape.rectangle : BoxShape.circle;

    Color borderColor = Colors.green.shade700;

    if (p.temCancer) {
      borderColor = Colors.red.shade900;
    } else if (p.portador) {
      borderColor = Colors.orange;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: shape,
            color: p.temCancer ? Colors.black : Colors.white,
            border: Border.all(color: borderColor, width: 2),
          ),
        ),

        // 🔥 meio preenchido (portador)
        if (p.portador && !p.temCancer)
          ClipRect(
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: 0.5,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.6),
                  shape: shape,
                ),
              ),
            ),
          ),

        Icon(
          p.sexo == 'M' ? Icons.male : Icons.female,
          color: p.temCancer ? Colors.white : borderColor,
          size: 26,
        ),
      ],
    );
  }
}
