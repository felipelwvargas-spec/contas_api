// Importa bibliotecas necessárias
import 'dart:async'; // Para trabalhar com Stream e StreamController
import 'package:amigo_secreto/models/account.dart';
import 'package:http/http.dart'; // Para fazer requisições HTTP (get, post, etc.)
import 'dart:convert'; // Para converter JSON em Map/List e vice-versa
import 'package:amigo_secreto/api_key.dart'; // Onde está armazenada a chave de autenticação do GitHub (githubApiKey)

class AccountServices {
  // Cria um controlador de stream que vai emitir mensagens (Strings)
  StreamController<String> _streamController = StreamController<String>();
  Stream<String> get streamInfos => _streamController.stream;
      // URL do Gist a ser atualizado
    String url =
        "https://api.github.com/gists/b49d630bd597c03ed8b9b90d498e7f5a";

  Future<List<Account>> getAll() async {
    // Faz a requisição GET aguardando o resultado
    Response response = await get(Uri.parse(url));
    _streamController.add(
      "${DateTime.now()} - Dados requisitados (status: ${response.statusCode})",
    );
    Map<String, dynamic> mapResponse =
        json.decode(response.body); // Decodifica o JSON da resposta
    List<dynamic> listDynamic = json
        .decode(mapResponse['files']['accounts.json']['content']);
        // Decodifica o conteúdo do arquivo accounts.json (lista de contas)
    List<Account> listAccounts = [];

    for (dynamic dyn in listDynamic){// Itera sobre cada item da lista dinâmica
      Map<String, dynamic> mapAccount = dyn as Map<String, dynamic>;// Converte o item dinâmico em Map
      Account account = Account.fromMap(mapAccount);// Cria a conta a partir do Map
      listAccounts.add(account); // Adiciona a conta à lista
    } 

    // Retorna a lista decodificada do JSON (contas)
    return listAccounts;
  }

  addAccount(Account account) async {
    // Busca os dados existentes no Gist (lista de contas)
    List<Account> listAccounts = await getAll();

    // Adiciona a nova conta à lista
    listAccounts.add(account);

List<Map<String, dynamic>> listContent = [];
    for (Account account in listAccounts) {
      listContent.add(account.toMap());
    } // Converte cada conta em Map e adiciona à nova lista

    String content = json.encode(listContent);  // Converte a lista de Maps em JSON (String)

    // Envia os novos dados via POST (GitHub API)
    Response response = await post(
      Uri.parse(url),
      headers: {
        // Usa o token pessoal para autenticação no GitHub
        "Authorization": "Bearer $githubApiKey",
      },
      body: json.encode({
        // Define a estrutura exigida pela API do GitHub
        "description": "Accounts.json",
        "public": true,
        "files": {
          "accounts.json": {
            "content": content, // Aqui vai o novo conteúdo do arquivo JSON
          },
        },
      }),
    );

    // Se o status code começar com "2" (ex: 200, 201), significa sucesso
    if (response.statusCode.toString()[0] == "2") {
      _streamController.add(
        "${DateTime.now()} - Dados inseridos (${account.name})",
      );
    } else {
      _streamController.add(
        "${DateTime.now()} - Erro ao inserir dados (status: ${response.statusCode} ${account.name})",
      );
    }
  }
}
