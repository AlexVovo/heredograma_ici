import 'package:flutter/material.dart';

class FamilyInterviewField extends StatelessWidget {
  final List<Map<String, dynamic>> familiares;
  final List<String> parentescos;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  const FamilyInterviewField({
    super.key,
    required this.familiares,
    required this.parentescos,
    required this.onChanged,
  });

  static const _generos = [
    'Masculino',
    'Feminino',
    'Intersexo',
    'Não informado',
  ];
  static const _simNaoDesconhecido = ['Sim', 'Não', 'Desconhecido'];
  static const _statusVital = ['Vivo', 'Falecido', 'Desconhecido'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < familiares.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Icon(
                familiares[i]['genero'] == 'Masculino'
                    ? Icons.male
                    : Icons.female,
              ),
              title: Text(
                familiares[i]['nome']?.toString().trim().isNotEmpty == true
                    ? familiares[i]['nome'].toString()
                    : familiares[i]['parentesco'].toString(),
              ),
              subtitle: Text(
                '${familiares[i]['parentesco']}${_diagnostico(familiares[i])}',
              ),
              trailing: IconButton(
                tooltip: 'Remover',
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  final atualizados =
                      List<Map<String, dynamic>>.from(familiares)..removeAt(i);
                  onChanged(atualizados);
                },
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _adicionar(context),
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Adicionar familiar'),
          ),
        ),
      ],
    );
  }

  static String _diagnostico(Map<String, dynamic> familiar) {
    final diagnostico = familiar['diagnostico']?.toString() ?? '';
    return diagnostico.isEmpty || diagnostico == 'Nenhum'
        ? ''
        : ' • $diagnostico';
  }

  Future<void> _adicionar(BuildContext context) async {
    final familiar = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _FamiliarDialog(parentescos: parentescos),
    );
    if (familiar == null) return;
    onChanged([...familiares, familiar]);
  }
}

class _FamiliarDialog extends StatefulWidget {
  final List<String> parentescos;

  const _FamiliarDialog({required this.parentescos});

  @override
  State<_FamiliarDialog> createState() => _FamiliarDialogState();
}

class _FamiliarDialogState extends State<_FamiliarDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _diagnostico = TextEditingController();
  final _nascimento = TextEditingController();
  final _conjuge = TextEditingController();
  final _relacao = TextEditingController();
  final _idadeDiagnostico = TextEditingController();
  final _idadeAtual = TextEditingController();
  final _idadeObito = TextEditingController();
  final _causaObito = TextEditingController();
  final _observacoes = TextEditingController();
  String? _parentesco;
  String _genero = 'Não informado';
  String _testeGenetico = 'Desconhecido';
  String _statusVital = 'Desconhecido';
  String _adotado = 'Desconhecido';

  @override
  void dispose() {
    for (final controller in [
      _nome,
      _diagnostico,
      _nascimento,
      _conjuge,
      _relacao,
      _idadeDiagnostico,
      _idadeAtual,
      _idadeObito,
      _causaObito,
      _observacoes,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar familiar'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _parentesco,
                  decoration: const InputDecoration(labelText: 'Parentesco *'),
                  items: _opcoes(widget.parentescos),
                  onChanged: (value) => setState(() => _parentesco = value),
                  validator: (value) =>
                      value == null ? 'Selecione o parentesco' : null,
                ),
                _campo(_nome, 'Nome completo ou iniciais'),
                DropdownButtonFormField<String>(
                  initialValue: _genero,
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  items: _opcoes(FamilyInterviewField._generos),
                  onChanged: (value) => setState(() => _genero = value!),
                ),
                _campo(_diagnostico, 'Diagnóstico clínico/câncer'),
                DropdownButtonFormField<String>(
                  initialValue: _testeGenetico,
                  decoration:
                      const InputDecoration(labelText: 'Fez teste genético?'),
                  items: _opcoes(FamilyInterviewField._simNaoDesconhecido),
                  onChanged: (value) => setState(() => _testeGenetico = value!),
                ),
                _campo(_nascimento, 'Data de nascimento', hint: 'DD/MM/AAAA'),
                DropdownButtonFormField<String>(
                  initialValue: _statusVital,
                  decoration: const InputDecoration(labelText: 'Estado vital'),
                  items: _opcoes(FamilyInterviewField._statusVital),
                  onChanged: (value) => setState(() => _statusVital = value!),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _adotado,
                  decoration: const InputDecoration(labelText: 'Adotado?'),
                  items: _opcoes(FamilyInterviewField._simNaoDesconhecido),
                  onChanged: (value) => setState(() => _adotado = value!),
                ),
                _campo(_conjuge, 'Nome do(a) cônjuge'),
                _campo(_relacao, 'Tipo de relação'),
                _campo(
                  _idadeDiagnostico,
                  'Idade no diagnóstico',
                  numero: true,
                ),
                _campo(_idadeAtual, 'Idade atual', numero: true),
                _campo(_idadeObito, 'Idade do óbito', numero: true),
                _campo(_causaObito, 'Causa da morte'),
                _campo(_observacoes, 'Comentários e observações', linhas: 3),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _salvar, child: const Text('Adicionar')),
      ],
    );
  }

  List<DropdownMenuItem<String>> _opcoes(List<String> itens) => itens
      .map((item) => DropdownMenuItem(value: item, child: Text(item)))
      .toList();

  Widget _campo(
    TextEditingController controller,
    String label, {
    String? hint,
    bool numero = false,
    int linhas = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: numero ? TextInputType.number : TextInputType.text,
      minLines: linhas,
      maxLines: linhas,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, {
      'parentesco': _parentesco,
      'nome': _nome.text.trim(),
      'genero': _genero,
      'diagnostico': _diagnostico.text.trim(),
      'testeGenetico': _testeGenetico,
      'nascimento': _nascimento.text.trim(),
      'statusVital': _statusVital,
      'adotado': _adotado,
      'conjuge': _conjuge.text.trim(),
      'relacao': _relacao.text.trim(),
      'idadeDiagnostico': int.tryParse(_idadeDiagnostico.text),
      'idadeAtual': int.tryParse(_idadeAtual.text),
      'idadeObito': int.tryParse(_idadeObito.text),
      'causaObito': _causaObito.text.trim(),
      'observacoes': _observacoes.text.trim(),
    });
  }
}
