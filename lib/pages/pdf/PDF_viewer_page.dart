import 'dart:io';
import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key, required this.url});
  
  final String url;

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
 String? localFilePath;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf();
  }

  Future<void> _downloadAndSavePdf() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(bytes);
      setState(() {
        localFilePath = file.path;
      });
    } catch (e) {
      debugPrint("Error downloading file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
     appBar: const AppTabBarBlue(
      title: "Xem giáo trình",
     ),
      body: localFilePath != null
          ? PDFView(
              filePath: localFilePath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              onError: (error) {
                debugPrint("Error: $error");
              },
            )
          : const Center(child: CircularProgressIndicator(color: AppColor.blue,)),
    );
  }
}
