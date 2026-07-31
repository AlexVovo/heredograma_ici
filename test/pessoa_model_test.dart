import 'package:flutter_test/flutter_test.dart';
import 'package:heredograma_ici/models/pessoa_model.dart';

void main() {
  test('lê registro antigo aplicando valores compatíveis', () {
    final pessoa = Pessoa.fromJson({
      'id': '1',
      'nome': 'Pessoa',
      'sexo': 'F',
      'parentesco': 'tia',
      'temCancer': false,
    });

    expect(pessoa.statusVital, 'Desconhecido');
    expect(pessoa.adocao, 'Desconhecido');
    expect(pessoa.condicoesClinicas, isEmpty);
    expect(pessoa.falecido, isFalse);
  });

  test('preserva estado vital, adoção e vínculos na serialização', () {
    final original = Pessoa(
      id: '1',
      nome: 'Pessoa',
      sexo: 'M',
      parentesco: 'filho',
      statusVital: 'Falecido',
      idadeObito: 20,
      adocao: 'Sim, de dentro da família',
      paiId: 'pai',
      paiAdotivoId: 'tio',
      condicoesClinicas: const ['Autismo'],
      probando: true,
    );

    final restaurada = Pessoa.fromJson(original.toJson());

    expect(restaurada.falecido, isTrue);
    expect(restaurada.idadeObito, 20);
    expect(restaurada.paiId, 'pai');
    expect(restaurada.paiAdotivoId, 'tio');
    expect(restaurada.condicoesClinicas, ['Autismo']);
    expect(restaurada.probando, isTrue);
  });
}
