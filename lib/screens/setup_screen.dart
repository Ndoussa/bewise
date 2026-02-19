import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedCategory = 'Motivation';
  
  final List<String> categories = ['Motivation', 'Sagesse', 'Succès', 'Bonheur', 'Zen'];

  // Fonction pour sauvegarder les infos et passer à la suite
  void _saveAndContinue() async {
    if (_nameController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
      await prefs.setString('userCategory', _selectedCategory);
      await prefs.setBool('isFirstTime', false);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userName: _nameController.text)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF0F2027), Color(0xFF2C5364)], begin: Alignment.topCenter),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Bienvenue,", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const Text("Comment t'appelles-tu ?", style: TextStyle(color: Colors.white70, fontSize: 18)),
              const SizedBox(height: 20),
              
              // Input Design
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  hintText: "Ton prénom",
                  hintStyle: const TextStyle(color: Colors.white30),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              
              const SizedBox(height: 40),
              const Text("Qu'est-ce qui t'inspire ?", style: TextStyle(color: Colors.white70, fontSize: 18)),
              const SizedBox(height: 15),

              // Liste des catégories (Chips animées)
              Wrap(
                spacing: 10,
                children: categories.map((cat) {
                  bool isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedCategory = cat),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.white10,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white60),
                  );
                }).toList(),
              ),

              const SizedBox(height: 50),
              
              // Bouton Commencer
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("COMMENCER", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}