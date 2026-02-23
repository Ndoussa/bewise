import 'package:flutter/material.dart';
import 'home_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedCategory = "Motivation"; // Valeur par défaut pour éviter le vide
  final List<String> _categories = ["Motivation", "Sagesse", "Discipline", "Succès", "Sport", "Amour"];

  void _startJourney() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer votre nom pour continuer")),
      );
      return;
    }

    // Navigation vers HomeScreen avec les données sécurisées
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          userName: _nameController.text.trim(),
          initialCategory: _selectedCategory, category: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 30),
            const Text(
              "BIENVENUE SUR BEWISE",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            const Text(
              "Préparez votre esprit pour aujourd'hui",
              style: TextStyle(color: Colors.white30),
            ),
            const SizedBox(height: 50),
            
            // Champ Nom
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Comment t'appelles-tu ?",
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.person_outline, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 20),
            
            // Sélecteur de Catégorie
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1E293B),
                  items: _categories.map((String cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value!);
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Bouton de validation
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _startJourney,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("DÉCOUVRIR MON INSPIRATION", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}