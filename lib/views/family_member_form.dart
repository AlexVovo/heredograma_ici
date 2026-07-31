import 'package:flutter/material.dart';
import 'package:heredograma_ici/widgets/branded_app_bar.dart';
import 'package:uuid/uuid.dart';

import '../models/pessoa_model.dart';

class FamilyMemberForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final List<Pessoa> pessoasExistentes;
  final Pessoa? pessoaInicial;

  const FamilyMemberForm({
    super.key,
    required this.onSave,
    this.pessoasExistentes = const [],
    this.pessoaInicial,
  });

  @override
  State<FamilyMemberForm> createState() => _FamilyMemberFormState();
}

class _FamilyMemberFormState extends State<FamilyMemberForm> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final idadeDiagController = TextEditingController();
  final idadeObitoController = TextEditingController();

  String sexo = 'M';
  String parentesco = 'pai';
  String statusVital = 'Desconhecido';
  String adocao = 'Desconhecido';
  String ladoFamiliar = 'Não aplicável';
  String? paiId;
  String? maeId;
  String? paiAdotivoId;
  String? maeAdotivaId;
  String? conjugeId;
  bool temCancer = false;
  String? tipoCancer;

  final List<String> parentescos = [
    'avo',
    'ava',
    'pai',
    'mae',
    'irmao',
    'irma',
    'tio',
    'tia',
    'filho',
    'filha',
    'primo',
    'prima',
    'sobrinho',
    'sobrinha',
    'outro'
  ];

  final List<String> tiposCancer = [
    'Mama',
    'Pulmão',
    'Próstata',
    'Colorretal',
    'Leucemia',
    'Outro'
  ];

  @override
  void initState() {
    super.initState();
    final pessoa = widget.pessoaInicial;
    if (pessoa == null) return;
    nomeController.text = pessoa.nome;
    idadeDiagController.text = pessoa.idadeDiagnostico?.toString() ?? '';
    idadeObitoController.text = pessoa.idadeObito?.toString() ?? '';
    sexo = pessoa.sexo;
    parentesco = pessoa.parentesco;
    statusVital = pessoa.statusVital;
    adocao = pessoa.adocao;
    ladoFamiliar = pessoa.ladoFamiliar;
    temCancer = pessoa.temCancer;
    tipoCancer = pessoa.tipoCancer;
    paiId = pessoa.paiId;
    maeId = pessoa.maeId;
    paiAdotivoId = pessoa.paiAdotivoId;
    maeAdotivaId = pessoa.maeAdotivaId;
    conjugeId = pessoa.conjugeId;
  }

  @override
  void dispose() {
    nomeController.dispose();
    idadeController.dispose();
    idadeDiagController.dispose();
    idadeObitoController.dispose();
    super.dispose();
  }

  void salvar() {
    if (_formKey.currentState!.validate()) {
      final membro = {
        'id': widget.pessoaInicial?.id ?? const Uuid().v4(),
        'nome': nomeController.text,
        'sexo': sexo,
        'parentesco': parentesco,
        'idade': int.tryParse(idadeController.text),
        'temCancer': temCancer,
        'tipoCancer': tipoCancer,
        'idadeDiagnostico':
            temCancer ? int.tryParse(idadeDiagController.text) : null,
        'statusVital': statusVital,
        'idadeObito': statusVital == 'Falecido'
            ? int.tryParse(idadeObitoController.text)
            : null,
        'adocao': adocao,
        'ladoFamiliar': ladoFamiliar,
        'paiId': paiId,
        'maeId': maeId,
        'paiAdotivoId': paiAdotivoId,
        'maeAdotivaId': maeAdotivaId,
        'conjugeId': conjugeId,
      };

      widget.onSave(membro);
      Navigator.pop(context, membro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandedAppBar(title: 'Adicionar Familiar'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nome
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),

              const SizedBox(height: 12),

              // Parentesco
              DropdownButtonFormField(
                initialValue: parentesco,
                items: parentescos
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => parentesco = v!),
                decoration: const InputDecoration(labelText: 'Parentesco'),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: ladoFamiliar,
                items: const [
                  DropdownMenuItem(value: 'Materno', child: Text('Materno')),
                  DropdownMenuItem(value: 'Paterno', child: Text('Paterno')),
                  DropdownMenuItem(value: 'Ambos', child: Text('Ambos')),
                  DropdownMenuItem(
                    value: 'Não aplicável',
                    child: Text('Não aplicável'),
                  ),
                  DropdownMenuItem(
                    value: 'Desconhecido',
                    child: Text('Desconhecido'),
                  ),
                ],
                onChanged: (v) => setState(() => ladoFamiliar = v!),
                decoration: const InputDecoration(labelText: 'Lado familiar'),
              ),

              const SizedBox(height: 12),

              // Sexo
              DropdownButtonFormField(
                initialValue: sexo,
                items: const [
                  DropdownMenuItem(value: 'M', child: Text('Masculino')),
                  DropdownMenuItem(value: 'F', child: Text('Feminino')),
                ],
                onChanged: (v) => setState(() => sexo = v!),
                decoration: const InputDecoration(labelText: 'Sexo'),
              ),

              const SizedBox(height: 12),

              // Idade
              TextFormField(
                controller: idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Idade'),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: statusVital,
                items: const [
                  DropdownMenuItem(value: 'Vivo', child: Text('Vivo')),
                  DropdownMenuItem(value: 'Falecido', child: Text('Falecido')),
                  DropdownMenuItem(
                    value: 'Desconhecido',
                    child: Text('Desconhecido'),
                  ),
                ],
                onChanged: (v) => setState(() => statusVital = v!),
                decoration: const InputDecoration(labelText: 'Estado vital'),
              ),

              if (statusVital == 'Falecido') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: idadeObitoController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Idade no óbito'),
                ),
              ],

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: adocao,
                items: const [
                  DropdownMenuItem(
                    value: 'Sim, de dentro da família',
                    child: Text('Sim, de dentro da família'),
                  ),
                  DropdownMenuItem(
                    value: 'Sim, de fora da família',
                    child: Text('Sim, de fora da família'),
                  ),
                  DropdownMenuItem(value: 'Não', child: Text('Não')),
                  DropdownMenuItem(
                    value: 'Desconhecido',
                    child: Text('Desconhecido'),
                  ),
                ],
                onChanged: (v) => setState(() => adocao = v!),
                decoration: const InputDecoration(labelText: 'Adotado?'),
              ),

              const SizedBox(height: 12),

              _seletorPessoa(
                label: 'Pai biológico',
                value: paiId,
                onChanged: (value) => setState(() => paiId = value),
              ),
              const SizedBox(height: 12),
              _seletorPessoa(
                label: 'Mãe biológica',
                value: maeId,
                onChanged: (value) => setState(() => maeId = value),
              ),
              const SizedBox(height: 12),
              _seletorPessoa(
                label: 'Cônjuge',
                value: conjugeId,
                onChanged: (value) => setState(() => conjugeId = value),
              ),
              if (adocao.startsWith('Sim')) ...[
                const SizedBox(height: 12),
                _seletorPessoa(
                  label: 'Pai adotivo',
                  value: paiAdotivoId,
                  onChanged: (value) => setState(() => paiAdotivoId = value),
                ),
                const SizedBox(height: 12),
                _seletorPessoa(
                  label: 'Mãe adotiva',
                  value: maeAdotivaId,
                  onChanged: (value) => setState(() => maeAdotivaId = value),
                ),
              ],

              const SizedBox(height: 12),

              // Teve câncer?
              SwitchListTile(
                title: const Text('Teve câncer?'),
                value: temCancer,
                onChanged: (v) => setState(() => temCancer = v),
              ),

              if (temCancer) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField(
                  initialValue: tipoCancer,
                  items: tiposCancer
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => tipoCancer = v),
                  decoration:
                      const InputDecoration(labelText: 'Tipo de câncer'),
                  validator: (v) =>
                      temCancer && v == null ? 'Selecione o tipo' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: idadeDiagController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Idade no diagnóstico'),
                ),
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: salvar,
                child: const Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _seletorPessoa({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String?>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        const DropdownMenuItem<String?>(
          value: null,
          child: Text('Não informado'),
        ),
        for (final pessoa in widget.pessoasExistentes)
          DropdownMenuItem<String?>(
            value: pessoa.id,
            child: Text(pessoa.nome),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
