import 'package:flutter/material.dart';
import 'package:heredograma_ici/views/heredogramas_list_view.dart';
import '../models/pessoa_model.dart';
import 'heredograma_view.dart';
import '../main.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heredograma'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Header
            const Row(
              children: [
                Icon(Icons.account_tree, size: 36),
                SizedBox(width: 10),
                Text(
                  'Bem-vindo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Grid RESPONSIVO 🔥
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;

                  if (constraints.maxWidth > 1000) {
                    crossAxisCount = 4; // desktop grande
                  } else if (constraints.maxWidth > 700) {
                    crossAxisCount = 3; // tablet
                  }

                  return GridView.builder(
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5, // 👈 controla altura
                    ),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return _buildCard(
                            context,
                            icon: Icons.add,
                            title: 'Criar',
                            subtitle: 'Novo heredograma',
                            color: Colors.blue,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyHomePage(),
                                  //pessoas: [
                                  //  Pessoa(
                                  //  id: '1',
                                  //nome: 'Pai',
                                  //sexo: 'M',
                                  //parentesco: Parentesco.pai.name,
                                  //),
                                  //],
                                  //),
                                ),
                              );
                            },
                          );

                        case 1:
                          return _buildCard(
                            context,
                            icon: Icons.list,
                            title: 'Listar',
                            subtitle: 'Heredogramas salvos',
                            color: Colors.green,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HeredogramasListView(),
                                ),
                              );
                            },
                          );

                        case 2:
                          return _buildCard(
                            context,
                            icon: Icons.visibility,
                            title: 'Visualizar',
                            subtitle: 'Herança genética',
                            color: Colors.orange,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HeredogramaView(
                                    pessoas: [
                                      // 👴 Avô
                                      Pessoa(
                                        id: '1',
                                        nome: 'Avô',
                                        sexo: 'M',
                                        parentesco: Parentesco.pai.name,
                                        temCancer: false,
                                      ),

                                      // 👵 Avó (caso inicial)
                                      Pessoa(
                                        id: '2',
                                        nome: 'Avó',
                                        sexo: 'F',
                                        parentesco: Parentesco.mae.name,
                                        temCancer: true,
                                      ),

                                      // 👨 Pai (filho da avó - possível portador)
                                      Pessoa(
                                        id: '3',
                                        nome: 'Pai',
                                        sexo: 'M',
                                        parentesco: Parentesco.pai.name,
                                        paiId: '1',
                                        maeId: '2',
                                        temCancer: false,
                                      ),

                                      // 👩 Tia (irmã do pai - afetada)
                                      Pessoa(
                                        id: '4',
                                        nome: 'Tia',
                                        sexo: 'F',
                                        parentesco: Parentesco.filha.name,
                                        paiId: '1',
                                        maeId: '2',
                                        temCancer: true,
                                      ),

                                      // 👩 Mãe (fora da linhagem genética)
                                      Pessoa(
                                        id: '5',
                                        nome: 'Mãe',
                                        sexo: 'F',
                                        parentesco: Parentesco.mae.name,
                                        temCancer: false,
                                      ),

                                      // 👦 Filho (não afetado)
                                      Pessoa(
                                        id: '6',
                                        nome: 'Filho',
                                        sexo: 'M',
                                        parentesco: Parentesco.filho.name,
                                        paiId: '3',
                                        maeId: '5',
                                        temCancer: false,
                                      ),

                                      // 👧 Filha (afetada - herança)
                                      Pessoa(
                                        id: '7',
                                        nome: 'Filha',
                                        sexo: 'F',
                                        parentesco: Parentesco.filha.name,
                                        paiId: '3',
                                        maeId: '5',
                                        temCancer: true,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        default:
                          return _buildCard(
                            context,
                            icon: Icons.quiz,
                            title: 'Quiz',
                            subtitle: 'Em breve',
                            color: Colors.purple,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Em construção 🚧'),
                                ),
                              );
                            },
                          );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.all(12), // 👈 menor padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color), // 👈 menor ícone
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14, // 👈 menor texto
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
