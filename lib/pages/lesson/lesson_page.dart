import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/pages/lesson/lesson_vm.dart';
import 'package:chat_app/pages/pdf/PDF_viewer_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonPage extends StackedView<LessonVM> {
  const LessonPage({
    super.key,
    required this.docIdCourse,
    required this.index,
    this.updateProg,
  });

  @override
  void onViewModelReady(LessonVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  final String docIdCourse;
  final int index;
  final VoidCallback? updateProg;

  @override
  LessonVM viewModelBuilder(BuildContext context) {
    return LessonVM(
      docIdCourse: docIdCourse,
      index: index,
      updateProg: updateProg,
    );
  }

  @override
  Widget builder(BuildContext context, LessonVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppTabBarBlue(
        title: viewModel.lesson.name ?? '',
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: [
              Positioned.fill(
                child: viewModel.controller == null
                    ? _loadingVideo()
                    : YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: viewModel.controller!,
                          onReady: () {},
                          onEnded: (_) {},
                        ),
                        builder: (context, player) {
                          return Column(
                            children: [
                              player,
                            ],
                          );
                        },
                        onEnterFullScreen: () {},
                        onExitFullScreen: () {},
                      ),
              ),
              _informationPositioned(context, viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _loadingVideo() {
    return Center(
      child: Container(
        height: 70.0,
        width: 70.0,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
            color: AppColor.grey,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: const CircularProgressIndicator(
          color: AppColor.black,
        ),
      ),
    );
  }

  Widget _informationPositioned(BuildContext context, LessonVM viewModel) {
    return Positioned(
      left: 20.0,
      top: 230.0,
      right: 20.0,
      bottom: 20.0,
      child: ListView(
        children: [
          Container(
            height: 50.0,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColor.blue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: List.generate(viewModel.tabNames.length, (idx) {
                final tabName = viewModel.tabNames[idx];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => viewModel.changeIndex(idx),
                    child: Container(
                      height: 45.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: idx == viewModel.selectIndex
                            ? AppColor.blue
                            : Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Text(tabName,
                          style: AppStyles.STYLE_14.copyWith(
                            color: idx == viewModel.selectIndex
                                ? AppColor.white
                                : AppColor.textColor,
                          )),
                    ),
                  ),
                );
              }),
            ),
          ),
          IndexedStack(
            index: viewModel.selectIndex,
            children: [
              _buildInformation(context, viewModel),
              _buildLessonTab(viewModel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInformation(BuildContext context, LessonVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10.0),
        Text(
          'Tiến độ: ',
          style: AppStyles.STYLE_16.copyWith(
            color: AppColor.black,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10.0),
        LinearProgressIndicator(
          value: viewModel.learProg.progress ?? 0.0,
          backgroundColor: AppColor.grey,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColor.blue),
        ),
        if (viewModel.lesson.filePath != null) ...[
          const SizedBox(height: 10.0),
          Text(
            'File: ',
            style: AppStyles.STYLE_16.copyWith(
              color: AppColor.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.start,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PdfViewerPage(
                      url: viewModel.lesson.filePath!,
                    ))),
            child: Container(
              height: 50.0,
              margin: const EdgeInsets.only(top: 5.0),
              decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: AppShadow.boxShadowContainer),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppImages.iconFile,
                    color: AppColor.blue,
                    height: 22.0,
                    width: 22.0,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    '${viewModel.lesson.fileName}',
                    style:
                        AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    AppImages.icArrowRightBig,
                    height: 22.0,
                    width: 22.0,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 10.0),
        Text(
          'Description ',
          style: AppStyles.STYLE_16.copyWith(
            color: AppColor.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4.6),
        Text(
          viewModel.lesson.description ?? '-:-',
          style: AppStyles.STYLE_14.copyWith(
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildLessonTab(LessonVM viewModel) {
    return Column(
      children: List.generate(
        viewModel.lessons.length,
        (index) => GestureDetector(
          onTap: viewModel.changeLesson,
          child: Container(
            height: 50.0,
            margin: const EdgeInsets.only(top: 20.0),
            padding: const EdgeInsets.only(left: 15.0),
            decoration: const BoxDecoration(
              color: AppColor.bgColor,
              boxShadow: AppShadow.boxShadowContainer,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Lesson ${index + 1}: ${viewModel.lessons[index].name}',
                    style: AppStyles.STYLE_14.copyWith(
                      color: viewModel.lessonIndex == index
                          ? AppColor.textColor
                          : AppColor.greyText,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.play_circle,
                      color: viewModel.lessonIndex == index
                          ? AppColor.blue
                          : AppColor.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
