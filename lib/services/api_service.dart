import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class ApiService {
  // Utilisation du proxy AllOrigins pour éviter les blocages CORS sur Chrome
  static const String _url = "https://api.allorigins.win/raw?url=https://zenquotes.io/api/random";

  Future<Quote> getRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // On prend le premier élément de la liste renvoyée par ZenQuotes
        return Quote.fromJson(data[0]);
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }
}