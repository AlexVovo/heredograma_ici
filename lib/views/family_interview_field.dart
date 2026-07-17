import 'package:flutter/material.dart';

import '../data/historico_familiar_questionario.dart';

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
  static const _relacoes = [
    'Casados',
    'Divorciados',
    'Viúvo(a)',
    'Nenhuma',
    'Desconhecido',
  ];
  static const _adocao = [
    'Sim, de dentro da família',
    'Sim, de fora da família',
    'Não',
    'Desconhecido',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < familiares.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Icon(
                switch (familiares[i]['genero']) {
                  'Masculino' => Icons.male,
                  'Feminino' => Icons.female,
                  'Intersexo' => Icons.transgender,
                  _ => Icons.person_outline,
                },
              ),
              title: Text(
                familiares[i]['nome']?.toString().trim().isNotEmpty == true
                    ? familiares[i]['nome'].toString()
                    : familiares[i]['parentesco'].toString(),
              ),
              subtitle: Text(
                '${familiares[i]['parentesco']}${_diagnostico(familiares[i])}',
              ),
              trailing: Wrap(
                spacing: 2,
                children: [
                  IconButton(
                    tooltip: 'Editar',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _editar(context, i),
                  ),
                  IconButton(
                    tooltip: 'Remover',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _remover(context, i),
                  ),
                ],
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

  Future<void> _editar(BuildContext context, int index) async {
    final familiar = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _FamiliarDialog(
        parentescos: parentescos,
        familiar: familiares[index],
      ),
    );
    if (familiar == null) return;
    final atualizados = List<Map<String, dynamic>>.from(familiares);
    atualizados[index] = familiar;
    onChanged(atualizados);
  }

  Future<void> _remover(BuildContext context, int index) async {
    final remover = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover familiar?'),
        content: const Text('Essa ação remove os dados deste familiar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (remover != true) return;
    final atualizados = List<Map<String, dynamic>>.from(familiares)
      ..removeAt(index);
    onChanged(atualizados);
  }
}

class _FamiliarDialog extends StatefulWidget {
  final List<String> parentescos;
  final Map<String, dynamic>? familiar;

  const _FamiliarDialog({required this.parentescos, this.familiar});

  @override
  State<_FamiliarDialog> createState() => _FamiliarDialogState();
}

class _FamiliarDialogState extends State<_FamiliarDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _genitores = TextEditingController();
  final _diagnostico = TextEditingController();
  final _nascimento = TextEditingController();
  final _conjuge = TextEditingController();
  final _relacao = TextEditingController();
  final _idadeDiagnostico = TextEditingController();
  final _idadeAtual = TextEditingController();
  final _idadeObito = TextEditingController();
  final _causaObito = TextEditingController();
  final _observacoes = TextEditingController();
  final _quantidadeFilhos = TextEditingController();
  String? _parentesco;
  String _genero = 'Não informado';
  String _testeGenetico = 'Desconhecido';
  String _statusVital = 'Desconhecido';
  String _adotado = 'Desconhecido';

  @override
  void initState() {
    super.initState();
    final familiar = widget.familiar;
    if (familiar == null) return;
    _parentesco = familiar['parentesco']?.toString();
    _genero = familiar['genero']?.toString() ?? _genero;
    _testeGenetico = familiar['testeGenetico']?.toString() ?? _testeGenetico;
    _statusVital = familiar['statusVital']?.toString() ?? _statusVital;
    _adotado = familiar['adotado']?.toString() ?? _adotado;
    _preencher(_nome, familiar['nome']);
    _preencher(_genitores, familiar['genitores']);
    _preencher(_diagnostico, familiar['diagnostico']);
    _preencher(_nascimento, familiar['nascimento']);
    _preencher(_conjuge, familiar['conjuge']);
    _preencher(_relacao, familiar['relacao']);
    _preencher(_idadeDiagnostico, familiar['idadeDiagnostico']);
    _preencher(_idadeAtual, familiar['idadeAtual']);
    _preencher(_idadeObito, familiar['idadeObito']);
    _preencher(_causaObito, familiar['causaObito']);
    _preencher(_observacoes, familiar['observacoes']);
    _preencher(_quantidadeFilhos, familiar['quantidadeFilhos']);
  }

  void _preencher(TextEditingController controller, dynamic valor) {
    if (valor != null) controller.text = valor.toString();
  }

  @override
  void dispose() {
    for (final controller in [
      _nome,
      _genitores,
      _diagnostico,
      _nascimento,
      _conjuge,
      _relacao,
      _idadeDiagnostico,
      _idadeAtual,
      _idadeObito,
      _causaObito,
      _observacoes,
      _quantidadeFilhos,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.familiar == null ? 'Adicionar familiar' : 'Editar familiar'),
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
                _campo(
                  _genitores,
                  'Nome dos genitores',
                  hint: 'Quando aplicável',
                ),
                _campo(_nome, 'Nome completo ou iniciais'),
                DropdownButtonFormField<String>(
                  initialValue: _genero,
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  items: _opcoes(FamilyInterviewField._generos),
                  onChanged: (value) => setState(() => _genero = value!),
                ),
                _campoComSugestoes(
                  _diagnostico,
                  'Diagnóstico clínico/câncer',
                  opcoesDiagnosticos,
                ),
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
                  items: _opcoes(FamilyInterviewField._adocao),
                  onChanged: (value) => setState(() => _adotado = value!),
                ),
                _campo(_conjuge, 'Nome do(a) cônjuge'),
                _campoComSugestoes(
                  _relacao,
                  'Tipo de relação',
                  FamilyInterviewField._relacoes,
                ),
                _campo(
                  _quantidadeFilhos,
                  'Quantidade de filhos',
                  numero: true,
                ),
                _campo(
                  _idadeDiagnostico,
                  'Idade no diagnóstico',
                  numero: true,
                ),
                _campo(_idadeAtual, 'Idade atual', numero: true),
                _campo(_idadeObito, 'Idade do óbito', numero: true),
                _campoComSugestoes(
                  _causaObito,
                  'Causa da morte',
                  opcoesCausaObito,
                ),
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
        FilledButton(
          onPressed: _salvar,
          child: Text(widget.familiar == null ? 'Adicionar' : 'Salvar'),
        ),
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

  Widget _campoComSugestoes(
    TextEditingController controller,
    String label,
    List<String> opcoes,
  ) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (value) {
        final busca = value.text.toLowerCase().trim();
        return opcoes.where(
          (opcao) => busca.isEmpty || opcao.toLowerCase().contains(busca),
        );
      },
      onSelected: (value) => controller.text = value,
      fieldViewBuilder: (context, fieldController, focusNode, onSubmitted) {
        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          onChanged: (value) => controller.text = value,
          decoration: InputDecoration(labelText: label),
        );
      },
    );
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, {
      'parentesco': _parentesco,
      'genitores': _genitores.text.trim(),
      'nome': _nome.text.trim(),
      'genero': _genero,
      'diagnostico': _diagnostico.text.trim(),
      'testeGenetico': _testeGenetico,
      'nascimento': _nascimento.text.trim(),
      'statusVital': _statusVital,
      'adotado': _adotado,
      'conjuge': _conjuge.text.trim(),
      'relacao': _relacao.text.trim(),
      'quantidadeFilhos': int.tryParse(_quantidadeFilhos.text),
      'idadeDiagnostico': int.tryParse(_idadeDiagnostico.text),
      'idadeAtual': int.tryParse(_idadeAtual.text),
      'idadeObito': int.tryParse(_idadeObito.text),
      'causaObito': _causaObito.text.trim(),
      'observacoes': _observacoes.text.trim(),
    });
  }
}

