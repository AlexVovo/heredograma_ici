import 'package:flutter/material.dart';
import '../models/pessoa_model.dart';
import 'heredograma_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heredograma App'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_tree, size: 80),
              const SizedBox(height: 20),
              const Text('Bem-vindo ao Heredograma', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HeredogramaView(
                        pessoas: [
                          Pessoa(id: '1', nome: 'Pai', sexo: 'M', parentesco: Parentesco.pai.name, temCancer: true),
                          Pessoa(id: '2', nome: 'Mãe', sexo: 'F', parentesco: Parentesco.mae.name),
                          Pessoa(id: '3', nome: 'Filho', sexo: 'M', parentesco: Parentesco.filho.name, paiId: '1', maeId: '2'),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Ver Heredograma'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HeredogramaView(
                        pessoas: [
                          Pessoa(id: '1', nome: 'Pai', sexo: 'M', parentesco: Parentesco.pai.name, temCancer: true),
                          Pessoa(id: '2', nome: 'Mãe', sexo: 'F', parentesco: Parentesco.mae.name),
                          Pessoa(id: '3', nome: 'Filha', sexo: 'F', parentesco: Parentesco.filha.name, paiId: '1', maeId: '2'),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility),
                label: const Text('Ver Heredograma (Teste)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quiz em construção 🚧')));
                },
                icon: const Icon(Icons.quiz),
                label: const Text('Iniciar Quiz'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Editor manual em breve 🚀')));
                },
                icon: const Icon(Icons.edit),
                label: const Text('Criar Heredograma'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
