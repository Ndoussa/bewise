import 'dart:convert';
import 'dart:math';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/quote.dart';

class ApiService {
  // Utilise bien ta clé AlzaSyB4...AYw
  final String _apiKey = "AIzaSyB4Ofg35arh5MkRc26mjc3ajzQSsueuAYw"; 

  Future<Quote> getAiQuote(String category) async {
    try {
      // 1. On essaie le modèle que tu vois dans ton interface
      final model = GenerativeModel(
        model: 'gemini-3-flash-preview', 
        apiKey: _apiKey,
      );
      
      final prompt = "Donne-moi une citation unique en français sur le thème '$category'. "
                     "Format JSON uniquement: {'q': 'citation', 'a': 'auteur'}";

      final response = await model.generateContent([Content.text(prompt)]);
      
      if (response.text != null) {
        String cleanJson = response.text!.replaceAll('```json', '').replaceAll('```', '').trim();
        return Quote.fromJson(jsonDecode(cleanJson));
      }
      throw Exception("Réponse vide");
    } catch (e) {
      print("Erreur IA: $e");
      
      // LOGIQUE DE SECOURS : Si le modèle Gemini 3 n'est pas encore 
      // reconnu par ton code Dart, on utilise des citations locales.
      // Cela garantit que le bouton "NOUVELLE DOSE" fonctionne.
      return _getRandomFallback();
    }
  }

  Quote _getRandomFallback() {
    final list = [
      Quote(text: "Le succès est un voyage, pas une destination.", author: "Arthur Ashe"),
      Quote(text: "L'échec est le fondement de la réussite.", author: "Lao Tseu"),
      Quote(text: "Innover, c'est savoir abandonner des milliers de bonnes idées.", author: "Steve Jobs")
    ];
    return list[Random().nextInt(list.length)];
  }
}