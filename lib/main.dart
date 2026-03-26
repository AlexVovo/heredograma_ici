import 'package:flutter/material.dart';
import 'package:heredograma_ici/models/pessoa_model.dart';
import 'package:heredograma_ici/views/heredograma_view.dart';
import 'views/family_member_form.dart';
import 'theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/firestore_service.dart';
import 'views/heredogramas_list_view.dart';
import 'views/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('🔥 Firebase inicializado com sucesso');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heredograma App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> familiares = [];

  void adicionarFamiliar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FamilyMemberForm(
          onSave: (membro) {
            setState(() {
              familiares.add(membro);
            });
          },
        ),
      ),
    );
  }

  void removerFamiliar(int index) {
    setState(() {
      familiares.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrevista Familiar'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Botão adicionar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: adicionarFamiliar,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Familiar'),
              ),
            ),

            const SizedBox(height: 16),

            // 🔥 NOVO BOTÃO (HEREDOGRAMA)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (familiares.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Adicione familiares primeiro'),
                      ),
                    );
                    return;
                  }

                  // 🔥 IDENTIFICA OS PAIS/MAES DISPONÍVEIS
                  Map<String, dynamic>? paiCadastrado;
                  Map<String, dynamic>? maeCadastrada;

                  for (var f in familiares) {
                    if (f['parentesco'] == 'pai' && paiCadastrado == null) {
                      paiCadastrado = f;
                    }
                    if (f['parentesco'] == 'mae' && maeCadastrada == null) {
                      maeCadastrada = f;
                    }
                  }

                  // 🔥 CONVERTE Map → Pessoa usando o ID real e vínculos de parentesco
                  List<Pessoa> pessoas = familiares.map((f) {
                    final isFilho = f['parentesco'] == 'filho' ||
                        f['parentesco'] == 'filha';
                    final isIrmao =
                        f['parentesco'] == 'irmao' || f['parentesco'] == 'irma';

                    String? paiId;
                    String? maeId;

                    if (isFilho || isIrmao) {
                      paiId = paiCadastrado != null
                          ? paiCadastrado['id'] as String
                          : null;
                      maeId = maeCadastrada != null
                          ? maeCadastrada['id'] as String
                          : null;
                    }

                    return Pessoa(
                      id: f['id'] ?? DateTime.now().toString(),
                      nome: f['nome'],
                      sexo: f['sexo'],
                      parentesco: f['parentesco'],
                      temCancer: f['temCancer'],
                      paiId: paiId,
                      maeId: maeId,
                    );
                  }).toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HeredogramaView(pessoas: pessoas),
                    ),
                  );
                },
                icon: const Icon(Icons.account_tree),
                label: const Text('Gerar Heredograma'),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await FirestoreService().salvarHeredograma(familiares);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Salvo com sucesso 🚀')),
                    );
                  } catch (e) {
                    print('ERRO FIRESTORE: $e');

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro: $e')),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Salvar no banco'),
              ),
            ),

            const SizedBox(height: 16),

            //const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HeredogramasListView(),
                    ),
                  );
                },
                icon: const Icon(Icons.list),
                label: const Text('Ver heredogramas salvos'),
              ),
            ),

            // Lista
            Expanded(
              child: familiares.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum familiar adicionado',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: familiares.length,
                      itemBuilder: (_, index) {
                        final f = familiares[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  f['sexo'] == 'M' ? Colors.blue : Colors.pink,
                              child: Icon(
                                f['sexo'] == 'M' ? Icons.male : Icons.female,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(f['nome']),
                            subtitle: Text(
                              "${f['parentesco']} • ${f['temCancer'] ? 'Com câncer' : 'Sem câncer'}",
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removerFamiliar(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
