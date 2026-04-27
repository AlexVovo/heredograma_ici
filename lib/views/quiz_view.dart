import 'package:flutter/material.dart';

// Modelos de Quiz
class QuizPergunta {
  final String id;
  final String titulo;
  final String descricao;
  final TipoPergunta tipo;
  final List<String> opcoes;
  final dynamic respostaCorreta;
  final String? explicacao;

  QuizPergunta({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.tipo,
    required this.opcoes,
    required this.respostaCorreta,
    this.explicacao,
  });
}

enum TipoPergunta { multiplaEscolha, simNao, texto }

class QuizResultado {
  final int totalPerguntas;
  final int acertos;
  final List<RespostaPergunta> respostas;

  QuizResultado({
    required this.totalPerguntas,
    required this.acertos,
    required this.respostas,
  });

  double get percentual => (acertos / totalPerguntas * 100);
}

class RespostaPergunta {
  final String perguntaId;
  final dynamic resposta;
  final bool correta;

  RespostaPergunta({
    required this.perguntaId,
    required this.resposta,
    required this.correta,
  });
}

// Quiz View
class QuizView extends StatefulWidget {
  final String titulo;
  final String descricao;
  final List<QuizPergunta> perguntas;
  final Function(QuizResultado)? onCompletar;

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
  late PageController _pageController;
  int _paginaAtual = 0;
  late List<dynamic> _respostas;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _respostas = List.filled(widget.perguntas.length, null);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _proximaPagina() {
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

  void _finalizarQuiz() {
    // Calcular resultado
    int acertos = 0;
    final respostasDetalhadas = <RespostaPergunta>[];

    for (int i = 0; i < widget.perguntas.length; i++) {
      final pergunta = widget.perguntas[i];
      final resposta = _respostas[i];
      final correta = resposta == pergunta.respostaCorreta;

      if (correta) acertos++;

      respostasDetalhadas.add(
        RespostaPergunta(
          perguntaId: pergunta.id,
          resposta: resposta,
          correta: correta,
        ),
      );
    }

    final resultado = QuizResultado(
      totalPerguntas: widget.perguntas.length,
      acertos: acertos,
      respostas: respostasDetalhadas,
    );

    widget.onCompletar?.call(resultado);

    // Mostrar resultado
    _mostrarResultado(resultado);
  }

  void _mostrarResultado(QuizResultado resultado) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resultado do Quiz'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${resultado.acertos}/${resultado.totalPerguntas}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${resultado.percentual.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 20,
                color: resultado.percentual >= 70 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barra de progresso
          LinearProgressIndicator(
            value: (_paginaAtual + 1) / widget.perguntas.length,
            minHeight: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Pergunta ${_paginaAtual + 1} de ${widget.perguntas.length}',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          // Perguntas
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _paginaAtual = index;
                });
              },
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.perguntas.length,
              itemBuilder: (context, index) {
                final pergunta = widget.perguntas[index];
                return _buildPergunta(pergunta, index);
              },
            ),
          ),
          // Botões de navegação
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _paginaAtual > 0 ? _paginaAnterior : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Anterior'),
                ),
                if (_paginaAtual == widget.perguntas.length - 1)
                  ElevatedButton.icon(
                    onPressed: _finalizarQuiz,
                    icon: const Icon(Icons.check),
                    label: const Text('Finalizar'),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _proximaPagina,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Próxima'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPergunta(QuizPergunta pergunta, int index) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pergunta.titulo,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            pergunta.descricao,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: _buildOpcoes(pergunta, index),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcoes(QuizPergunta pergunta, int index) {
    switch (pergunta.tipo) {
      case TipoPergunta.multiplaEscolha:
        return ListView.builder(
          itemCount: pergunta.opcoes.length,
          itemBuilder: (context, i) {
            final opcao = pergunta.opcoes[i];
            final selecionada = _respostas[index] == opcao;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _respostas[index] = opcao;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selecionada ? Colors.blue : Colors.grey[300]!,
                      width: selecionada ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: selecionada
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.white,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    opcao,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          selecionada ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        );

      case TipoPergunta.simNao:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBotaoSimNao('Sim', true, index),
            _buildBotaoSimNao('Não', false, index),
          ],
        );

      case TipoPergunta.texto:
        return TextField(
          onChanged: (value) {
            setState(() {
              _respostas[index] = value;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: 'Sua resposta',
          ),
          maxLines: null,
        );
    }
  }

  Widget _buildBotaoSimNao(String label, bool valor, int index) {
    final selecionado = _respostas[index] == valor;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _respostas[index] = valor;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: selecionado ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(24),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: selecionado ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
