import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart'; // Import file_picker
import 'dart:io';

class AudioUploadScreen extends StatefulWidget {
  @override
  _AudioUploadScreenState createState() => _AudioUploadScreenState();
}

class _AudioUploadScreenState extends State<AudioUploadScreen> {
  String? _prediction;

  Future<void> uploadAudioFile() async {
    // Use FilePicker to pick audio file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String apiUrl = "http://192.168.46.159:5000/predict"; // Replace with your Flask server URL

      try {
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.files.add(await http.MultipartFile.fromPath('file', file.path));

        var response = await request.send();
        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseData);
          setState(() {
            _prediction = jsonResponse['predicted_class'];
          });
        } else {
          print('Failed to upload: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('No file selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: uploadAudioFile,
              child: Text('Upload Audio File'),
            ),
            SizedBox(height: 20),
            if (_prediction != null)
              Text(
                'Prediction: $_prediction',
                style: TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}
