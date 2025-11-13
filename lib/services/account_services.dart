// Importa bibliotecas necessárias
import 'dart:async'; // Para trabalhar com Stream e StreamController
import 'package:amigo_secreto/models/account.dart';
import 'package:http/http.dart'; // Para fazer requisições HTTP (get, post, etc.)
import 'dart:convert'; // Para converter JSON em Map/List e vice-versa
import 'package:amigo_secreto/api_key.dart'; // Onde está armazenada a chave de autenticação do GitHub (githubApiKey)

class AccountServices {
  // 🔹 Controlador de Stream (para logs e eventos)
  final StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;

  // 🔹 URL base do Gist
  final String url = "https://api.github.com/gists/b49d630bd597c03ed8b9b90d498e7f5a";

  // ============================================================
  // MÉTODO: Buscar todas as contas
  // ============================================================
  Future<List<Account>> getAll() async {
    // Faz a requisição GET aguardando o resultado
    Response response = await get(Uri.parse(url));

    _streamController.add(
      "${DateTime.now()} - Dados requisitados (status: ${response.statusCode})",
    );

    // Decodifica o JSON principal retornado pela API
    Map<String, dynamic> mapResponse = json.decode(response.body);

    // Extrai o conteúdo do arquivo "accounts.json" (lista de contas)
    List<dynamic> listDynamic =
        json.decode(mapResponse['files']['accounts.json']['content']);

    // Converte os Maps para objetos Account
    List<Account> listAccounts =
        listDynamic.map((item) => Account.fromMap(item)).toList();

    return listAccounts;
  }

  // ============================================================
  // MÉTODO: Salvar lista de contas atualizada na API
  // ============================================================
  Future<bool> _saveAccountsToApi(List<Account> listAccounts) async {
    // Converte cada conta em Map e depois para JSON
    List<Map<String, dynamic>> listContent =
        listAccounts.map((acc) => acc.toMap()).toList();

    String content = json.encode(listContent);

    // Faz o POST para atualizar o Gist
    Response response = await post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $githubApiKey",
      },
      body: json.encode({
        "description": "Accounts.json",
        "public": true,
        "files": {
          "accounts.json": {
            "content": content,
          },
        },
      }),
    );

    // Retorna true se o status começar com "2" (ex: 200, 201)
    bool success = response.statusCode.toString().startsWith("2");

    _streamController.add(
      "${DateTime.now()} - Atualização na API: ${success ? 'sucesso' : 'erro'} (status: ${response.statusCode})",
    );

    return success;
  }

  // ============================================================
  // MÉTODO: Adicionar nova conta
  // ============================================================
  Future<void> addAccount(Account account) async {
    List<Account> listAccounts = await getAll();
    listAccounts.add(account);

    bool success = await _saveAccountsToApi(listAccounts);

    _streamController.add(
      success
          ? "${DateTime.now()} - Dados inseridos (${account.name})"
          : "${DateTime.now()} - Erro ao inserir dados (${account.name})",
    );
  }

  // ============================================================
  // MÉTODO: Deletar conta
  // ============================================================
  Future<void> deleteAccount(String id) async {
    List<Account> listAccounts = await getAll();
    listAccounts.removeWhere((account) => account.id == id);

    bool success = await _saveAccountsToApi(listAccounts);

    _streamController.add(
      success
          ? "${DateTime.now()} - Dados deletados (ID: $id)"
          : "${DateTime.now()} - Erro ao deletar dados (ID: $id)",
    );
  }
}
