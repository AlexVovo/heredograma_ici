import 'package:flutter/material.dart';
import 'package:heredograma_ici/data/historico_familiar_questionario.dart';
import 'package:heredograma_ici/models/heredograma_model.dart';
import 'package:heredograma_ici/models/pessoa_model.dart';
import 'package:heredograma_ici/services/firestore_service.dart';
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
                      icon: Icons.assignment_outlined,
                      title: 'Formulário',
                      subtitle: 'Histórico familiar',
                      color: Colors.orange,
                      onTap: () {
                        _abrirFormularioHistorico(context);
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

  void _abrirFormularioHistorico(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizView(
          titulo: 'Histórico familiar',
          descricao:
              'Formulário para histórico familiar em oncologia pediátrica',
          perguntas: perguntasHistoricoFamiliar,
          onCompletar: _salvarEntrevista,
        ),
      ),
    );
  }

  Future<void> _salvarEntrevista(QuizResultado resultado) async {
    bool preenchida(dynamic resposta) {
      if (resposta == null) return false;
      if (resposta is String) return resposta.trim().isNotEmpty;
      if (resposta is Iterable) return resposta.isNotEmpty;
      if (resposta is Map) return resposta.isNotEmpty;
      return true;
    }

    final respostas = <String, dynamic>{
      for (final item in resultado.respostas)
        if (preenchida(item.resposta)) item.perguntaId: item.resposta,
    };

    String texto(String id, [String fallback = '']) =>
        respostas[id]?.toString().trim() ?? fallback;
    int? numero(String id) =>
        int.tryParse(texto(id).replaceAll(',', '.').split('.').first);

    final agora = DateTime.now();
    final baseId = agora.microsecondsSinceEpoch.toString();
    final pacienteId = '${baseId}_paciente';
    final paiId = '${baseId}_pai';
    final maeId = '${baseId}_mae';
    final sexoPaciente = texto('1.4') == 'Feminino' ? 'F' : 'M';
    final temCancerPaciente = texto('3.1') == 'Sim';
    final diagnosticoPai = texto('5.6');
    final diagnosticoMae = texto('7.6');

    final pessoas = [
      Pessoa(
        id: paiId,
        nome: texto('5.1', 'Pai não informado'),
        sexo: 'M',
        parentesco: 'pai',
        temCancer: diagnosticoPai.isNotEmpty && diagnosticoPai != 'Nenhum',
        tipoCancer: diagnosticoPai.isEmpty || diagnosticoPai == 'Nenhum'
            ? null
            : diagnosticoPai,
        conjugeId: maeId,
      ),
      Pessoa(
        id: maeId,
        nome: texto('7.1', 'Mãe não informada'),
        sexo: 'F',
        parentesco: 'mae',
        temCancer: diagnosticoMae.isNotEmpty && diagnosticoMae != 'Nenhum',
        tipoCancer: diagnosticoMae.isEmpty || diagnosticoMae == 'Nenhum'
            ? null
            : diagnosticoMae,
        conjugeId: paiId,
      ),
      Pessoa(
        id: pacienteId,
        nome: texto('1.1', texto('1.2', 'Paciente')),
        sexo: sexoPaciente,
        parentesco: sexoPaciente == 'F' ? 'filha' : 'filho',
        temCancer: temCancerPaciente,
        tipoCancer: temCancerPaciente ? texto('3.2') : null,
        idadeDiagnostico: temCancerPaciente ? numero('3.3') : null,
        paiId: paiId,
        maeId: maeId,
      ),
    ];

    for (final blocoId in const ['4', '6', '8', '9']) {
      final registros = respostas[blocoId];
      if (registros is! List) continue;

      for (var i = 0; i < registros.length; i++) {
        final registro = Map<String, dynamic>.from(registros[i] as Map);
        final parentesco =
            registro['parentesco']?.toString() ?? 'Outro parente';
        final diagnostico = registro['diagnostico']?.toString().trim() ?? '';
        final genero = registro['genero']?.toString() ?? '';
        final id = '${baseId}_${blocoId}_$i';
        final pessoa = Pessoa(
          id: id,
          nome: registro['nome']?.toString().trim().isNotEmpty == true
              ? registro['nome'].toString()
              : parentesco,
          sexo: _sexoFamiliar(genero, parentesco),
          parentesco: parentesco,
          temCancer: diagnostico.isNotEmpty && diagnostico != 'Nenhum',
          tipoCancer: diagnostico.isEmpty || diagnostico == 'Nenhum'
              ? null
              : diagnostico,
          idadeDiagnostico: registro['idadeDiagnostico'] as int?,
        );

        if (blocoId == '4') {
          if (!parentesco.contains('Materno')) pessoa.paiId = paiId;
          if (!parentesco.contains('Paterno')) pessoa.maeId = maeId;
        } else if (blocoId == '6') {
          if (parentesco.startsWith('Avô')) pessoas[0].paiId = id;
          if (parentesco.startsWith('Avó')) pessoas[0].maeId = id;
        } else if (blocoId == '8') {
          if (parentesco.startsWith('Avô')) pessoas[1].paiId = id;
          if (parentesco.startsWith('Avó')) pessoas[1].maeId = id;
        } else if (parentesco == 'Filho' || parentesco == 'Filha') {
          if (sexoPaciente == 'M') {
            pessoa.paiId = pacienteId;
          } else {
            pessoa.maeId = pacienteId;
          }
        } else if (parentesco == 'Cônjuge') {
          pessoas[2].conjugeId = id;
          pessoa.conjugeId = pacienteId;
        }

        pessoas.add(pessoa);
      }
    }

    await FirestoreService().criarHeredograma(
      Heredograma(
        id: '',
        titulo: 'Caso ${texto('1.2', texto('1.1', 'sem identificação'))}',
        descricao: 'Entrevista de histórico familiar em oncologia pediátrica.',
        pessoas: pessoas,
        dataCriacao: agora,
        pacienteNome: texto('1.1', texto('1.2', 'Paciente')),
        pacienteIdade: _calcularIdade(texto('1.3')),
        pacienteSexo: sexoPaciente,
        entrevistaRespostas: respostas,
      ),
    );
  }

  String _sexoFamiliar(String genero, String parentesco) {
    if (genero == 'Masculino') return 'M';
    if (genero == 'Feminino') return 'F';
    final texto = parentesco.toLowerCase();
    return texto.contains('irmã') ||
            texto.contains('avó') ||
            texto.contains('tia') ||
            texto.contains('prima') ||
            texto.contains('filha')
        ? 'F'
        : 'M';
  }

  int? _calcularIdade(String nascimento) {
    final partes = nascimento.split('/');
    if (partes.length != 3) return null;
    final data = DateTime.tryParse('${partes[2]}-${partes[1]}-${partes[0]}');
    if (data == null) return null;

    final hoje = DateTime.now();
    var idade = hoje.year - data.year;
    if (hoje.month < data.month ||
        (hoje.month == data.month && hoje.day < data.day)) {
      idade--;
    }
    return idade >= 0 ? idade : null;
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
