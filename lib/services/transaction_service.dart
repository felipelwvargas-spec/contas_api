import 'package:amigo_secreto/helpers/helper_taxes.dart';
import 'package:amigo_secreto/models/account.dart';
import 'package:amigo_secreto/services/account_services.dart';

class TransactionService{
  AccountServices _accountServices = AccountServices();
    dynamic makeTrasaction({required String idSender, required String idReceiver, required double amount}) async {
    List<Account> listAccounts = await _accountServices.getAll();
    Account senderAccount = listAccounts.firstWhere((acc) => acc.id == idSender,) ;
    Account receiverAccount = listAccounts.firstWhere((acc) => acc.id == idReceiver,);
    print(senderAccount);
    print(receiverAccount);
    print(calculateTaxesByAccount(sender: senderAccount, amount: amount));
    }

}