import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeProvider extends ChangeNotifier {
  static const String baseUrl = "https://api.stability.ai";
  Uint8List? imageData;
  final textController = TextEditingController();
  bool isLoading = false;

  void loadingUpdate(bool v) {
    isLoading = v;
    notifyListeners();
  }

  void removeImage() {
    imageData = null;
    notifyListeners();
  }

  Future<void> textToImage() async {
    const apiKey = ""; // Your API Key
    const apiHost = "v2beta/stable-image";

    String prompt = textController.text;
    if (prompt.isEmpty) {
      loadingUpdate(false);
      return;
    }

    final response = await http.post(
      Uri.parse("$baseUrl/$apiHost/generate/ultra"),
      headers: {"Authorization": "Bearer $apiKey", "Accept": "image/*", },
      
      body: {
        "prompt": prompt,
        "output_format": "jpeg/png/jpg",
      },
    );

    if (response.statusCode == 200) {
      imageData = response.bodyBytes;
      notifyListeners();
    } else {
      debugPrint("Error: ${response.body}");
    }

    loadingUpdate(false);
  }
}
