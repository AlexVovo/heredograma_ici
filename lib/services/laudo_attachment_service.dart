import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class LaudoAttachmentService {
  static const maxBytes = 700 * 1024;
  static const extensoesPermitidas = ['pdf', 'jpg', 'jpeg', 'png'];

  final FirebaseFirestore _firestore;

  LaudoAttachmentService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> selecionarEEnviar() async {
    final resultado = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensoesPermitidas,
      allowMultiple: false,
      withData: true,
    );
    if (resultado == null) return null;

    final arquivo = resultado.files.single;
    final bytes = arquivo.bytes;
    if (bytes == null) {
      throw const LaudoAttachmentException(
        'Não foi possível ler o arquivo selecionado.',
      );
    }
    if (arquivo.size > maxBytes) {
      throw const LaudoAttachmentException(
        'O arquivo excede o limite de 700 KB do protótipo gratuito.',
      );
    }

    final extensao = arquivo.extension?.toLowerCase();
    if (extensao == null || !extensoesPermitidas.contains(extensao)) {
      throw const LaudoAttachmentException(
        'Selecione um arquivo PDF, JPG ou PNG.',
      );
    }

    final id = const Uuid().v4();
    final contentType = _contentType(extensao);
    await _firestore.collection('prototipo_laudos').doc(id).set({
      'nome': arquivo.name,
      'tamanho': arquivo.size,
      'contentType': contentType,
      'dados': Blob(bytes),
      'enviadoEm': FieldValue.serverTimestamp(),
      'ambiente': 'prototipo',
      'dadosPermitidos': 'ficticios',
    });

    return {
      'id': id,
      'nome': arquivo.name,
      'tamanho': arquivo.size,
      'contentType': contentType,
      'firestoreDocId': id,
      'enviadoEm': DateTime.now().toUtc().toIso8601String(),
      'prototipo': true,
    };
  }

  Future<void> excluir(Map<String, dynamic> anexo) async {
    final id = anexo['firestoreDocId']?.toString();
    if (id == null || id.isEmpty) return;
    await _firestore.collection('prototipo_laudos').doc(id).delete();
  }

  Future<void> abrir(Map<String, dynamic> anexo) async {
    final id = anexo['firestoreDocId']?.toString();
    if (id == null || id.isEmpty) {
      throw const LaudoAttachmentException('Referência do anexo inválida.');
    }
    final snapshot =
        await _firestore.collection('prototipo_laudos').doc(id).get();
    final dados = snapshot.data()?['dados'];
    if (dados is! Blob) {
      throw const LaudoAttachmentException('Arquivo não encontrado.');
    }
    await FilePicker.saveFile(
      dialogTitle: 'Salvar laudo fictício',
      fileName: anexo['nome']?.toString() ?? 'laudo.pdf',
      bytes: dados.bytes,
    );
  }

  String _contentType(String extensao) {
    return switch (extensao) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      _ => 'image/jpeg',
    };
  }
}

class LaudoAttachmentException implements Exception {
  final String message;

  const LaudoAttachmentException(this.message);

  @override
  String toString() => message;
}
