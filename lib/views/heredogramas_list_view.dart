import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../models/pessoa_model.dart';
import 'heredograma_view.dart';

class HeredogramasListView extends StatelessWidget {
  const HeredogramasListView({super.key});

  List<Pessoa> mapToPessoas(List<dynamic> lista) {
    return lista.map((f) {
      return Pessoa(
        id: f['id'],
        nome: f['nome'],
        sexo: f['sexo'],
        parentesco: f['parentesco'],
        temCancer: f['temCancer'],
        paiId: f['paiId'],
        maeId: f['maeId'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heredogramas Salvos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().listarHeredogramas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Nenhum heredograma salvo'),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final familiares = data['familiares'] ?? [];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Heredograma ${index + 1}'),
                  subtitle: Text(
                    'Familiares: ${familiares.length}',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    final pessoas = mapToPessoas(familiares);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HeredogramaView(pessoas: pessoas),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
