import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/quote.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Quote> _quoteFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Chargement initial
    _quoteFuture = _apiService.getRandomQuote();
  }

  // LA MÉTHODE CORRECTE POUR RAFRAÎCHIR
  void _refreshQuote() {
    setState(() {
      // On réassigne un NOUVEAU Future. 
      // Le FutureBuilder va détecter ce changement et se reconstruire.
      _quoteFuture = _apiService.getRandomQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond avec dégradé animé ou fixe
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF141E30), Color(0xFF243B55)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Bonjour, ${widget.userName} ✨",
                      style: const TextStyle(color: Colors.white70, fontSize: 22, fontWeight: FontWeight.w300),
                    ),
                  ),
                  const Spacer(),
                  
                  // Zone de la citation avec Animation de transition
                  FutureBuilder<Quote>(
                    future: _quoteFuture,
                    builder: (context, snapshot) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                        child: _buildContent(snapshot),
                      );
                    },
                  ),
                  
                  const Spacer(),
                  
                  // Bouton Professionnel
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _refreshQuote, // Appel de la fonction de rafraîchissement
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueGrey[900],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                      ),
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text("NOUVELLE INSPIRATION", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildContent(AsyncSnapshot<Quote> snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  } 
  
  if (snapshot.hasError) {
    // Affiche l'erreur réelle pour le debug
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "Erreur technique : ${snapshot.error}", 
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.redAccent, fontSize: 14),
      ),
    );
  } 
  
  if (snapshot.hasData) {
    return Column(
      key: ValueKey(snapshot.data!.text),
      children: [
        const Icon(Icons.format_quote, color: Colors.white24, size: 80),
        Text(
          snapshot.data!.text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          "— ${snapshot.data!.author}",
          style: const TextStyle(color: Colors.white54, fontSize: 16),
        ),
      ],
    );
  }
  return const SizedBox();
}
}