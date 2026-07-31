import 'package:flutter_test/flutter_test.dart';
import 'package:heredograma_ici/models/pedigree_layout.dart';
import 'package:heredograma_ici/models/pessoa_model.dart';

void main() {
  test('organiza avós, pais e probando em três gerações', () {
    final avo = Pessoa(
      id: 'avo',
      nome: 'Avô',
      sexo: 'M',
      parentesco: 'avô paterno',
    );
    final avoa = Pessoa(
      id: 'avoa',
      nome: 'Avó',
      sexo: 'F',
      parentesco: 'avó paterna',
    );
    final pai = Pessoa(
      id: 'pai',
      nome: 'Pai',
      sexo: 'M',
      parentesco: 'pai',
      paiId: avo.id,
      maeId: avoa.id,
    );
    final mae = Pessoa(
      id: 'mae',
      nome: 'Mãe',
      sexo: 'F',
      parentesco: 'mãe',
    );
    final probando = Pessoa(
      id: 'probando',
      nome: 'Probando',
      sexo: 'M',
      parentesco: 'filho',
      probando: true,
      paiId: pai.id,
      maeId: mae.id,
    );

    final layout = PedigreeLayout.fromPeople([avo, avoa, pai, mae, probando]);

    expect(layout.positions[avo.id]!.y, lessThan(layout.positions[pai.id]!.y));
    expect(
      layout.positions[pai.id]!.y,
      lessThan(layout.positions[probando.id]!.y),
    );
    expect(layout.positions[avo.id]!.y, layout.positions[avoa.id]!.y);
    expect(layout.positions[pai.id]!.y, layout.positions[mae.id]!.y);
  });

  test('distingue relação adotiva da relação biológica', () {
    final paiBiologico = Pessoa(
      id: 'pai_biologico',
      nome: 'Pai biológico',
      sexo: 'M',
      parentesco: 'pai',
    );
    final paiAdotivo = Pessoa(
      id: 'pai_adotivo',
      nome: 'Pai adotivo',
      sexo: 'M',
      parentesco: 'tio paterno',
    );
    final probando = Pessoa(
      id: 'probando',
      nome: 'Probando',
      sexo: 'F',
      parentesco: 'filha',
      probando: true,
      adocao: 'Sim, de dentro da família',
      paiId: paiBiologico.id,
      paiAdotivoId: paiAdotivo.id,
    );

    final layout =
        PedigreeLayout.fromPeople([paiBiologico, paiAdotivo, probando]);

    expect(layout.relationshipLines.any((line) => line.adotivo), isTrue);
    expect(layout.relationshipLines.any((line) => !line.adotivo), isTrue);
  });
}
