import 'package:flutter/material.dart';

class SanctionsScreen extends StatelessWidget {
  const SanctionsScreen({super.key});

  final List<Map<String, String>> sanctions = const [
    {
      'titre': 'Non-respect du feu rouge',
      'description':
          'Amende de 10 000 FCFA et retrait de 2 points sur le permis.'
    },
    {
      'titre': 'Franchissement du feu orange sans ralentir',
      'description': 'Avertissement et sensibilisation obligatoire.'
    },
    {
      'titre': 'Refus d’obtempérer à un feu clignotant',
      'description': 'Amende de 15 000 FCFA et immobilisation du véhicule.'
    },
    {
      'titre': 'Ignorer les signaux lumineux en zone scolaire',
      'description': 'Amende de 20 000 FCFA et suspension temporaire du permis.'
    },
    {
      'titre': 'Utilisation abusive du klaxon à un feu rouge',
      'description': 'Amende de 5 000 FCFA.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Bouton de retour personnalisé
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sanctions liées aux feux tricolores',
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: sanctions.length,
                  itemBuilder: (context, index) {
                    final sanction = sanctions[index];
                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sanction['titre']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              sanction['description']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
