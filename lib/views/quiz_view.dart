import 'package:flutter/material.dart';
import 'package:heredograma_ici/widgets/branded_app_bar.dart';

import 'family_interview_field.dart';

class QuizPergunta {
  final String id;
  final String secao;
  final String titulo;
  final String descricao;
  final TipoPergunta tipo;
  final List<String> opcoes;
  final bool obrigatoria;

  const QuizPergunta({
    required this.id,
    required this.secao,
    required this.titulo,
    this.descricao = '',
    required this.tipo,
    this.opcoes = const [],
    this.obrigatoria = false,
  });
}

enum TipoPergunta {
  multiplaEscolha,
  simNao,
  simNaoDesconhecido,
  texto,
  textoLongo,
  numero,
  data,
  familiares,
}

class QuizResultado {
  final int totalPerguntas;
  final int respondidas;
  final List<RespostaPergunta> respostas;

  const QuizResultado({
    required this.totalPerguntas,
    required this.respondidas,
    required this.respostas,
  });

  double get percentualPreenchido =>
      totalPerguntas == 0 ? 0 : respondidas / totalPerguntas * 100;
}

class RespostaPergunta {
  final String perguntaId;
  final dynamic resposta;

  const RespostaPergunta({
    required this.perguntaId,
    required this.resposta,
  });
}

class QuizView extends StatefulWidget {
  final String titulo;
  final String descricao;
  final List<QuizPergunta> perguntas;
  final Future<void> Function(QuizResultado)? onCompletar;

  const QuizView({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.perguntas,
    this.onCompletar,
  });

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late final PageController _pageController;
  late final List<dynamic> _respostas;
  int _paginaAtual = 0;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _respostas = List<dynamic>.filled(widget.perguntas.length, null);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _respostaPreenchida(int index) {
    final resposta = _respostas[index];
    if (resposta == null) return false;
    if (resposta is String) return resposta.trim().isNotEmpty;
    if (resposta is Iterable) return resposta.isNotEmpty;
    if (resposta is Map) return resposta.isNotEmpty;
    return true;
  }

  bool _validarPerguntaAtual() {
    final pergunta = widget.perguntas[_paginaAtual];
    if (!pergunta.obrigatoria || _respostaPreenchida(_paginaAtual)) {
      return true;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preencha este campo obrigatório.')),
    );
    return false;
  }

