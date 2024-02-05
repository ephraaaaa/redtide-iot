// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;

Future<void> generateReport() async {
  try {
    // Make an HTTP POST request to your Flask server
    final response = await http.post(
      Uri.parse(
          'https://redtidemonitoringsystemserver.click/server/generate-report'),
    );

    if (response.statusCode == 200) {
      print('Report generation successful');
    } else {
      print('Failed to generate report. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
