
import 'package:http/http.dart' as http;

abstract class ImplTriviaServices {
  Future<http.Response> getTrivias();
}

class TriviaServices implements ImplTriviaServices {
  @override
  Future<http.Response> getTrivias() async {
    return await http
        .get(Uri.parse("https://opentdb.com/api.php?amount=9&category=18"));
  }
}
