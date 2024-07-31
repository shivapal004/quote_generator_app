import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, String>> fetchQuote() async {
  // final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));


  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return {
      'quote': data[0]['q'],
      'author': data[0]['a']
    };
  } else {
    throw Exception('Failed to load quote');
  }
}
