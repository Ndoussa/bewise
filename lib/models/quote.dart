class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    // Debug: décommente la ligne suivante pour voir le JSON dans ta console
    // print("JSON reçu dans le modèle: $json"); 

    return Quote(
      text: json['q'] ?? "Citation introuvable", // ZenQuotes utilise 'q'
      author: json['a'] ?? "Inconnu",            // ZenQuotes utilise 'a'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
    };
  }
}