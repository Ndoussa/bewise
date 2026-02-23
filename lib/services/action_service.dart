import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../models/quote.dart';

class ActionService {
  // COPIER LE TEXTE
  static void copyQuote(Quote quote) {
    Clipboard.setData(ClipboardData(text: "${quote.text} - ${quote.author}"));
  }

  // PARTAGER LA CITATION
  static void shareQuote(Quote quote) {
    Share.share(
      "Ma dose de sagesse du jour : \n\n'${quote.text}'\n— ${quote.author}\n\nEnvoyé via BeWise Premium ✨",
      subject: "Inspiration du jour",
    );
  }

  // SAUVEGARDER (Pour l'instant un print, on fera la DB après)
  static void saveToFavorites(Quote quote) {
    print("Sauvegardé dans les favoris : ${quote.text}");
    // Ici on ajoutera plus tard la logique SQLite ou Hive
  }
}