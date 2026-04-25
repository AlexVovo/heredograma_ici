import 'package:flutter/material.dart';
import 'package:heredograma_ici/models/heredograma_model.dart';
import 'package:heredograma_ici/services/firestore_service.dart';
import 'heredograma_view.dart';
import 'heredograma_detail_view.dart';

class HeredogramasListView extends StatefulWidget {
  const HeredogramasListView({super.key});

  @override
  State<HeredogramasListView> createState() => _HeredogramasListViewState();
}

class _HeredogramasListViewState extends State<HeredogramasListView> {
  final _service = FirestoreService();
  final _searchController = TextEditingController();
  String _filtro = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(String id, String titulo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar heredograma?'),
        content: Text('Tem certeza que deseja deletar "$titulo"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _service.deletarHeredograma(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Heredograma deletado')),
              );
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heredogramas Salvos'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _filtro = value);
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nome do paciente...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _filtro.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _filtro = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          // Lista
          Expanded(
            child: StreamBuilder<List<Heredograma>>(
              stream: _filtro.isEmpty
                  ? _service.listarHeredogramas()
                  : _service.buscarPorPaciente(_filtro),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final heredogramas = snapshot.data ?? [];

                if (heredogramas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _filtro.isEmpty
                              ? 'Nenhum heredograma salvo'
                              : 'Nenhum resultado encontrado',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: heredogramas.length,
                  itemBuilder: (context, index) {
                    final h = heredogramas[index];
                    return _buildHeredogramaCard(h);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeredogramaCard(Heredograma heredograma) {
    final dataFormatada = _formatarData(heredograma.dataCriacao);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HeredogramaDetailView(heredograma: heredograma),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título e ações
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          heredograma.titulo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Paciente: ${heredograma.pacienteNome}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.visibility, size: 20),
                            SizedBox(width: 8),
                            Text('Visualizar'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  HeredogramaView(pessoas: heredograma.pessoas),
                            ),
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HeredogramaDetailView(
                                heredograma: heredograma,
                                isEditing: true,
                              ),
                            ),
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Deletar',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        onTap: () {
                          _confirmDelete(heredograma.id, heredograma.titulo);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Info do paciente
              if (heredograma.pacienteIdade != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 8),
                      Text(
                        'Idade: ${heredograma.pacienteIdade} anos',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      if (heredograma.pacienteSexo != null)
                        Row(
                          children: [
                            Icon(
                              heredograma.pacienteSexo == 'M'
                                  ? Icons.male
                                  : Icons.female,
                              size: 16,
                              color: heredograma.pacienteSexo == 'M'
                                  ? Colors.blue
                                  : Colors.pink,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              heredograma.pacienteSexo == 'M'
                                  ? 'Masculino'
                                  : 'Feminino',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              // Quantidade de familiares
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.group, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 8),
                    Text(
                      '${heredograma.pessoas.length} familiares',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              // Data
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 8),
                  Text(
                    dataFormatada,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inDays == 0) {
      if (diferenca.inHours == 0) {
        return 'Hoje ${data.hour}:${data.minute.toString().padLeft(2, '0')}';
      }
      return 'Hoje, ${diferenca.inHours}h atrás';
    } else if (diferenca.inDays == 1) {
      return 'Ontem';
    } else if (diferenca.inDays < 7) {
      return 'Há ${diferenca.inDays} dias';
    } else {
      return '${data.day}/${data.month}/${data.year}';
    }
  }
}
