import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeProvider extends ChangeNotifier {
  static const String baseUrl = "https://api.stability.ai";
  Uint8List? imageData;
  Future<void> textToImage(String prompt) async {
    const apiKey = "Your-API-Key"; // Your API Key
    const apiHost = "v2beta/stable-image";

    final response = await http.post(
      Uri.parse("$baseUrl/$apiHost/generate/ultra"),
      headers: {"Authorization": "Bearer $apiKey", "Accept": "image/*"},
      body: jsonEncode({
        "prompt": prompt,
        "output_format": "webp",
      }),
    );

    if (response.statusCode == 200) {
      imageData = response.bodyBytes;
      notifyListeners();
    } else {
      debugPrint("Error: ${response.body}");
    }
  }
}
