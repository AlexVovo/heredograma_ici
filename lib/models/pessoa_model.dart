enum Parentesco {
  avo,
  ava,
  pai,
  mae,
  filho,
  filha,
  tio,
  tia,
  irmao,
  irma,
}

class Pessoa {
  String id;
  String nome;
  String sexo;
  bool temCancer;
  String parentesco;
  final bool portador;
  final int? idadeDiagnostico;
  final String? tipoCancer;
  final List<String> condicoesClinicas;
  final String statusVital;
  final int? idadeObito;
  final String adocao;
  final String ladoFamiliar;
  final bool probando;
  final int? geracao;

  String? paiId;
  String? maeId;
  String? paiAdotivoId;
  String? maeAdotivaId;
  String? conjugeId;

  Pessoa({
    required this.id,
    required this.nome,
    required this.sexo,
    required this.parentesco,
    this.temCancer = false,
    this.portador = false,
    this.idadeDiagnostico,
    this.tipoCancer,
    this.condicoesClinicas = const [],
    this.statusVital = 'Desconhecido',
    this.idadeObito,
    this.adocao = 'Desconhecido',
    this.ladoFamiliar = 'Não aplicável',
    this.probando = false,
    this.geracao,
    this.paiId,
    this.maeId,
    this.paiAdotivoId,
    this.maeAdotivaId,
    this.conjugeId,
  });

  bool get falecido => statusVital.toLowerCase() == 'falecido';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'sexo': sexo,
      'parentesco': parentesco,
      'temCancer': temCancer,
      'portador': portador,
      'tipoCancer': tipoCancer,
      'idadeDiagnostico': idadeDiagnostico,
      'condicoesClinicas': condicoesClinicas,
      'statusVital': statusVital,
      'idadeObito': idadeObito,
      'adocao': adocao,
      'ladoFamiliar': ladoFamiliar,
      'probando': probando,
      'geracao': geracao,
      'paiId': paiId,
      'maeId': maeId,
      'paiAdotivoId': paiAdotivoId,
      'maeAdotivaId': maeAdotivaId,
      'conjugeId': conjugeId,
    };
  }

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      sexo: json['sexo']?.toString() ?? 'N',
      parentesco: json['parentesco']?.toString() ?? '',
      temCancer: json['temCancer'] == true,
      portador: json['portador'] == true,
      tipoCancer: json['tipoCancer']?.toString(),
      idadeDiagnostico: _intOrNull(json['idadeDiagnostico']),
      condicoesClinicas: (json['condicoesClinicas'] as List?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      statusVital: json['statusVital']?.toString() ?? 'Desconhecido',
      idadeObito: _intOrNull(json['idadeObito']),
      adocao: json['adocao']?.toString() ?? 'Desconhecido',
      ladoFamiliar: json['ladoFamiliar']?.toString() ?? 'Não aplicável',
      probando: json['probando'] == true,
      geracao: _intOrNull(json['geracao']),
      paiId: json['paiId']?.toString(),
      maeId: json['maeId']?.toString(),
      paiAdotivoId: json['paiAdotivoId']?.toString(),
      maeAdotivaId: json['maeAdotivaId']?.toString(),
      conjugeId: json['conjugeId']?.toString(),
    );
  }

  static int? _intOrNull(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}
