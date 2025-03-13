import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class PdfViewerVM extends BaseViewModel {
  PdfViewerVM({required this.url});
  final String url;

  String? localFilePath;


  void onInit() {
    downloadAndSavePdf();
  }

  Future<void> downloadAndSavePdf() async {
    try {
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(bytes);
      localFilePath = file.path;
      rebuildUi();
    } catch (e) {
      debugPrint("Error downloading file: $e");
    }
  }
}