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

  String? paiId;
  String? maeId;
  String? conjugeId;

  Pessoa({
    required this.id,
    required this.nome,
    required this.sexo,
    this.temCancer = false,
    required this.parentesco,
    this.paiId,
    this.maeId,
    this.conjugeId,
  });
}