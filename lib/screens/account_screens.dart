import 'package:amigo_secreto/models/account.dart';
import 'package:amigo_secreto/services/account_services.dart';
import 'dart:io';

import 'package:http/http.dart';

class AccountScreen {
  AccountServices _accountServices = AccountServices();

  void initializeStream() {
    _accountServices.streamInfos.listen((event) {
      print(event);
    });
  }

  void runChatBot() async {
    print("Bom dia, me chamo Amigo Secreto Bot! 🤖");
    print("Que bom te ter aqui com a gente.\n");

    bool running = true;
    while (running) {
      print("O que você gostaria de fazer?");
      print("1 - Ver todas as contas");
      print("2 - Adicionar uma nova conta");
      print("3 - Deletar uma conta");
      print("0 - Sair");

      String? input = stdin.readLineSync();
      if (input != null) {
        switch (input) {
          case "1":
            await _getAllAccounts();
            break;
          case "2":
            print("Digite o id da pessoa:");
            String? id = stdin.readLineSync();
            print("Digite o nome da pessoa:");
            String? name = stdin.readLineSync();
            print("Digite o sobrenome da pessoa:");
            String? lastName = stdin.readLineSync();
            print("Digite o saldo inicial:");
            String? balanceInput = stdin.readLineSync();
            double balance = 0.0;           
            if (balanceInput != null) {
              balance = double.tryParse(balanceInput) ?? 0.0;
            }
             print("Digite o tipo da conta:");
            String? accountType = stdin.readLineSync();

            Account newAccount = Account(
              id: id ?? '',
              name: name ?? '',
              lastName: lastName ?? '',
              balance: balance,
              accountType: accountType ?? '',
            );
            await _accountServices.addAccount(newAccount);
            break;
          case "3":
            print("Deletar uma conta.");
            print("Digite o id da conta a ser deletada:");
            String? deleteId = stdin.readLineSync();
            await _accountServices.deleteAccount(
              deleteId ?? '',
            ); // Deleta a conta com o id fornecido
            break;
          case "0":
            running = false;
            print("Até mais!");
            break;
          default:
            print("Opção inválida. Tente novamente.");
        }
      }
    }
  }

  _getAllAccounts() async {
    try {
      // Tenta executar o código
      List<Account> listAccounts = await _accountServices.getAll();
      print("Aqui estão todas as contas:");
      print(listAccounts);
    } on ClientException catch (clientException) {
      // Captura exceções específicas de ClientException
      print("Erro de conexão ao servidor.");
      print(clientException.message); //print da mensagem de erro
      print(clientException.uri); // print do URI acessado
    } on Exception {
      // Captura qualquer exceção lançada
      print("Erro ao buscar as contas.");
    } finally {
      // Código que sempre será executado
      print("${DateTime.now()} | Operação de busca de contas finalizada.");
    }
  }
}