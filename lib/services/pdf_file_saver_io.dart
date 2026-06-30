import 'dart:io';
import 'dart:typed_data';

Future<String> salvarPdfLocal(Uint8List bytes, String nome) async {
  final home = Platform.environment['HOME'] ?? Directory.current.path;
  final downloads = Directory('$home/Downloads');
  final destino = await downloads.exists() ? downloads : Directory.current;
  final arquivo = File('${destino.path}/$nome');
  await arquivo.writeAsBytes(bytes, flush: true);
  return arquivo.path;
}
