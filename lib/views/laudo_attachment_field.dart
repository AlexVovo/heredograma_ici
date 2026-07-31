import 'package:flutter/material.dart';

import '../services/laudo_attachment_service.dart';

class LaudoAttachmentField extends StatefulWidget {
  final Map<String, dynamic>? anexo;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final bool enabled;

  const LaudoAttachmentField({
    super.key,
    required this.anexo,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<LaudoAttachmentField> createState() => _LaudoAttachmentFieldState();
}

class _LaudoAttachmentFieldState extends State<LaudoAttachmentField> {
  final _service = LaudoAttachmentService();
  bool _processando = false;

  Future<void> _selecionar() async {
    setState(() => _processando = true);
    try {
      final anexo = await _service.selecionarEEnviar();
      if (anexo != null) widget.onChanged(anexo);
    } catch (error) {
      _mostrarErro(error);
    } finally {
      if (mounted) setState(() => _processando = false);
    }
  }

  Future<void> _excluir() async {
    final anexo = widget.anexo;
    if (anexo == null) return;
    setState(() => _processando = true);
    try {
      await _service.excluir(anexo);
      widget.onChanged(null);
    } catch (error) {
      _mostrarErro(error);
    } finally {
      if (mounted) setState(() => _processando = false);
    }
  }

  Future<void> _baixar() async {
    try {
      await _service.abrir(widget.anexo!);
    } catch (error) {
      _mostrarErro(error);
    }
  }

  void _mostrarErro(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final anexo = widget.anexo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            border: Border.all(color: Colors.amber.shade700),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.science_outlined),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Ambiente de protótipo. Anexe somente arquivos fictícios '
                  'ou completamente anonimizados.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (anexo == null)
          if (widget.enabled)
            OutlinedButton.icon(
              onPressed: _processando ? null : _selecionar,
              icon: _processando
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.attach_file),
              label: Text(_processando ? 'Enviando...' : 'Anexar laudo'),
            )
          else
            const Text('Nenhum laudo anexado.')
        else
          Card(
            child: ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(anexo['nome']?.toString() ?? 'Laudo'),
              subtitle: Text(_tamanho(anexo['tamanho'])),
              onTap: _processando ? null : _baixar,
              trailing: widget.enabled
                  ? IconButton(
                      tooltip: 'Excluir anexo',
                      onPressed: _processando ? null : _excluir,
                      icon: const Icon(Icons.delete_outline),
                    )
                  : const Icon(Icons.download_outlined),
            ),
          ),
        const SizedBox(height: 8),
        const Text(
          'Formatos aceitos: PDF, JPG e PNG. Tamanho máximo: 700 KB.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  String _tamanho(dynamic value) {
    final bytes = value is num ? value.toInt() : 0;
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }
}
