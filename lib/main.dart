import 'package:flutter/material.dart';
import 'audio_upload.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Upload App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioUploadScreen(),
    );
  }
}
