# heredograma_ici

## Anexos no ambiente de protótipo

O fluxo de laudos aceita arquivos PDF, JPG e PNG de até 700 KB. Para manter o
projeto no plano Spark sem cartão, cada arquivo é armazenado como um documento
separado na coleção `prototipo_laudos` do Firestore.

Essa arquitetura é exclusiva do protótipo e respeita o limite de 1 MiB por
documento do Firestore. Use somente documentos fictícios ou completamente
anonimizados. Antes de qualquer homologação ou uso clínico, migre os arquivos
para armazenamento próprio, com autenticação e autorização institucional.

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
