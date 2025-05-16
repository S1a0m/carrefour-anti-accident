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

class CarrefourScreen extends StatelessWidget {
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
            title: Text('Entrer le numéro de la plaque'),
            leading: Icon(Icons.drive_eta),
            onTap: () {
              Navigator.pop(context);
              // Implémenter l'action ici
            },
          ),
          ListTile(
            title: Text('Changer le numéro'),
            leading: Icon(Icons.edit),
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
                    spacing: 2.0,
                    children: [
                      Text(
                        "C",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.greenAccent),
                      ),
                      Text(
                        "A",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.yellowAccent),
                      ),
                      Text(
                        "A",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            color: Colors.redAccent),
                      ),
                    ],
                  ),
                  /*Row(
                    children: [
                      Text("100 m", style: TextStyle(fontSize: 22)),
                    ],
                  ),*/
                  //Icon(Icons.signal_cellular_alt),
                  /*Text("kit anti-incident",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18))*/
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
              SizedBox(height: 32),
              Text("ROUTE NORD", style: TextStyle(fontSize: 22)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.greenAccent.withOpacity(0.5), width: 3),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Row(
                    spacing: 5.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: const Color.fromARGB(255, 184, 78, 71),
                        size: 30,
                      ),
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
              // Triangle inversé
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
