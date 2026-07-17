import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/historico_familiar_questionario.dart';
import '../models/heredograma_model.dart';
import '../models/pedigree_layout.dart';
import '../models/pessoa_model.dart';
import 'pdf_file_saver.dart';

class PdfService {
  Future<String?> gerarHeredograma(Heredograma heredograma) async {
    final bytes = await gerarBytes(heredograma);
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

  Future<Uint8List> gerarBytes(Heredograma heredograma) async {
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final font = pw.Font.ttf(fontData);
    final documento = pw.Document(
      theme: pw.ThemeData.withFont(base: font, bold: font),
    );

    documento.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => _paginaHeredograma(heredograma),
      ),
    );

    if (heredograma.entrevistaRespostas.isNotEmpty) {
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
              'Respostas da entrevista',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text('Paciente: ${heredograma.pacienteNome}'),
            if (heredograma.pacienteIdade != null)
              pw.Text('Idade: ${heredograma.pacienteIdade} anos'),
            pw.SizedBox(height: 18),
            ..._respostas(heredograma),
          ],
        ),
      );
    }

    return documento.save();
  }

  pw.Widget _paginaHeredograma(Heredograma heredograma) {
    final layout = PedigreeLayout.fromPeople(heredograma.pessoas);
    const diagramWidth = 790.0;
    const diagramHeight = 410.0;
    final scaleX = diagramWidth / layout.width;
    final scaleY = diagramHeight / layout.height;
    final availableScale = scaleX < scaleY ? scaleX : scaleY;
    final scale = availableScale > 1.2 ? 1.2 : availableScale;
    final offsetX = (diagramWidth - layout.width * scale) / 2;
    final offsetY = (diagramHeight - layout.height * scale) / 2;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 8),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.blueGrey700, width: 1),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _dadoCabecalho('PACIENTE', heredograma.pacienteNome),
              _dadoCabecalho(
                'IDADE',
                heredograma.pacienteIdade == null
                    ? 'Não informada'
                    : '${heredograma.pacienteIdade} anos',
              ),
              _dadoCabecalho(
                'ATUALIZADO EM',
                _formatarData(
                  heredograma.dataAtualizacao ?? heredograma.dataCriacao,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 9),
        pw.Text(
          heredograma.titulo,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Container(
          width: diagramWidth,
          height: diagramHeight,
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            border: pw.Border.all(color: PdfColors.grey300, width: .5),
          ),
          child: heredograma.pessoas.isEmpty
              ? pw.Center(child: pw.Text('Nenhuma pessoa cadastrada.'))
              : pw.Stack(
                  children: [
                    pw.CustomPaint(
                      size: const PdfPoint(diagramWidth, diagramHeight),
                      painter: (canvas, size) {
                        canvas
                          ..setStrokeColor(PdfColors.black)
                          ..setLineWidth(1.2);
                        for (final line in layout.relationshipLines) {
                          canvas
                            ..drawLine(
                              offsetX + line.start.x * scale,
                              diagramHeight - (offsetY + line.start.y * scale),
                              offsetX + line.end.x * scale,
                              diagramHeight - (offsetY + line.end.y * scale),
                            )
                            ..strokePath();
                        }
                      },
                    ),
                    ..._pessoasPdf(
                      heredograma.pessoas,
                      layout,
                      scale,
                      offsetX,
                      offsetY,
                    ),
                    ..._geracoesPdf(layout, scale, offsetY),
                    _legendaClinica(heredograma.pessoas),
                  ],
                ),
        ),
      ],
    );
  }

  List<pw.Widget> _pessoasPdf(
    List<Pessoa> pessoas,
    PedigreeLayout layout,
    double scale,
    double offsetX,
    double offsetY,
  ) {
    const symbol = 28.0;
    const cardWidth = 112.0;
    return [
      for (var index = 0; index < pessoas.length; index++)
        if (layout.positions[pessoas[index].id] case final point?)
          pw.Positioned(
            left: offsetX + point.x * scale - cardWidth / 2,
            top: offsetY + point.y * scale - symbol / 2,
            child: pw.SizedBox(
              width: cardWidth,
              child: pw.Column(
                children: [
                  pw.Stack(
                    overflow: pw.Overflow.visible,
                    children: [
                      pw.Center(child: _simboloPdf(pessoas[index], symbol)),
                      pw.Positioned(
                        left: cardWidth / 2 - symbol / 2 - 10,
                        top: -9,
                        child: pw.Text(
                          '${index + 1}',
                          style: const pw.TextStyle(fontSize: 6),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 3),
                  pw.SizedBox(
                    width: cardWidth,
                    child: pw.Column(
                      children: [
                        pw.Text(
                          pessoas[index].nome,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 7, fontWeight: pw.FontWeight.bold),
                        ),
                        if (pessoas[index].tipoCancer?.trim().isNotEmpty ==
                            true)
                          pw.Text(
                            pessoas[index].tipoCancer!,
                            textAlign: pw.TextAlign.center,
                            maxLines: 2,
                            style: const pw.TextStyle(fontSize: 6),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    ];
  }

  pw.Widget _simboloPdf(Pessoa pessoa, double size) {
    final shape =
        pessoa.sexo == 'F' ? pw.BoxShape.circle : pw.BoxShape.rectangle;
    return pw.Container(
      width: size,
      height: size,
      decoration: pw.BoxDecoration(
        shape: shape,
        color: pessoa.temCancer
            ? _corDiagnosticoPdf(pessoa.tipoCancer)
            : PdfColors.white,
        border: pw.Border.all(width: 1.2),
      ),
    );
  }

  List<pw.Widget> _geracoesPdf(
    PedigreeLayout layout,
    double scale,
    double offsetY,
  ) {
    final rows = layout.positions.values
        .map((point) => point.y)
        .toSet()
        .toList()
      ..sort();
    const romans = ['I', 'II', 'III', 'IV', 'V', 'VI'];
    return [
      for (var i = 0; i < rows.length; i++)
        pw.Positioned(
          left: 4,
          top: offsetY + rows[i] * scale - 5,
          child: pw.Text(i < romans.length ? romans[i] : '${i + 1}',
              style:
                  pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ),
    ];
  }

  pw.Widget _legendaClinica(List<Pessoa> pessoas) {
    final diagnoses = pessoas
        .where((p) => p.temCancer && p.tipoCancer?.trim().isNotEmpty == true)
        .map((p) => p.tipoCancer!)
        .toSet()
        .toList();
    return pw.Positioned(
      right: 8,
      bottom: 4,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('LEGENDA',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          for (final diagnosis in diagnoses)
            pw.Row(
              children: [
                pw.Container(
                    width: 7, height: 7, color: _corDiagnosticoPdf(diagnosis)),
                pw.SizedBox(width: 4),
                pw.Text(diagnosis, style: const pw.TextStyle(fontSize: 6)),
              ],
            ),
          pw.SizedBox(height: 2),
          pw.Row(
            children: [
              _itemSimboloLegenda('Masculino', pw.BoxShape.rectangle),
              pw.SizedBox(width: 8),
              _itemSimboloLegenda('Feminino', pw.BoxShape.circle),
              pw.SizedBox(width: 8),
              pw.Text(
                'Losango: sexo não informado',
                style: const pw.TextStyle(fontSize: 6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _dadoCabecalho(String rotulo, String valor) {
    return pw.Row(
      children: [
        pw.Text(
          '$rotulo: ',
          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(valor, style: const pw.TextStyle(fontSize: 8)),
      ],
    );
  }

  pw.Widget _itemSimboloLegenda(String texto, pw.BoxShape shape) {
    return pw.Row(
      children: [
        pw.Container(
          width: 7,
          height: 7,
          decoration: pw.BoxDecoration(
            shape: shape,
            border: pw.Border.all(width: .7),
          ),
        ),
        pw.SizedBox(width: 3),
        pw.Text(texto, style: const pw.TextStyle(fontSize: 6)),
      ],
    );
  }

  PdfColor _corDiagnosticoPdf(String? diagnostico) {
    final value = diagnostico?.toLowerCase() ?? '';
    if (value.contains('sarcoma de ewing')) return PdfColors.green700;
    if (value.contains('leucemia')) return PdfColors.deepPurple;
    if (value.contains('linfoma')) return PdfColors.blue700;
    return PdfColors.red700;
  }

  String _formatarData(DateTime data) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(data.day)}/${two(data.month)}/${data.year}';
  }

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
      const rotulos = <String, String>{
        'ordem': 'Tumor',
        'tipo': 'Tipo',
        'local': 'Local',
        'parentesco': 'Parentesco',
        'genitores': 'Genitores',
        'nome': 'Nome',
        'genero': 'Gênero',
        'diagnostico': 'Diagnóstico',
        'testeGenetico': 'Teste genético',
        'nascimento': 'Nascimento',
        'idadeAtual': 'Idade atual',
        'idadeDiagnostico': 'Idade no diagnóstico',
        'statusVital': 'Estado vital',
        'idadeObito': 'Idade do óbito',
        'adotado': 'Adoção',
        'conjuge': 'Cônjuge',
        'relacao': 'Relação',
        'quantidadeFilhos': 'Filhos',
        'causaObito': 'Causa da morte',
        'observacoes': 'Observações',
      };
      final dados = <String>[];
      for (final entry in rotulos.entries) {
        final valor = item[entry.key];
        if (valor == null || valor.toString().trim().isEmpty) continue;
        dados.add('${entry.value}: $valor');
      }
      return dados.join(' — ');
    }).join('\n');
  }
}
