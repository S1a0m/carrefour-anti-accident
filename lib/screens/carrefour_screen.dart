import 'dart:async';
import 'dart:convert';
import 'package:caa/views/attempt_connection_view.dart';
import 'package:caa/views/carrefour_views/alert_cross_road_around_view.dart';
import 'package:caa/views/carrefour_views/no_crossroad_around_view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class CarrefourScreen extends StatefulWidget {
  const CarrefourScreen({super.key});
  @override
  State<CarrefourScreen> createState() => _CarrefourScreenState();
}

class _CarrefourScreenState extends State<CarrefourScreen> {
  String _matricule = "XX ZZ XXXX";
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = 0;
  bool showChevronRight = false;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString('vehicule_info');

    if (jsonData == null) {
      await prefs.setString(
          'vehicule_info', jsonEncode({"matricule": "", "ok": false}));
      _showMatricule(context);
      return;
    }

    final data = jsonDecode(jsonData);
    final String matricule = data['matricule'];
    final bool ok = data['ok'];

    if (!ok) {
      _showMatricule(context);
    } else {
      final response = await http
          .get(Uri.parse('http://192.168.199.114:8000/vehicle/$matricule'));

      if (response.statusCode == 400 || response.statusCode == 422) {
        showError("Un véhicule portant cette plaque n'existe pas.");
        _showMatricule(context);
      } else if (response.statusCode == 200) {
        hideMatricule();
        setState(() => _selectedIndex = 1);
        startGPSCycle();
      }
    }
  }

  Timer? _gpsTimer;

  Future<void> startGPSCycle() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Permission localisation refusée.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Permission localisation refusée définitivement.");
      await Geolocator.openAppSettings();
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Le service de localisation est désactivé.");
      return;
    }

    _gpsTimer?.cancel();
    _gpsTimer = Timer.periodic(Duration(seconds: 5), (_) async {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final response = await http.post(
          Uri.parse('http://192.168.199.114:8000/gps'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "latitude": position.latitude,
            "longitude": position.longitude,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == true) {
            String crossroad = data['crossroad_name'];
            Map<String, dynamic> state = data['state'];
            int trafficLightCycle = state['traffic_light_cycle'];
            DateTime startTime = DateTime.parse(state['create_at']);
            int distanceM = data["distance_m"];

            Map<String, int> colorDurations = {
              "red": state['red_cycle'],
              "orange": state['orange_cycle'],
              "green": state['green_cycle'],
            };

            String beginColor = state['begin_color_cycle'];
            ColorState stateCurrent = getCurrentColor(
              startTime,
              trafficLightCycle,
              colorDurations,
              beginColor,
            );

            bool turnRightAllowed = state['turn_right_if_red'] == true &&
                stateCurrent.color == 'red';

            bool violationFeu = stateCurrent.color == 'red' && distanceM < 0;

            if (violationFeu || distanceM <= 0) {
              if (await Vibration.hasVibrator() ?? false) {
                Vibration.vibrate();
              }
            }

            showChevronRight = turnRightAllowed;

            trafficLightNotifier.value = TrafficLightData(
              stateCurrent,
              showChevronRight,
              crossroad,
              colorDurations,
            );

            if (_selectedIndex != 2) {
              setState(() => _selectedIndex = 2);
            }
          }
        }
      } catch (e) {
        debugPrint("Erreur GPS/post: $e");
      }
    });
  }

  ColorState getCurrentColor(
    DateTime startTime,
    int totalCycle,
    Map<String, int> durations,
    String beginColor,
  ) {
    final now = DateTime.now();
    final secondsSinceStart = now.difference(startTime).inSeconds;
    final cyclePosition = secondsSinceStart % totalCycle;

    // Crée une séquence ordonnée des couleurs
    List<String> colorOrder = ["red", "orange", "green"];
    int startIndex = colorOrder.indexOf(beginColor);
    List<String> orderedColors = [
      ...colorOrder.sublist(startIndex),
      ...colorOrder.sublist(0, startIndex)
    ];

    int elapsed = 0;
    for (var color in orderedColors) {
      int duration = durations[color]!;
      if (cyclePosition < elapsed + duration) {
        return ColorState(color, cyclePosition - elapsed);
      }
      elapsed += duration;
    }

    return ColorState("unknown", 0);
  }

  Future<void> verifyMatricule(String inputMatricule) async {
    final verifyResponse = await http.get(Uri.parse(
        'http://192.168.199.114:8000/vehicle/plate_number/$inputMatricule'));

    if (verifyResponse.statusCode != 200) {
      showError("Erreur de vérification.");
      return;
    }

    final verifyData = jsonDecode(verifyResponse.body);
    if (verifyData['found'] == false) {
      showError("Aucun véhicule ne possède cette plaque");
      return;
    }

    showInfo("Nous venons de vous envoyer un message de confirmation...");
    setState(() => _selectedIndex = 0); // Affiche AttemptConnectionView

    bool permitted = false;
    int attempts = 0;

    while (attempts < 10) {
      await Future.delayed(Duration(seconds: 10));

      final confirmResponse = await http.get(
          Uri.parse('http://192.168.199.114:8000/vehicle/$inputMatricule'));

      if (confirmResponse.statusCode == 200) {
        final confirmData = jsonDecode(confirmResponse.body);
        permitted = confirmData['permitted'];
        if (permitted) break;
      }

      attempts++;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vehicule_info',
        jsonEncode({"matricule": inputMatricule, "ok": permitted}));

    if (permitted) {
      hideMatricule();
      setState(() => _selectedIndex = 1); // Affiche NoCrossRoadAroundView
      startGPSCycle();
    } else {
      showError("Confirmation non reçue ou refusée.");
    }
  }

  void showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void hideMatricule() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

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

  Future<void> _showMatricule(BuildContext context) async {
    _controller.text = _matricule;
    final prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString('vehicule_info');

    String plate_number = "";

    if (jsonData != null) {
      final data = jsonDecode(jsonData);
      plate_number = data['matricule'] ?? "";
    }

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
            Text("N° actuel : $plate_number", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Entrer nouveau matricule',
                labelStyle: TextStyle(color: Colors.greenAccent),
                hintText: 'Ex: XX YY ZZZZZ',
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
                verifyMatricule(_matricule);
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
            leading: Icon(Icons.gavel, color: Colors.orangeAccent),
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
                  Image.asset(
                    "assets/icons/caa_icon.png",
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
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
                              fontSize: 18,
                              color: Colors.orangeAccent)),
                      SizedBox(width: 2),
                      Text("A",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: Colors.redAccent)),
                    ],
                  ),
                  // Icon(Icons.gps_not_fixed_rounded),
                ],
              ),
              SizedBox(height: 50),
              _getSelectedView(_selectedIndex),
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

class ColorState {
  final String color;
  final int elapsed;

  ColorState(this.color, this.elapsed);
}

class TrafficLightData {
  final ColorState colorState;
  final bool showChevronRight;
  final String crossroadName;
  final Map<String, int> colorDurations;

  TrafficLightData(this.colorState, this.showChevronRight, this.crossroadName,
      this.colorDurations);
}

final ValueNotifier<TrafficLightData?> trafficLightNotifier =
    ValueNotifier(null);
