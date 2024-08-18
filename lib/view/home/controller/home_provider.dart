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

    final request = http.MultipartRequest(
        "Post", Uri.parse("$baseUrl/$apiHost/generate/ultra"))
      ..headers['Authorization'] = "Bearer $apiKey"
      ..headers["Accept"] = "image/*"
      ..fields["prompt"] = prompt;
      // ..fields["output_format"] = "jpeg/png/jpg";

    

    final response = await request.send();

    if (response.statusCode == 200) {
      imageData = await response.stream.toBytes();
      notifyListeners();
    } else {
      debugPrint("Error: ${response.statusCode}");
    }

    loadingUpdate(false);
  }
}
