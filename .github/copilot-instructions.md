## Instruções para agentes de código (projeto: contas_api)

Este documento fornece contexto prático para que um agente de código seja imediatamente produtivo neste repositório Dart.

**Visão geral:**
- **Arquitetura:** app CLI/library simples. Entrada em `bin/main.dart`. Código de domínio em `lib/` dividido em `models/`, `services/`, `helpers/`.
- **Persistência:** não há DB local — os serviços persistem em um **Gist do GitHub** (URL em `AccountService.url` / `TransactionService.url`).
- **Fluxo principal:** `TransactionService.makeTransaction(...)` lê contas via `AccountService.getAll()`, valida saldo, aplica `helpers/helper_taxes.dart`, atualiza saldos e persiste contas + transação.

**Como executar / testar rapidamente:**
- Instalar dependências: `dart pub get`.
- Executar exemplo em `bin`: `dart run bin/main.dart` (ou `dart run`).
- Testes unitários padrão: `dart test` (pasta `test/`).

**Padrões do projeto (importante):**
- Serviços usam `package:http` (`get`, `post`) para interagir com o Gist. Veja `lib/services/account_services.dart` e `lib/services/transaction_service.dart`.
- Modelos usam `toMap()/fromMap()` e `toJson()/fromJson()`; datas são serializadas com `millisecondsSinceEpoch` (veja `Transaction`).
- Logs simples de operação do `AccountService` são emitidos via `Stream<String>` disponível em `AccountService.streamInfos` — útil para UI/CLI reativa.

**Regras de negócio específicas:**
- Cálculo de taxas em `lib/helpers/helper_taxes.dart`:
  - `amount < 5000` => taxa 0.
  - Tipos `AMBROSIA`, `CANJICA`, `PUDIM` têm percentuais específicos.
  - `accountType == null` atualmente retorna `0.1` (10%) — revisar antes de alterar comportamento de produção.

**Questões operacionais e armadilhas conhecidas:**
- `pubspec.yaml` define o `name: amigo_secreto` — o pacote pode usar esse nome nos imports (`package:amigo_secreto/...`) embora o repositório se chame `contas_api`.
- Existe uma dependência `dio` no `pubspec.yaml` mas o código atual usa `package:http`; confirmar se `dio` é necessária.
- **Segurança crítica:** há um arquivo `lib/api_key.dart` contendo uma chave API hardcoded. Nunca deixar chaves em repositórios públicos — substitua por variáveis de ambiente ou um segredo externo antes de qualquer deploy. Para trabalhos locais, prefira carregar com `const String githubApiKey = String.fromEnvironment('GITHUB_API_KEY');` e documentar como fornecê-la.

**Exemplos úteis — chamadas frequentes que um agente pode escrever/alterar:**
- Criar uma transação (exemplo no `bin/main.dart`):
  - `TransactionService().makeTransaction(idSender: "ID001", idReceiver: "ID002", amount: 8);`
- Ler todas as contas:
  - `final accounts = await AccountService().getAll();`

**Arquivos-chave para inspeção rápida:**
- `bin/main.dart` — ponto de entrada e script de exemplo.
- `lib/services/account_services.dart` — leitura/gravação de contas (+ stream de logs).
- `lib/services/transaction_service.dart` — coordena transações e persiste em Gist.
- `lib/helpers/helper_taxes.dart` — regras de taxação (comportamento não trivial).
- `lib/models/*.dart` — `Account` e `Transaction` (serialização/equals/copyWith).
