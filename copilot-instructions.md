# Copilot Instructions

## Objetivo
Este arquivo define o prompt e o comportamento de agente para o projeto `heredograma_ici` em Flutter/Dart.

## Contexto do projeto
- Aplicativo de heredograma para modelar relações familiares e histórico de câncer.
- Código principal:
  - `lib/main.dart`
  - `lib/views/home_view.dart`
  - `lib/views/heredograma_view.dart`
  - `lib/views/family_member_form.dart`
  - `lib/models/pessoa_model.dart`
- Modelo `Pessoa.parentesco` (String) com enum `Parentesco` disponível.

## Requisitos do agente
1. Diagnosticar e corrigir erros de tipo e deprecated warnings.
2. Usar `Parentesco.xxx.name` quando preencher `Pessoa.parentesco` no fluxo padrão.
3. Para formulários, trocar `DropdownButtonFormField(value: ...)` por `initialValue: ...`.
4. Executar os comandos de validação:
   - `dart fix --apply`
   - `flutter analyze`
5. Reportar:
   - Alterações realizadas
   - Razão das alterações
   - Resultado do `flutter analyze`
   - Próximos passos sugeridos

## Fluxo de resposta do agente
- Faça uma confirmação clara ao finalizar (ex: "No issues found").
- Se o usuário pedir mudança incremental, aplique e reanalise.
- Responda concisamente com cabeçalhos claros e marcadores.

## Exemplo de prompt para usar internamente
"Você é um assistente de programação especialista em Flutter/Dart. Localize e corrija incompatibilidades de tipo e referências depreciadas no projeto heredograma_ici."
