import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/quote_manager.dart';
import '../models/quote.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String initialCategory;

  const HomeScreen({super.key, required this.userName, required this.initialCategory, required String category});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Quote> _quoteFuture;
  late String _currentCategory;
  
  // Liste des catégories disponibles pour la personnalisation
  final QuoteManager _quoteManager = QuoteManager();
  final List<String> _categories = ["Motivation", "Sagesse", "Discipline", "Succès", "Sport", "Amour"];

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.initialCategory;
    _quoteFuture = ApiService().getAiQuote(_currentCategory);
  }

  // 2. Ta fonction de rafraîchissement devient ultra simple
void _refresh() {
  setState(() {
    // On appelle getDailyQuote qui décide seul s'il va sur le web ou en local
    _quoteFuture = _quoteManager.getDailyQuote(_currentCategory);
  });
}

  // Fonction pour changer de catégorie via le menu
  void _changeCategory(String newCat) {
    setState(() {
      _currentCategory = newCat;
      _quoteFuture = ApiService().getAiQuote(_currentCategory);
    });
    Navigator.pop(context); // Ferme le menu latéral
  }

  // Dans ton _HomeScreenState, modifie la fonction _refresh :

          void _showFrequencyDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E293B), // Cohérent avec votre Drawer
            title: const Text(
              "Fréquence d'Inspiration", 
              style: TextStyle(color: Colors.white, fontSize: 18)
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFrequencyOption("Quotidien", Icons.wb_sunny_outlined),
                _buildFrequencyOption("Hebdomadaire", Icons.calendar_view_week),
                _buildFrequencyOption("Personnalisé", Icons.edit_calendar),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("ANNULER", style: TextStyle(color: Colors.white24)),
              ),
            ],
          );
        },
      );
    }

    // Widget assistant pour construire les options dans le dialogue
    Widget _buildFrequencyOption(String title, IconData icon) {
      return ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(color: Colors.white70)),
        onTap: () {
          // Ici, vous enregistrerez la préférence plus tard avec SharedPreferences
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fréquence réglée sur : $title")),
          );
        },
      );
    }

      // Pour le bouton retour (AppBar ou Drawer), utilise ceci :

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Bleu nuit pro
      
      // --- LE MENU LATÉRAL (DRAWER) ---
      drawer: _buildDrawer(),
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Le bouton de menu s'affiche automatiquement ici grâce au drawer
        title: const Text("BEWISE PREMIUM", 
          style: TextStyle(letterSpacing: 4, fontSize: 12, color: Colors.blueAccent)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white24),
            onPressed: () {
              // Future fonctionnalité : historique des doses
            },
          )
        ],
      ),
      
      body: Column(
        children: [
          // En-tête avec nom de l'utilisateur
          _buildUserInfoHeader(),
          
Expanded(
  child: FutureBuilder<Quote>(
    future: _quoteFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
      }

      if (snapshot.hasData) {
        // --- SOLUTION : Utiliser SingleChildScrollView pour éviter l'overflow ---
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Effet de rebond Premium
          child: Container(
            constraints: BoxConstraints(
              // On s'assure que le contenu prend au moins toute la hauteur dispo pour centrer
              minHeight: MediaQuery.of(context).size.height * 0.5, 
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20), // Un peu d'air en haut
                
                _buildMainQuoteCard(snapshot.data!), // Ta carte
                
                const SizedBox(height: 20), // Espace réduit pour gagner de la place
                
                _buildInteractionBar(snapshot.data!), // Ta barre pro
                
                const SizedBox(height: 20), // Un peu d'air en bas
              ],
            ),
          ),
        );
      }
      return const Center(child: Text("Erreur de connexion", style: TextStyle(color: Colors.white24)));
    },
  ),
),
          
          // Zone du bouton "GÉNÉRER UNE NOUVELLE DOSE"
          _buildFooterActions(),
          
          const SizedBox(height: 20), // Padding bas pour l'esthétique
        ],
      ),
    );
  }

  // --- COMPOSANTS DE L'INTERFACE ---

  Widget _buildUserInfoHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.1),
            child: Text(widget.userName[0].toUpperCase(), style: const TextStyle(color: Colors.blueAccent)),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Inspiration pour ${widget.userName}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Thème actuel : $_currentCategory", style: const TextStyle(color: Colors.white30, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainQuoteCard(Quote quote) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.format_quote_rounded, color: Colors.blueAccent, size: 50),
          const SizedBox(height: 20),
          Text(
            quote.text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 24, height: 1.4, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 30),
          Text("— ${quote.author}", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
        ],
      ),
    );
  }

  Widget _buildFooterActions() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 65,
            child: ElevatedButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.auto_awesome),
              label: const Text("GÉNÉRER UNE NOUVELLE DOSE", style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text("Mis à jour automatiquement chaque jour", style: TextStyle(color: Colors.white10, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
  return Drawer(
    backgroundColor: const Color(0xFF1E293B),
    child: Column(
      children: [
        // Header stylisé avec ton nom
        DrawerHeader(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blueAccent, Color(0xFF1E293B)], begin: Alignment.topLeft)
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: Icon(Icons.auto_awesome, color: Colors.white)),
                const SizedBox(height: 10),
                Text(widget.userName.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ],
            ),
          ),
        ),

        // SECTION : PRÉFÉRENCES (Nouvelle fonctionnalité)
        const ListTile(
          title: Text("VOTRE RYTHME", style: TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        ),
        ListTile(
          leading: const Icon(Icons.timer_outlined, color: Colors.white60),
          title: const Text("Fréquence d'envoi", style: TextStyle(color: Colors.white70)),
          subtitle: const Text("Quotidien (Auto)", style: TextStyle(color: Colors.white24, fontSize: 11)),
          trailing: const Icon(Icons.chevron_right, color: Colors.white24),
          onTap: () => _showFrequencyDialog(), // À implémenter
        ),

        const Divider(color: Colors.white10, indent: 20, endIndent: 20),

        // SECTION : CATÉGORIES (Existante mais optimisée)
        const ListTile(
          title: Text("CATÉGORIES D'INSPIRATION", style: TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: _categories.map((category) => ListTile(
              dense: true,
              leading: Icon(
                _currentCategory == category ? Icons.check_circle : Icons.label_important_outline, 
                color: _currentCategory == category ? Colors.blueAccent : Colors.white24,
                size: 20,
              ),
              title: Text(category, style: TextStyle(color: _currentCategory == category ? Colors.white : Colors.white60)),
              onTap: () => _changeCategory(category),
            )).toList(),
          ),
        ),

        // SECTION : ACTIONS FINALES
        const Divider(color: Colors.white10),
        ListTile(
          leading: const Icon(Icons.bookmark_border, color: Colors.white60),
          title: const Text("Mes Favoris", style: TextStyle(color: Colors.white70)),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.redAccent),
          title: const Text("Quitter la session", style: TextStyle(color: Colors.redAccent)),
          onTap: () => Navigator.pop(context), 
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

    Widget _buildInteractionBar(Quote quote) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _iconActionButton(Icons.favorite_border, "Sauver", () {}),
      const SizedBox(width: 30),
      _iconActionButton(Icons.ios_share, "Partager", () {}),
      const SizedBox(width: 30),
      _iconActionButton(Icons.copy, "Copier", () {}),
    ],
  );
}

Widget _iconActionButton(IconData icon, String label, VoidCallback onTap) {
  return Column(
    children: [
      IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white38, size: 28),
      ),
      Text(label, style: const TextStyle(color: Colors.white24, fontSize: 10)),
    ],
  );
}
  
}