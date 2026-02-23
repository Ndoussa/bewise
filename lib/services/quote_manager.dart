import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';
import 'api_service.dart';

class QuoteManager {
  final ApiService _apiService = ApiService();

  // Clés de stockage
  static const String _keyCachedQuote = 'cached_quote';
  static const String _keyLastUpdate = 'last_update';
  static const String _keyCategory = 'last_category';

  Future<Quote> getDailyQuote(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
    
    final String? lastDate = prefs.getString(_keyLastUpdate);
    final String? lastCat = prefs.getString(_keyCategory);
    final String? cachedJson = prefs.getString(_keyCachedQuote);

    // LOGIQUE : Si c'est le même jour ET la même catégorie, on rend la copie locale
    if (lastDate == today && lastCat == category && cachedJson != null) {
      print("Récupération locale : même jour, même thème.");
      return Quote.fromJson(jsonDecode(cachedJson));
    }

    // SINON : On appelle l'IA (nouveau jour ou nouvelle catégorie)
    print("Appel IA : changement détecté.");
    Quote newQuote = await _apiService.getAiQuote(category);

    // Sauvegarde pour la prochaine fois
    await prefs.setString(_keyLastUpdate, today);
    await prefs.setString(_keyCategory, category);
    await prefs.setString(_keyCachedQuote, jsonEncode(newQuote.toJson()));

    return newQuote;
  }
}