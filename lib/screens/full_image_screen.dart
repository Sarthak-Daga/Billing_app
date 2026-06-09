import 'dart:io';
import 'package:flutter/material.dart';

class FullImageScreen extends StatelessWidget {
  final String imagePath;

  const FullImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,

          child: Image.file(File(imagePath)),
        ),
      ),
    );
  }
}
