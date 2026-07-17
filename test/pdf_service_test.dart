import 'package:flutter_test/flutter_test.dart';
import 'package:heredograma_ici/models/heredograma_model.dart';
import 'package:heredograma_ici/models/pessoa_model.dart';
import 'package:heredograma_ici/services/pdf_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('gera PDF clínico com casal, descendente e diagnóstico', () async {
    final pai = Pessoa(
      id: 'pai',
      nome: 'Pai do paciente',
      sexo: 'M',
      parentesco: 'pai',
      temCancer: true,
      tipoCancer: 'Leucemia Linfoblástica Aguda (LLA)',
      idadeDiagnostico: 30,
      conjugeId: 'mae',
    );
    final mae = Pessoa(
      id: 'mae',
      nome: 'Mãe do paciente',
      sexo: 'F',
      parentesco: 'mae',
      conjugeId: 'pai',
    );
    final paciente = Pessoa(
      id: 'paciente',
      nome: 'Paciente',
      sexo: 'M',
      parentesco: 'filho',
      paiId: 'pai',
      maeId: 'mae',
    );

    final bytes = await PdfService().gerarBytes(
      Heredograma(
        id: 'teste',
        titulo: 'Heredograma clínico de teste',
        pessoas: [pai, mae, paciente],
        dataCriacao: DateTime(2026, 7, 17),
        pacienteNome: 'Paciente',
        pacienteIdade: 6,
        pacienteSexo: 'M',
      ),
    );

    expect(bytes.length, greaterThan(5000));
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
