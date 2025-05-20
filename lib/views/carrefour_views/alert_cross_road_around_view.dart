
/*import 'package:CAA/components/chevron_direction_animated.dart';
import 'package:flutter/material.dart';


class ColorState {
  final String color;
  final int elapsed;

  ColorState(this.color, this.elapsed);
}

class TrafficLightData {
  final ColorState colorState;
  final bool showChevronRight;

  TrafficLightData(this.colorState, this.showChevronRight);
}

class AlertCrossRoadAroundView extends StatefulWidget {
  const AlertCrossRoadAroundView({
    super.key,
  });

  @override
  State<AlertCrossRoadAroundView> createState() => _AlertCrossRoadAroundViewState();
}

class _AlertCrossRoadAroundViewState extends State<AlertCrossRoadAroundView> {
  bool showChevronRight = false;
  

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<TrafficLightData?>(
    valueListenable: trafficLightNotifier,
    builder: (context, trafficData, child) {
      if (trafficData == null) {
        return Text("Chargement...");
      }

      Color borderColor;
      switch (trafficData.colorState.color) {
        case 'red':
          borderColor = Colors.redAccent;
          break;
        case 'orange':
          borderColor = Colors.orangeAccent;
          break;
        case 'green':
          borderColor = Colors.greenAccent;
          break;
        default:
          borderColor = Colors.transparent;
      }

    return Container(
      child: Column(
        children: [
          Text("Carrefour B à 100 mètres", style: TextStyle(fontSize: 26)),
          SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: borderColor.withOpacity(0.5), width: 3),
            ),
            child: Container(
              width: 330,
              height: 330,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 50),
              ),
              child: Center(
                child: Text(
                  "${trafficData.colorState.elapsed}",
                  style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 26),
          if (showChevronRight) ChevronDirectionAnimated(),

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
                mainAxisAlignment: MainAxisAlignmtrafficData.showChevronRightent.center,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.redAccent, size: 30),
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
*/

import 'package:caa/components/chevron_direction_animated.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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

  TrafficLightData(this.colorState, this.showChevronRight, this.crossroadName, this.colorDurations);
}

final ValueNotifier<TrafficLightData?> trafficLightNotifier = ValueNotifier(null);

class AlertCrossRoadAroundView extends StatefulWidget {
  const AlertCrossRoadAroundView({super.key});

  @override
  State<AlertCrossRoadAroundView> createState() => _AlertCrossRoadAroundViewState();
}

class _AlertCrossRoadAroundViewState extends State<AlertCrossRoadAroundView> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TrafficLightData?>(
      valueListenable: trafficLightNotifier,
      builder: (context, trafficData, child) {
        if (trafficData == null) {
          return Text("Chargement...");
        }

        final colorState = trafficData.colorState;
        final durationInColor = _getDurationForColor(colorState.color);
        final progress = colorState.elapsed / durationInColor;

        final Color targetColor = _getColorFromName(colorState.color);

        return Column(
          children: [
            Text("Carrefour ${trafficData.crossroadName} à 200 mètres", style: TextStyle(fontSize: 26)),
            SizedBox(height: 32),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: Duration(milliseconds: 500),
              builder: (context, value, _) {
                return CustomPaint(
                  painter: _CircularProgressPainter(
                    progress: value,
                    color: targetColor,
                  ),
                  child: Container(
                    width: 330,
                    height: 330,
                    alignment: Alignment.center,
                    child: Text(
                      "${colorState.elapsed}",
                      style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 26),
            if (trafficData.showChevronRight) ChevronDirectionAnimated(),
            SizedBox(height: 26),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent.withOpacity(0.5), width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 30),
                  SizedBox(width: 5),
                  Text(_messageFromColor(targetColor), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.redAccent;
      case 'orange':
        return Colors.orangeAccent;
      case 'green':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  int _getDurationForColor(String colorName) {
    final data = trafficLightNotifier.value;
    if (data == null) return 1;
    return data.colorDurations[colorName] ?? 1;
  }

  String _messageFromColor(Color colorValue) {
    switch (colorValue) {
      case Colors.redAccent:
        return "ARRÊT";
      case Colors.orangeAccent:
        return "PATIENCE";
      case Colors.greenAccent:
        return "RAS";
      default:
        return "";
    }
  }
}


// Panneau de progression circulaire
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 50.0;
    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Background
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Foreground progress
    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
