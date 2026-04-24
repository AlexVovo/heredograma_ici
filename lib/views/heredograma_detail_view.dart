import 'package:flutter/material.dart';
import 'package:heredograma_ici/models/heredograma_model.dart';
import 'package:heredograma_ici/services/firestore_service.dart';
import 'heredograma_view.dart';

class HeredogramaDetailView extends StatefulWidget {
  final Heredograma heredograma;
  final bool isEditing;

  const HeredogramaDetailView({
    super.key,
    required this.heredograma,
    this.isEditing = false,
  });

  @override
  State<HeredogramaDetailView> createState() => _HeredogramaDetailViewState();
}

class _HeredogramaDetailViewState extends State<HeredogramaDetailView> {
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late TextEditingController _pacienteNomeController;
  late TextEditingController _pacienteIdadeController;
  late bool _isEditing;
  late String _pacienteSexo;
  final _service = FirestoreService();

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditing;
    _tituloController = TextEditingController(text: widget.heredograma.titulo);
    _descricaoController =
        TextEditingController(text: widget.heredograma.descricao ?? '');
    _pacienteNomeController =
        TextEditingController(text: widget.heredograma.pacienteNome);
    _pacienteIdadeController = TextEditingController(
        text: widget.heredograma.pacienteIdade?.toString() ?? '');
    _pacienteSexo = widget.heredograma.pacienteSexo ?? 'M';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _pacienteNomeController.dispose();
    _pacienteIdadeController.dispose();
    super.dispose();
  }

  void _salvarAlteracoes() async {
    try {
      final heredogramaAtualizado = widget.heredograma.copyWith(
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        pacienteNome: _pacienteNomeController.text,
        pacienteIdade: int.tryParse(_pacienteIdadeController.text),
        pacienteSexo: _pacienteSexo,
      );

      await _service.atualizarHeredograma(
        widget.heredograma.id,
        heredogramaAtualizado,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Heredograma atualizado com sucesso')),
      );

      setState(() => _isEditing = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Heredograma'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _isEditing = false),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção do Heredograma
            _buildSection(
              title: 'Informações do Heredograma',
              children: [
                _buildTextFieldOrText(
                  label: 'Título',
                  controller: _tituloController,
                  enabled: _isEditing,
                ),
                const SizedBox(height: 16),
                _buildTextFieldOrText(
                  label: 'Descrição',
                  controller: _descricaoController,
                  enabled: _isEditing,
                  maxLines: 3,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Seção do Paciente
            _buildSection(
              title: 'Informações do Paciente',
              children: [
                _buildTextFieldOrText(
                  label: 'Nome',
                  controller: _pacienteNomeController,
                  enabled: _isEditing,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextFieldOrText(
                        label: 'Idade',
                        controller: _pacienteIdadeController,
                        enabled: _isEditing,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _isEditing
                          ? DropdownButtonFormField<String>(
                              value: _pacienteSexo,
                              items: const [
                                DropdownMenuItem(
                                  value: 'M',
                                  child: Text('Masculino'),
                                ),
                                DropdownMenuItem(
                                  value: 'F',
                                  child: Text('Feminino'),
                                ),
                              ],
                              onChanged: (value) =>
                                  setState(() => _pacienteSexo = value!),
                              decoration:
                                  const InputDecoration(labelText: 'Sexo'),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Sexo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _pacienteSexo == 'M'
                                      ? 'Masculino'
                                      : 'Feminino',
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Seção de Familiares
            _buildSection(
              title: 'Familiares (${widget.heredograma.pessoas.length})',
              children: [
                if (widget.heredograma.pessoas.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text('Nenhum familiar adicionado'),
                    ),
                  )
                else
                  Column(
                    children: List.generate(
                      widget.heredograma.pessoas.length,
                      (index) {
                        final pessoa = widget.heredograma.pessoas[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: pessoa.sexo == 'M'
                                    ? Colors.blue
                                    : Colors.pink,
                                child: Icon(
                                  pessoa.sexo == 'M'
                                      ? Icons.male
                                      : Icons.female,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pessoa.nome,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      pessoa.parentesco,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (pessoa.temCancer)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red[100],
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'Com câncer',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.red[900],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HeredogramaView(
                            pessoas: widget.heredograma.pessoas,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('Visualizar'),
                  ),
                ),
                const SizedBox(width: 12),
                if (_isEditing)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _salvarAlteracoes,
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldOrText({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    if (enabled) {
      return TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(controller.text.isEmpty ? '-' : controller.text),
      ],
    );
  }
}