  void _proximaPagina() {
    if (!_validarPerguntaAtual()) return;

    if (_paginaAtual < widget.perguntas.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _paginaAnterior() {
    if (_paginaAtual > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finalizarQuestionario() async {
    if (!_validarPerguntaAtual()) return;

    final respostasDetalhadas = <RespostaPergunta>[];
    var respondidas = 0;

    for (var i = 0; i < widget.perguntas.length; i++) {
      if (_respostaPreenchida(i)) respondidas++;
      respostasDetalhadas.add(
        RespostaPergunta(
          perguntaId: widget.perguntas[i].id,
          resposta: _respostas[i],
        ),
      );
    }

    final resultado = QuizResultado(
      totalPerguntas: widget.perguntas.length,
      respondidas: respondidas,
      respostas: respostasDetalhadas,
    );

    if (widget.onCompletar != null) {
      setState(() => _salvando = true);
      try {
        await widget.onCompletar!(resultado);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível salvar a entrevista: $e')),
        );
        setState(() => _salvando = false);
        return;
      }
    }

    if (!mounted) return;
    setState(() => _salvando = false);
    _mostrarResultado(resultado);
  }

  void _mostrarResultado(QuizResultado resultado) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.assignment_turned_in_outlined, size: 40),
        title: const Text('Formulário concluído'),
        content: Text(
          '${resultado.respondidas} de ${resultado.totalPerguntas} campos '
          'foram preenchidos.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Voltar ao início'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.perguntas.isEmpty) {
      return Scaffold(
        appBar: BrandedAppBar(title: widget.titulo),
        body: const Center(child: Text('Nenhuma pergunta disponível.')),
      );
    }

    final perguntaAtual = widget.perguntas[_paginaAtual];

    return Scaffold(
      appBar: BrandedAppBar(
        title: widget.titulo,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_paginaAtual + 1) / widget.perguntas.length,
              minHeight: 8,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      perguntaAtual.secao,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${_paginaAtual + 1} de ${widget.perguntas.length}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _paginaAtual = index);
                },
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.perguntas.length,
                itemBuilder: (context, index) {
                  return _buildPergunta(widget.perguntas[index], index);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _paginaAtual > 0 ? _paginaAnterior : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Anterior'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _salvando
                          ? null
                          : _paginaAtual == widget.perguntas.length - 1
                              ? _finalizarQuestionario
                              : _proximaPagina,
                      icon: _salvando
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              _paginaAtual == widget.perguntas.length - 1
                                  ? Icons.check
                                  : Icons.arrow_forward,
                            ),
                      label: Text(
                        _salvando
                            ? 'Salvando...'
                            : _paginaAtual == widget.perguntas.length - 1
                                ? 'Finalizar'
                                : 'Próxima',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPergunta(QuizPergunta pergunta, int index) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  pergunta.titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (pergunta.obrigatoria)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    '*',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
            ],
          ),
          if (pergunta.descricao.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                pergunta.descricao,
                style: TextStyle(color: Colors.grey[800], height: 1.4),
              ),
            ),
          ],
          const SizedBox(height: 28),
          _buildCampoResposta(pergunta, index),
        ],
      ),
    );
  }

  Widget _buildCampoResposta(QuizPergunta pergunta, int index) {
    switch (pergunta.tipo) {
      case TipoPergunta.multiplaEscolha:
        return _buildOpcoes(pergunta.opcoes, index);
      case TipoPergunta.simNao:
        return _buildOpcoes(const ['Sim', 'Não'], index);
      case TipoPergunta.simNaoDesconhecido:
        return _buildOpcoes(const ['Sim', 'Não', 'Desconhecido'], index);
      case TipoPergunta.texto:
      case TipoPergunta.textoLongo:
      case TipoPergunta.numero:
      case TipoPergunta.data:
        return TextFormField(
          key: ValueKey(pergunta.id),
          initialValue: _respostas[index]?.toString(),
          onChanged: (value) => _respostas[index] = value,
          keyboardType: switch (pergunta.tipo) {
            TipoPergunta.numero => const TextInputType.numberWithOptions(
                decimal: true,
              ),
            TipoPergunta.data => TextInputType.datetime,
            _ => TextInputType.text,
          },
          minLines: pergunta.tipo == TipoPergunta.textoLongo ? 5 : 1,
          maxLines: pergunta.tipo == TipoPergunta.textoLongo ? 10 : 1,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: switch (pergunta.tipo) {
              TipoPergunta.data => 'DD/MM/AAAA',
              TipoPergunta.numero => 'Digite um valor numérico',
              TipoPergunta.textoLongo => 'Descreva as informações disponíveis',
              _ => 'Digite sua resposta',
            },
          ),
        );
      case TipoPergunta.familiares:
        return FamilyInterviewField(
          familiares: List<Map<String, dynamic>>.from(
            _respostas[index] as List? ?? const [],
          ),
          parentescos: pergunta.opcoes,
          onChanged: (familiares) {
            setState(() => _respostas[index] = familiares);
          },
        );
    }
  }

  Widget _buildOpcoes(List<String> opcoes, int index) {
    return Column(
      children: [
        for (final opcao in opcoes)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => setState(() => _respostas[index] = opcao),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _respostas[index] == opcao
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    width: _respostas[index] == opcao ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: _respostas[index] == opcao
                      ? Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withValues(alpha: 0.5)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      _respostas[index] == opcao
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: _respostas[index] == opcao
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(opcao)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
