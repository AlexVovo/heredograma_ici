import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heredograma_ici/models/heredograma_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'heredogramas';

  // CREATE - Salvar novo heredograma
  Future<String> criarHeredograma(Heredograma heredograma) async {
    try {
      final docRef =
          await _db.collection(_collection).add(heredograma.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao criar heredograma: $e');
    }
  }

  // READ - Obter um heredograma por ID
  Future<Heredograma?> obterHeredograma(String id) async {
    try {
      final doc = await _db.collection(_collection).doc(id).get();
      if (doc.exists) {
        return Heredograma.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao obter heredograma: $e');
    }
  }

  // READ - Listar todos os heredogramas (Stream)
  Stream<List<Heredograma>> listarHeredogramas() {
    return _db
        .collection(_collection)
        .orderBy('dataCriacao', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Heredograma.fromJson(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // UPDATE - Atualizar heredograma
  Future<void> atualizarHeredograma(String id, Heredograma heredograma) async {
    try {
      await _db.collection(_collection).doc(id).update({
        'titulo': heredograma.titulo,
        'descricao': heredograma.descricao,
        'pacienteNome': heredograma.pacienteNome,
        'pacienteIdade': heredograma.pacienteIdade,
        'pacienteSexo': heredograma.pacienteSexo,
        'pessoas': heredograma.pessoas
            .map((p) => {
                  'id': p.id,
                  'nome': p.nome,
                  'sexo': p.sexo,
                  'parentesco': p.parentesco,
                  'temCancer': p.temCancer,
                  'portador': p.portador,
                  'tipoCancer': p.tipoCancer,
                  'idadeDiagnostico': p.idadeDiagnostico,
                  'paiId': p.paiId,
                  'maeId': p.maeId,
                })
            .toList(),
        'dataAtualizacao': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao atualizar heredograma: $e');
    }
  }

  // DELETE - Deletar heredograma
  Future<void> deletarHeredograma(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar heredograma: $e');
    }
  }

  // SEARCH - Buscar heredogramas por nome do paciente
  Stream<List<Heredograma>> buscarPorPaciente(String nome) {
    return _db
        .collection(_collection)
        .where('pacienteNome',
            isGreaterThanOrEqualTo: nome, isLessThan: nome + 'z')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Heredograma.fromJson(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
