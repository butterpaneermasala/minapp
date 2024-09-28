import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.46.159:5000/predict'; // Replace with your Flask API URL

  Future<String?> predictCondition(String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));

    // Add the file to the request
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      // Decode the response
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);
      return jsonResponse['predicted_class'];
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}
