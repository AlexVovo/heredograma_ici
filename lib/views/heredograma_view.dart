import 'package:flutter/material.dart';
import 'package:heredograma_ici/widgets/branded_app_bar.dart';
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
      appBar: const BrandedAppBar(title: 'Heredograma'),
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
    final niveis = [
      {
        'titulo': 'Avós',
        'lista': _pessoasDoGrupo('avos'),
      },
      {
        'titulo': 'Pais',
        'lista': _pessoasDoGrupo('pais'),
      },
      {
        'titulo': 'Filhos',
        'lista': _pessoasDoGrupo('filhos'),
      },
      {
        'titulo': 'Irmãos',
        'lista': _pessoasDoGrupo('irmaos'),
      },
      {
        'titulo': 'Tios',
        'lista': _pessoasDoGrupo('tios'),
      },
      {
        'titulo': 'Primos',
        'lista': _pessoasDoGrupo('primos'),
      },
      {
        'titulo': 'Outros',
        'lista': _pessoasDoGrupo('outros'),
      },
    ];

    return niveis.map((nivel) {
      return _buildLinhaArvore(
          nivel['titulo'] as String, nivel['lista'] as List<Pessoa>);
    }).toList();
  }

  List<Pessoa> _pessoasDoGrupo(String grupo) => widget.pessoas
      .where((pessoa) => _grupoParentesco(pessoa.parentesco) == grupo)
      .toList();

  String _grupoParentesco(String parentesco) {
    final texto = parentesco.toLowerCase();
    if (texto == 'pai' || texto == 'mae' || texto == 'mãe') return 'pais';
    if (texto.contains('avô') ||
        texto.contains('avó') ||
        texto == 'avo' ||
        texto == 'ava') {
      return 'avos';
    }
    if (texto.contains('irmão') ||
        texto.contains('irmã') ||
        texto == 'irmao' ||
        texto == 'irma') {
      return 'irmaos';
    }
    if (texto.contains('tio') || texto.contains('tia')) return 'tios';
    if (texto.contains('primo') || texto.contains('prima')) return 'primos';
    if (texto.contains('filho') || texto.contains('filha')) return 'filhos';
    return 'outros';
  }

  Widget _buildLinhaArvore(String titulo, List<Pessoa> lista) {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: lista
              .map((p) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildPessoaArvore(p),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPessoaArvore(Pessoa p) {
    _pessoaKeys.putIfAbsent(p.id, GlobalKey.new);
    final isMale = p.sexo == 'M';
    final shape = isMale ? BoxShape.rectangle : BoxShape.circle;
    Color borderColor = Colors.green.shade700;
    if (p.temCancer) {
      borderColor = Colors.red.shade900;
    } else if (p.portador) {
      borderColor = Colors.orange;
    }
    return Container(
      key: _pessoaKeys[p.id],
      width: 110,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.10 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: shape,
              color: p.temCancer ? Colors.black : Colors.white,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Center(
              child: Icon(
                isMale ? Icons.male : Icons.female,
                color: isMale ? Colors.blue[700] : Colors.green[700],
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            p.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (p.temCancer && p.tipoCancer != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '${p.tipoCancer} (${p.idadeDiagnostico ?? "-"})',
                style: const TextStyle(fontSize: 10, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          if (p.portador && !p.temCancer)
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                'Portador',
                style: TextStyle(fontSize: 10, color: Colors.orange),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              p.parentesco,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
