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
  final bool portador; // 👈 novo
  final int? idadeDiagnostico; // 👈 novo
  final String? tipoCancer; // 👈 novo

  String? paiId;
  String? maeId;
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
    this.paiId,
    this.maeId,
    this.conjugeId,
  });
}
