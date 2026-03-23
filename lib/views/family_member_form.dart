import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FamilyMemberForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const FamilyMemberForm({super.key, required this.onSave});

  @override
  State<FamilyMemberForm> createState() => _FamilyMemberFormState();
}

class _FamilyMemberFormState extends State<FamilyMemberForm> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final idadeDiagController = TextEditingController();

  String sexo = 'M';
  String parentesco = 'Pai';
  bool temCancer = false;
  String? tipoCancer;

  final List<String> parentescos = [
    'Pai',
    'Mãe',
    'Irmão',
    'Irmã',
    'Avô',
    'Avó',
    'Tio',
    'Tia',
    'Filho',
    'Filha'
  ];

  final List<String> tiposCancer = [
    'Mama',
    'Pulmão',
    'Próstata',
    'Colorretal',
    'Leucemia',
    'Outro'
  ];

  void salvar() {
    if (_formKey.currentState!.validate()) {
      final membro = {
        'id': const Uuid().v4(),
        'nome': nomeController.text,
        'sexo': sexo,
        'parentesco': parentesco,
        'idade': int.tryParse(idadeController.text),
        'temCancer': temCancer,
        'tipoCancer': tipoCancer,
        'idadeDiagnostico': temCancer
            ? int.tryParse(idadeDiagController.text)
            : null,
      };

      widget.onSave(membro);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Familiar'),
      ),
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
                value: parentesco,
                items: parentescos
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => parentesco = v!),
                decoration: const InputDecoration(labelText: 'Parentesco'),
              ),

              const SizedBox(height: 12),

              // Sexo
              DropdownButtonFormField(
                value: sexo,
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

              // Teve câncer?
              SwitchListTile(
                title: const Text('Teve câncer?'),
                value: temCancer,
                onChanged: (v) => setState(() => temCancer = v),
              ),

              if (temCancer) ...[
                const SizedBox(height: 12),

                DropdownButtonFormField(
                  value: tipoCancer,
                  items: tiposCancer
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
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
                  decoration: const InputDecoration(
                      labelText: 'Idade no diagnóstico'),
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
}