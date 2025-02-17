import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/pages/pdf/PDF_viewer_vm.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:stacked/stacked.dart';

class PdfViewerPage extends StackedView<PdfViewerVM> {
  const PdfViewerPage({super.key, required this.url});
  final String url;

  @override
  PdfViewerVM viewModelBuilder(BuildContext context) => PdfViewerVM(url: url);

  @override
  void onViewModelReady(PdfViewerVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  Widget builder(BuildContext context, PdfViewerVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(
        title: "Xem giáo trình",
      ),
      body: viewModel.localFilePath != null
          ? PDFView(
              filePath: viewModel.localFilePath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              onError: (error) {
                debugPrint("Error: $error");
              },
            )
          : const Center(
              child: CircularProgressIndicator(
              color: AppColor.blue,
            )),
    );
  }
}