class TumorInterviewField extends StatelessWidget {
  final List<Map<String, dynamic>> tumores;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  const TumorInterviewField({
    super.key,
    required this.tumores,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < tumores.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.medical_information_outlined),
              title: Text(tumores[i]['tipo']?.toString() ?? 'Tumor'),
              subtitle: Text([
                tumores[i]['ordem'],
                tumores[i]['local'],
                if (tumores[i]['idadeDiagnostico'] != null)
                  '${tumores[i]['idadeDiagnostico']} anos',
              ]
                  .where((item) => item != null && item.toString().isNotEmpty)
                  .join(' • ')),
              trailing: IconButton(
                tooltip: 'Remover',
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  final atualizados = List<Map<String, dynamic>>.from(tumores)
                    ..removeAt(i);
                  onChanged(atualizados);
                },
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _adicionar(context),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar tumor'),
          ),
        ),
      ],
    );
  }

  Future<void> _adicionar(BuildContext context) async {
    final tumor = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const _TumorDialog(),
    );
    if (tumor != null) onChanged([...tumores, tumor]);
  }
}

class _TumorDialog extends StatefulWidget {
  const _TumorDialog();

  @override
  State<_TumorDialog> createState() => _TumorDialogState();
}

class _TumorDialogState extends State<_TumorDialog> {
  static const _ordens = ['1º', '2º', '3º', 'Metástase', 'Sem registros'];
  static const _locais = [
    'Ossos',
    'Pulmão',
    'Fígado',
    'Cérebro',
    'Linfonodos',
    'Medula óssea',
    'Rim',
    'Pele',
    'Sem metástase',
    'Indefinido',
  ];

  final _formKey = GlobalKey<FormState>();
  final _tipo = TextEditingController();
  final _local = TextEditingController();
  final _idade = TextEditingController();
  final _observacoes = TextEditingController();
  String _ordem = '1º';

  @override
  void dispose() {
    _tipo.dispose();
    _local.dispose();
    _idade.dispose();
    _observacoes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar tumor'),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _ordem,
                  decoration: const InputDecoration(labelText: 'Tumor'),
                  items: _ordens
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) => _ordem = value!,
                ),
                _autocomplete(_tipo, 'Tipo *', opcoesDiagnosticos),
                _autocomplete(_local, 'Local', _locais),
                TextFormField(
                  controller: _idade,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Idade no diagnóstico',
                  ),
                ),
                TextFormField(
                  controller: _observacoes,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Observações'),
                ),
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

  Widget _autocomplete(
    TextEditingController destino,
    String label,
    List<String> opcoes,
  ) {
    return Autocomplete<String>(
      optionsBuilder: (value) {
        final busca = value.text.toLowerCase().trim();
        return opcoes.where(
          (opcao) => busca.isEmpty || opcao.toLowerCase().contains(busca),
        );
      },
      onSelected: (value) => destino.text = value,
      fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          onChanged: (value) => destino.text = value,
          decoration: InputDecoration(labelText: label),
          validator: label.endsWith('*')
              ? (value) => value == null || value.trim().isEmpty
                  ? 'Informe o tipo do tumor'
                  : null
              : null,
        );
      },
    );
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, {
      'ordem': _ordem,
      'tipo': _tipo.text.trim(),
      'local': _local.text.trim(),
      'idadeDiagnostico': int.tryParse(_idade.text),
      'observacoes': _observacoes.text.trim(),
    });
  }
}
