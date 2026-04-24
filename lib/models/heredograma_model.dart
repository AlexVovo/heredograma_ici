import 'package:cloud_firestore/cloud_firestore.dart';
import 'pessoa_model.dart';

class Heredograma {
  final String id;
  final String titulo;
  final String? descricao;
  final List<Pessoa> pessoas;
  final DateTime dataCriacao;
  final DateTime? dataAtualizacao;
  final String pacienteNome;
  final int? pacienteIdade;
  final String? pacienteSexo;

  Heredograma({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.pessoas,
    required this.dataCriacao,
    this.dataAtualizacao,
    required this.pacienteNome,
    this.pacienteIdade,
    this.pacienteSexo,
  });

  // Converter para JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'pacienteNome': pacienteNome,
      'pacienteIdade': pacienteIdade,
      'pacienteSexo': pacienteSexo,
      'pessoas': pessoas
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
                'conjugeId': p.conjugeId,
              })
          .toList(),
      'dataCriacao': dataCriacao,
      'dataAtualizacao': dataAtualizacao ?? FieldValue.serverTimestamp(),
    };
  }

  // Converter de JSON do Firestore
  factory Heredograma.fromJson(String id, Map<String, dynamic> json) {
    final pessoasList = (json['pessoas'] as List<dynamic>?)
            ?.map((p) => Pessoa(
                  id: p['id'] ?? '',
                  nome: p['nome'] ?? '',
                  sexo: p['sexo'] ?? 'M',
                  parentesco: p['parentesco'] ?? '',
                  temCancer: p['temCancer'] ?? false,
                  portador: p['portador'] ?? false,
                  tipoCancer: p['tipoCancer'],
                  idadeDiagnostico: p['idadeDiagnostico'],
                  paiId: p['paiId'],
                  maeId: p['maeId'],
                ))
            .toList() ??
        [];

    return Heredograma(
      id: id,
      titulo: json['titulo'] ?? 'Sem título',
      descricao: json['descricao'],
      pessoas: pessoasList,
      dataCriacao:
          (json['dataCriacao'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dataAtualizacao: (json['dataAtualizacao'] as Timestamp?)?.toDate(),
      pacienteNome: json['pacienteNome'] ?? '',
      pacienteIdade: json['pacienteIdade'],
      pacienteSexo: json['pacienteSexo'],
    );
  }

  // Copiar com mudanças
  Heredograma copyWith({
    String? titulo,
    String? descricao,
    List<Pessoa>? pessoas,
    String? pacienteNome,
    int? pacienteIdade,
    String? pacienteSexo,
  }) {
    return Heredograma(
      id: id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      pessoas: pessoas ?? this.pessoas,
      dataCriacao: dataCriacao,
      dataAtualizacao: DateTime.now(),
      pacienteNome: pacienteNome ?? this.pacienteNome,
      pacienteIdade: pacienteIdade ?? this.pacienteIdade,
      pacienteSexo: pacienteSexo ?? this.pacienteSexo,
    );
  }
}
