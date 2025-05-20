import 'package:flutter/material.dart';


class NoCrossRoadAroundView extends StatefulWidget {
  const NoCrossRoadAroundView({
    super.key,
  });

  @override
  State<NoCrossRoadAroundView> createState() => _NoCrossRoadAroundViewState();
}

class _NoCrossRoadAroundViewState extends State<NoCrossRoadAroundView> {
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
