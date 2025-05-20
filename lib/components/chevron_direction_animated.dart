import 'dart:async';
import 'package:flutter/material.dart';

class ChevronDirectionAnimated extends StatefulWidget {
  const ChevronDirectionAnimated({super.key});

  @override
  State<ChevronDirectionAnimated> createState() =>
      _ChevronDirectionAnimatedState();
}

class _ChevronDirectionAnimatedState extends State<ChevronDirectionAnimated> {
  int _activeIndex = 0;
  late Timer _timer;

  final int chevronCount = 5;
  final Duration interval = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(interval, (timer) {
      setState(() {
        _activeIndex = (_activeIndex + 1) % chevronCount;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color _getChevronColor(int index) {
    if (index == _activeIndex) {
      return Colors.greenAccent.shade200;
    } else {
      return Colors.green.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(chevronCount, (index) {
        return Icon(
          Icons.chevron_right,
          color: _getChevronColor(index),
          size: 32,
        );
      }),
    );
  }
}
