// import 'package:CAA/screens/carrefour_screen.dart';
// import 'package:CAA/views/attempt_connection_view.dart';
import 'package:flutter/material.dart';


class AttemptConnectionView extends StatefulWidget {
  const AttemptConnectionView({
    super.key,
  });

  @override
  State<AttemptConnectionView> createState() => _AttemptConnectionViewState();
}

class _AttemptConnectionViewState extends State<AttemptConnectionView> {
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
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            ),
          ),
          SizedBox(height: 26),
          Text("Patientez", style: TextStyle(fontSize: 22)),
        ],
      ),
    );
  }
}
