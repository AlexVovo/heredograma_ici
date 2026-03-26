import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> listarHeredogramas() {
    return FirebaseFirestore.instance
        .collection('heredogramas')
        .orderBy('dataCriacao', descending: true)
        .snapshots();
  }

  Future<void> salvarHeredograma(List<Map<String, dynamic>> familiares) async {
    await _db.collection('heredogramas').add({
      'dataCriacao': DateTime.now(),
      'familiares': familiares,
    });
  }
}
