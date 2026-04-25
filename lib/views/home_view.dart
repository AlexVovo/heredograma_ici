import 'package:flutter/material.dart';
import 'package:heredograma_ici/models/heredograma_model.dart';
import 'package:heredograma_ici/views/quiz_view.dart';
import 'package:heredograma_ici/views/heredograma_detail_view.dart';
import 'heredogramas_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heredograma ICI'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner bem-vindo
            Card(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_tree,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bem-vindo',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Crie e gerencie seus heredogramas',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Seção de Ações Rápidas
            const Text(
              'Ações Rápidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Grid responsivo
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 2;
                if (constraints.maxWidth > 700) {
                  crossAxisCount = 4;
                }

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.add_circle_outline,
                      title: 'Novo',
                      subtitle: 'Heredograma',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HeredogramaDetailView(
                              heredograma: Heredograma(
                                id: '',
                                titulo: '',
                                descricao: '',
                                pessoas: [],
                                dataCriacao: DateTime.now(),
                                pacienteNome: '',
                                pacienteIdade: null,
                                pacienteSexo: 'M',
                              ),
                              isEditing: true,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.list_alt_rounded,
                      title: 'Listar',
                      subtitle: 'Heredogramas',
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HeredogramasListView(),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.quiz_outlined,
                      title: 'Quiz',
                      subtitle: 'Genética',
                      color: Colors.orange,
                      onTap: () {
                        _mostrarQuizDemo(context);
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.info_outline,
                      title: 'Sobre',
                      subtitle: 'App',
                      color: Colors.purple,
                      onTap: () {
                        _mostrarSobre(context);
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Seção de Informações
            const Text(
              'Informações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'O que é um Heredograma?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Um heredograma (ou pedigree) é um diagrama que mostra a ocorrência de uma doença genética ou traço hereditário em uma família. Ele ajuda a visualizar padrões de herança e identificar indivíduos portadores de genes recessivos.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Como Usar?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDica(
                      '1.',
                      'Clique em "Novo" para criar um novo heredograma',
                    ),
                    _buildDica(
                      '2.',
                      'Adicione os membros da família e suas informações',
                    ),
                    _buildDica(
                      '3.',
                      'Indique relações de parentesco e doenças',
                    ),
                    _buildDica(
                      '4.',
                      'Visualize e salve seu heredograma',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withValues(alpha: 0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDica(String numero, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[100],
            ),
            child: Center(
              child: Text(
                numero,
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarQuizDemo(BuildContext context) {
    final perguntas = [
      QuizPergunta(
        id: '1',
        titulo: 'O que é um gene dominante?',
        descricao:
            'Um gene que se expressa mesmo quando herdado de apenas um dos pais',
        tipo: TipoPergunta.multiplaEscolha,
        opcoes: [
          'Um gene que sempre está ativo',
          'Um gene que se expressa mesmo em dose única',
          'Um gene raro na população',
          'Um gene que causa doença',
        ],
        respostaCorreta: 'Um gene que se expressa mesmo em dose única',
        explicacao:
            'Genes dominantes se expressam mesmo quando herdados de apenas um dos pais.',
      ),
      QuizPergunta(
        id: '2',
        titulo: 'O câncer de mama hereditário está sempre presente?',
        descricao:
            'Se um membro da família tem câncer de mama hereditário, todos os portadores desenvolverão câncer?',
        tipo: TipoPergunta.simNao,
        opcoes: ['Sim', 'Não'],
        respostaCorreta: false,
        explicacao:
            'Nem todos os portadores de mutações hereditárias desenvolvem a doença. Outros fatores ambientais influenciam.',
      ),
      QuizPergunta(
        id: '3',
        titulo: 'Como é a herança autossômica recessiva?',
        descricao:
            'Descreva brevemente como funciona a herança autossômica recessiva',
        tipo: TipoPergunta.texto,
        opcoes: [],
        respostaCorreta:
            'Precisa herdar duas cópias do gene mutante (uma de cada pai)',
      ),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizView(
          titulo: 'Quiz de Genética',
          descricao: 'Teste seus conhecimentos sobre hereditariedade',
          perguntas: perguntas,
        ),
      ),
    );
  }

  void _mostrarSobre(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Heredograma ICI',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'App profissional para criação e gerenciamento de heredogramas.',
            ),
            SizedBox(height: 12),
            Text(
              'Versão: 1.0.0',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              '© 2026 - Todos os direitos reservados',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
