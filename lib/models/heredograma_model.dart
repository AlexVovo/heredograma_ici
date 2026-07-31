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
  final Map<String, dynamic> entrevistaRespostas;

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
    this.entrevistaRespostas = const {},
  });

  // Converter para JSON para Firestore
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'pacienteNome': pacienteNome,
      'pacienteIdade': pacienteIdade,
      'pacienteSexo': pacienteSexo,
      'schemaVersion': 2,
      'entrevistaRespostas': entrevistaRespostas,
      'pessoas': pessoas.map((p) => p.toJson()).toList(),
      'dataCriacao': dataCriacao,
      'dataAtualizacao': dataAtualizacao ?? FieldValue.serverTimestamp(),
    };
  }

  // Converter de JSON do Firestore
  factory Heredograma.fromJson(String id, Map<String, dynamic> json) {
    final pessoasList = (json['pessoas'] as List<dynamic>?)
            ?.whereType<Map>()
            .map((p) => Pessoa.fromJson(Map<String, dynamic>.from(p)))
            .toList() ??
        [];

    return Heredograma(
      id: id,
      titulo: json['titulo'] ?? 'Sem título',
      descricao: json['descricao'],
      pessoas: pessoasList,
      dataCriacao: _parseTimestamp(json['dataCriacao']),
      dataAtualizacao: _parseTimestamp(json['dataAtualizacao']),
      pacienteNome: json['pacienteNome'] ?? '',
      pacienteIdade: json['pacienteIdade'],
      pacienteSexo: json['pacienteSexo'],
      entrevistaRespostas: Map<String, dynamic>.from(
        json['entrevistaRespostas'] as Map? ?? const {},
      ),
    );
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  // Copiar com mudanças
  Heredograma copyWith({
    String? titulo,
    String? descricao,
    List<Pessoa>? pessoas,
    String? pacienteNome,
    int? pacienteIdade,
    String? pacienteSexo,
    Map<String, dynamic>? entrevistaRespostas,
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
      entrevistaRespostas: entrevistaRespostas ?? this.entrevistaRespostas,
    );
  }
}
