import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/historico_familiar_questionario.dart';
import '../models/heredograma_model.dart';
import '../models/pessoa_model.dart';
import 'pdf_file_saver.dart';

class PdfService {
  Future<String?> gerarHeredograma(Heredograma heredograma) async {
    final bytes = await _criarDocumento(heredograma);
    final nomeSeguro = heredograma.titulo
        .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')
        .toLowerCase();
    final nomeArquivo = '${nomeSeguro}_heredograma.pdf';

    try {
      await Printing.layoutPdf(
        name: nomeArquivo,
        onLayout: (_) async => bytes,
      );
      return null;
    } on MissingPluginException {
      return salvarPdfLocal(bytes, nomeArquivo);
    }
  }

  Future<Uint8List> _criarDocumento(Heredograma heredograma) async {
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final font = pw.Font.ttf(fontData);
    final documento = pw.Document(
      theme: pw.ThemeData.withFont(base: font, bold: font),
    );

    final pai = _primeiroPorParentesco(heredograma.pessoas, const ['pai']);
    final mae = _primeiroPorParentesco(heredograma.pessoas, const ['mae']);
    final probando = _primeiroPorParentesco(
      heredograma.pessoas,
      const ['filho', 'filha'],
    );

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 8),
          margin: const pw.EdgeInsets.only(bottom: 16),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.blueGrey300),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Heredograma ICI'),
              pw.Text('Página ${context.pageNumber}'),
            ],
          ),
        ),
        build: (context) => [
          pw.Text(
            heredograma.titulo,
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text('Paciente: ${heredograma.pacienteNome}'),
          if (heredograma.pacienteIdade != null)
            pw.Text('Idade: ${heredograma.pacienteIdade} anos'),
          pw.SizedBox(height: 24),
          pw.Text(
            'Heredograma',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 18),
          _heredogramaBasico(pai: pai, mae: mae, probando: probando),
          pw.SizedBox(height: 18),
          _legenda(),
          if (heredograma.pessoas.length > 3) ...[
            pw.SizedBox(height: 24),
            pw.Text(
              'Outros familiares',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Wrap(
              spacing: 12,
              runSpacing: 12,
              children: heredograma.pessoas
                  .where((p) => p != pai && p != mae && p != probando)
                  .map(_cartaoPessoa)
                  .toList(),
            ),
          ],
          if (heredograma.entrevistaRespostas.isNotEmpty) ...[
            pw.SizedBox(height: 28),
            pw.Text(
              'Respostas da entrevista',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            ..._respostas(heredograma),
          ],
        ],
      ),
    );

    return documento.save();
  }

  Pessoa? _primeiroPorParentesco(
    List<Pessoa> pessoas,
    List<String> parentescos,
  ) {
    for (final pessoa in pessoas) {
      if (parentescos.contains(pessoa.parentesco)) return pessoa;
    }
    return null;
  }

  pw.Widget _heredogramaBasico({
    required Pessoa? pai,
    required Pessoa? mae,
    required Pessoa? probando,
  }) {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              if (pai != null) _pessoa(pai),
              if (pai != null && mae != null)
                pw.Container(width: 54, height: 2, color: PdfColors.black),
              if (mae != null) _pessoa(mae),
            ],
          ),
          if (probando != null) ...[
            pw.Container(width: 2, height: 36, color: PdfColors.black),
            _pessoa(probando, probando: true),
          ],
        ],
      ),
    );
  }

  pw.Widget _pessoa(Pessoa pessoa, {bool probando = false}) {
    final masculino = pessoa.sexo == 'M';
    return pw.Column(
      children: [
        pw.Container(
          width: 38,
          height: 38,
          decoration: pw.BoxDecoration(
            shape: masculino ? pw.BoxShape.rectangle : pw.BoxShape.circle,
            color: pessoa.temCancer ? PdfColors.black : PdfColors.white,
            border: pw.Border.all(width: probando ? 3 : 2),
          ),
        ),
        pw.SizedBox(height: 4),
        pw.SizedBox(
          width: 100,
          child: pw.Text(
            pessoa.nome,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: probando ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ),
        if (pessoa.temCancer && pessoa.tipoCancer != null)
          pw.SizedBox(
            width: 110,
            child: pw.Text(
              pessoa.tipoCancer!,
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 7),
            ),
          ),
      ],
    );
  }

  pw.Widget _cartaoPessoa(Pessoa pessoa) {
    return pw.Container(
      width: 150,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            pessoa.nome,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(pessoa.parentesco),
          if (pessoa.temCancer)
            pw.Text('Diagnóstico: ${pessoa.tipoCancer ?? "informado"}'),
        ],
      ),
    );
  }

  pw.Widget _legenda() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        _itemLegenda('Quadrado: masculino'),
        pw.SizedBox(width: 16),
        _itemLegenda('Círculo: feminino'),
        pw.SizedBox(width: 16),
        _itemLegenda('Preenchido: câncer'),
      ],
    );
  }

  pw.Widget _itemLegenda(String texto) =>
      pw.Text(texto, style: const pw.TextStyle(fontSize: 8));

  List<pw.Widget> _respostas(Heredograma heredograma) {
    String? secaoAnterior;
    final widgets = <pw.Widget>[];

    for (final pergunta in perguntasHistoricoFamiliar) {
      final resposta = heredograma.entrevistaRespostas[pergunta.id];
      if (resposta == null || resposta.toString().trim().isEmpty) continue;

      if (pergunta.secao != secaoAnterior) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
            child: pw.Text(
              pergunta.secao,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
        );
        secaoAnterior = pergunta.secao;
      }

      widgets.add(
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 5),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey300),
            ),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '${pergunta.id} ${pergunta.titulo}',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey700,
                ),
              ),
              pw.Text(_formatarResposta(resposta)),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  String _formatarResposta(dynamic resposta) {
    if (resposta is! List) return resposta.toString();
    return resposta.map((item) {
      if (item is! Map) return item.toString();
      final nome = item['nome']?.toString().trim();
      final parentesco = item['parentesco']?.toString() ?? 'Familiar';
      final diagnostico = item['diagnostico']?.toString().trim();
      final dados = <String>[
        if (nome != null && nome.isNotEmpty) nome,
        parentesco,
        if (diagnostico != null && diagnostico.isNotEmpty) diagnostico,
      ];
      return dados.join(' — ');
    }).join('\n');
  }
}
