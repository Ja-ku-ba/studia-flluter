import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  var color;
  var pixelSize;
  Pixel({
    super.key,
    required this.color,
    required this.pixelSize,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: pixelSize,
        maxHeight: pixelSize,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black),
        ),
        margin: const EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
          margin: const EdgeInsets.all(3),
        ),
      ),
    );
  }
}