import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrefour B',
      theme: ThemeData.dark(),
      home: CarrefourScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CarrefourScreen extends StatefulWidget {
  @override
  _CarrefourScreenState createState() => _CarrefourScreenState();
}

class _CarrefourScreenState extends State<CarrefourScreen> {
  String _matricule = "BP 503 C4";
  final TextEditingController _controller = TextEditingController();

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
                backgroundColor: Colors.greenAccent.withOpacity(0.2),
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
            child: Text('Fermer', style: TextStyle(color: Colors.white70)),
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
              // Implémenter l'action ici
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
              // Haut de l'écran
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
                  Icon(Icons.directions),
                ],
              ),
              SizedBox(height: 50),
              Text("Carrefour B à 100 mètres", style: TextStyle(fontSize: 26)),
              SizedBox(height: 32),
              // Cercle avec bordure épaisse
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
                      style:
                          TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 26),
              Icon(Icons.arrow_circle_right_outlined),
              SizedBox(height: 26),
              Text("ROUTE NORD", style: TextStyle(fontSize: 22)),
              SizedBox(height: 10),
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
                          color: const Color.fromARGB(255, 184, 78, 71),
                          size: 30),
                      SizedBox(width: 5),
                      Text("CÉDEZ LE PASSAGE",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.greenAccent)),
                    ],
                  ),
                ),
              ),
              Spacer(),
              // Triangle inversé (menu)
              IconButton(
                icon: Icon(Icons.arrow_drop_down, size: 70),
                onPressed: () => _showMenu(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
