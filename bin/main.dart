
import 'package:amigo_secreto/screens/account_screens.dart';
// import 'package:dio/dio.dart';
void main() async {
  // final dio = Dio();
  // final response = await dio.get('https://pub.dev');
  // print(response.data);
  AccountScreen accountScreen = AccountScreen();
  accountScreen.initializeStream();
  accountScreen.runChatBot();
}
