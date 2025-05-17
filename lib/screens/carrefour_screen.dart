import 'package:flutter/material.dart';

class CarrefourScreen extends StatefulWidget {
  const CarrefourScreen({super.key});
  @override
  State<CarrefourScreen> createState() => _CarrefourScreenState();
}

class _CarrefourScreenState extends State<CarrefourScreen> {
  String _matricule = "BP 503 C4";
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = 0;

  Widget _getSelectedView(int index) {
    switch (index) {
      case 0:
        return const AttemptConnectionView(key: ValueKey('connection'));
      case 1:
        return const NoCrossRoadAroundView(key: ValueKey('noalert'));
      case 2:
        return const AlertCrossRoadAroundView(key: ValueKey('alert'));
      default:
        return const AttemptConnectionView(key: ValueKey('connection'));
    }
  }

  void _showMatricule(BuildContext context) {
    _controller.text = _matricule;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Matricule de la plaque',
            style: TextStyle(color: Colors.greenAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("N° actuel : $_matricule", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Entrer nouveau matricule',
                labelStyle: TextStyle(color: Colors.greenAccent),
                hintText: 'Ex: BP 503 C4',
                hintStyle: TextStyle(color: Colors.white24),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.withOpacity(0.5),
              ),
              onPressed: () {
                setState(() {
                  _matricule = _controller.text;
                });
                Navigator.pop(context);
              },
              child: Text("Changer"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer',
                style:
                    TextStyle(color: const Color.fromARGB(255, 184, 78, 71))),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Numéro de la plaque'),
            leading: Icon(Icons.drive_eta, color: Colors.greenAccent),
            onTap: () {
              Navigator.pop(context);
              _showMatricule(context);
            },
          ),
          ListTile(
            title: Text('Sanctions'),
            leading: Icon(Icons.gavel, color: Colors.yellowAccent),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/sanctions');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("C",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Colors.greenAccent)),
                      SizedBox(width: 2),
                      Text("A",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Colors.yellowAccent)),
                      SizedBox(width: 2),
                      Text("A",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: Colors.redAccent)),
                    ],
                  ),
                  Icon(Icons.signal_cellular_alt_rounded),
                ],
              ),
              SizedBox(height: 50),
              NoCrossRoadAroundView(),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white70, width: 1),
                ),
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.arrow_drop_up_rounded,
                    size: 50,
                    color: Colors.white70,
                  ),
                  onPressed: () => _showMenu(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertCrossRoadAroundView extends StatelessWidget {
  const AlertCrossRoadAroundView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Carrefour B à 100 mètres", style: TextStyle(fontSize: 26)),
          SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.greenAccent.withOpacity(0.5), width: 3),
            ),
            child: Container(
              width: 330,
              height: 330,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.greenAccent, width: 50),
              ),
              child: Center(
                child: Text(
                  "27",
                  style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 26),
          Icon(Icons.arrow_circle_right_outlined),
          /* SizedBox(height: 26),
            Text("ROUTE NORD", style: TextStyle(fontSize: 22)),*/
          SizedBox(height: 26),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.greenAccent.withOpacity(0.5), width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: const Color.fromARGB(255, 184, 78, 71), size: 30),
                  SizedBox(width: 5),
                  Text("CÉDEZ LE PASSAGE",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        //color: Colors.greenAccent
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoCrossRoadAroundView extends StatelessWidget {
  const NoCrossRoadAroundView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Aucun carrefour à proximité",
              style: TextStyle(fontSize: 26, color: Colors.white10)),
          SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10, width: 3),
            ),
            child: Container(
              width: 330,
              height: 330,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10, width: 50),
              ),
              child: Center(
                child: Text(
                  "00",
                  style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Colors.white10),
                ),
              ),
            ),
          ),
          /* SizedBox(height: 26),
            Text("ROUTE NORD", style: TextStyle(fontSize: 22)),*/
          SizedBox(height: 52),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white10, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.signal_cellular_alt,
                      color: Colors.white10, size: 30),
                  SizedBox(width: 5),
                  Text("CONNECTÉ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white10
                          //color: Colors.greenAccent
                          )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AttemptConnectionView extends StatelessWidget {
  const AttemptConnectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Connexion en cours...", style: TextStyle(fontSize: 26)),
          SizedBox(height: 32),
          Container(
            width: 330,
            height: 330,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10, width: 50),
            ),
          ),

          /* SizedBox(height: 26),
            Text("ROUTE NORD", style: TextStyle(fontSize: 22)),*/
        ],
      ),
    );
  }
}


/**Tu vois ceci:
Icon(Icons.arrow\_circle\_right\_outlined)? Je l'avais mis sur carrefour\_screen.dart. Mais c'est pas ça je souhaitais avant. Ce que je souhaitais c'est les flèches de directions qui s'animent souvent sur les voix ou les grands centre pour indiquer une direction droite et se présentent comme ça souvent: ">>>>". Peut tu m'en  faire un qui s'anime si tu as compris?  Ce qu'il faut animer c'est chaque chevrons qui passent d'un vert sombre à un vert clair de manière continue de la gauche vers la droite. As-tu compris? Si oui, lance toi.
 */