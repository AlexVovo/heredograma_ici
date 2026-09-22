class DiagnosticoFamiliar {
  final bool temCancer;
  final String? tipoCancer;
  final List<String> condicoesClinicas;

  const DiagnosticoFamiliar({
    required this.temCancer,
    this.tipoCancer,
    this.condicoesClinicas = const [],
  });

  factory DiagnosticoFamiliar.fromResposta({
    required String categoria,
    String detalhe = '',
  }) {
    final categoriaLimpa = categoria.trim();
    final detalheLimpo = detalhe.trim();

    if (categoriaLimpa == 'Câncer') {
      return DiagnosticoFamiliar(
        temCancer: true,
        tipoCancer: detalheLimpo.isEmpty ? null : detalheLimpo,
      );
    }

    if (categoriaLimpa == 'Outra condição clínica') {
      return DiagnosticoFamiliar(
        temCancer: false,
        condicoesClinicas: detalheLimpo.isEmpty ? const [] : [detalheLimpo],
      );
    }

    if (categoriaLimpa.isEmpty ||
        categoriaLimpa == 'Nenhum' ||
        categoriaLimpa == 'Desconhecido' ||
        categoriaLimpa == 'Outro (Especificar)') {
      return const DiagnosticoFamiliar(temCancer: false);
    }

    // Compatibilidade com entrevistas antigas, nas quais 5.6 e 9.9
    // armazenavam diretamente o nome do câncer.
    return DiagnosticoFamiliar(
      temCancer: true,
      tipoCancer: categoriaLimpa,
    );
  }
}
