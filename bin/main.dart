
 import 'package:amigo_secreto/screens/account_screens.dart';
import 'package:amigo_secreto/services/transaction_service.dart';

void main() {
  // TransactionService().makeTrasaction(idSender: 'ID001', idReceiver: 'ID002', amount: 5001);
   AccountScreen accountScreen = AccountScreen();
   accountScreen.initializeStream();
   accountScreen.runChatBot();
   
}
