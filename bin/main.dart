import 'package:http/http.dart';
import 'dart:convert';

void main() {
  // requestData();
  requestDataAsync();
}

requestData() {
  String url =
      "https://gist.githubusercontent.com/felipelwvargas-spec/b49d630bd597c03ed8b9b90d498e7f5a/raw/1c7f0619d6efe6f24506d2402bdab1c1ca936c4c/accounts.json";
  Future<Response> futureResponse = get(Uri.parse(url));
  print(futureResponse);
  futureResponse.then((Response response) {
    print(response);
    print(response.body);
    List<dynamic> listAccounts = json.decode(response.body);
    Map<String, dynamic> mapCarla = listAccounts.firstWhere(
      (element) => element["name"] == "Carla",
    );
    print (mapCarla["balance"]);
  });
}

requestDataAsync() async{
   String url =
      "https://gist.githubusercontent.com/felipelwvargas-spec/b49d630bd597c03ed8b9b90d498e7f5a/raw/1c7f0619d6efe6f24506d2402bdab1c1ca936c4c/accounts.json";
  Response response = await get(Uri.parse(url));
  print(json.decode (response.body)[0]);
  print("Ultima coisa a acontecer.");
}
