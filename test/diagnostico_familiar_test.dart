import 'package:flutter_test/flutter_test.dart';
import 'package:heredograma_ici/models/diagnostico_familiar.dart';

void main() {
  test('separa condição clínica de câncer', () {
    final diagnostico = DiagnosticoFamiliar.fromResposta(
      categoria: 'Outra condição clínica',
      detalhe: 'Autismo',
    );

    expect(diagnostico.temCancer, isFalse);
    expect(diagnostico.tipoCancer, isNull);
    expect(diagnostico.condicoesClinicas, ['Autismo']);
  });

  test('preserva diagnóstico oncológico informado', () {
    final diagnostico = DiagnosticoFamiliar.fromResposta(
      categoria: 'Câncer',
      detalhe: 'Leucemia',
    );

    expect(diagnostico.temCancer, isTrue);
    expect(diagnostico.tipoCancer, 'Leucemia');
    expect(diagnostico.condicoesClinicas, isEmpty);
  });

  test('não classifica opções genéricas como câncer', () {
    for (final categoria in [
      '',
      'Nenhum',
      'Desconhecido',
      'Outro (Especificar)',
    ]) {
      final diagnostico = DiagnosticoFamiliar.fromResposta(
        categoria: categoria,
      );
      expect(diagnostico.temCancer, isFalse, reason: categoria);
    }
  });

  test('aceita resposta oncológica do formulário antigo', () {
    final diagnostico = DiagnosticoFamiliar.fromResposta(
      categoria: 'Sarcoma de Ewing',
    );

    expect(diagnostico.temCancer, isTrue);
    expect(diagnostico.tipoCancer, 'Sarcoma de Ewing');
  });
}
