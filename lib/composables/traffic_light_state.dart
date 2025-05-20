enum CouleurFeu { rouge, orange, vert }

class FeuTricolore {
  final double installationTimestamp; // en secondes
  final int dureeRouge;
  final int dureeOrange;
  final int dureeVert;
  final CouleurFeu couleurInitiale;

  FeuTricolore({
    required this.installationTimestamp,
    required this.dureeRouge,
    required this.dureeOrange,
    required this.dureeVert,
    required this.couleurInitiale,
  });

  /// couleur actuelle (CouleurFeu)
  /// temps (en secondes) écoulé dans cette couleur
  Map<String, dynamic> couleurEtPosition(double maintenantTimestamp) {
    final dureeCycle = dureeRouge + dureeOrange + dureeVert;
    final secondesDepuisInstallation =
        maintenantTimestamp - installationTimestamp;

    final positionCycle = secondesDepuisInstallation % dureeCycle;

    final ordre = _ordreCycle();

    double cumul = 0;
    for (final couleur in ordre) {
      final duree = _dureePourCouleur(couleur).toDouble();
      if (positionCycle < cumul + duree) {
        final positionDansCouleur = positionCycle - cumul;
        return {
          'couleur': couleur,
          'position': positionDansCouleur,
        };
      }
      cumul += duree;
    }

    throw Exception("Erreur dans le calcul de la position.");
  }

  List<CouleurFeu> _ordreCycle() {
    switch (couleurInitiale) {
      case CouleurFeu.rouge:
        return [CouleurFeu.rouge, CouleurFeu.vert, CouleurFeu.orange];
      case CouleurFeu.vert:
        return [CouleurFeu.vert, CouleurFeu.orange, CouleurFeu.rouge];
      case CouleurFeu.orange:
        return [CouleurFeu.orange, CouleurFeu.rouge, CouleurFeu.vert];
    }
  }

  int _dureePourCouleur(CouleurFeu couleur) {
    switch (couleur) {
      case CouleurFeu.rouge:
        return dureeRouge;
      case CouleurFeu.orange:
        return dureeOrange;
      case CouleurFeu.vert:
        return dureeVert;
    }
  }
}
