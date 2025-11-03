import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  Pixel({super.key, required this.color, required this.child});

  var child;
  var color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: Text(child.toString(), style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
