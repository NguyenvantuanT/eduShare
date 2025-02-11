import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/learning_progress_services.dart';
import 'package:chat_app/services/remote/lesson_services.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({
    super.key,
    required this.docIdCourse,
    required this.index,
    this.updateProg,
  });

  final String docIdCourse;
  final int index;
  final VoidCallback? updateProg;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  LearningProgressServices learProgServices = LearningProgressServices();
  LearningProgressModel learProg = LearningProgressModel();
  LessonServices lessonServices = LessonServices();

  YoutubePlayerController? controller;
  LessonModel lesson = LessonModel();
  List<LessonModel> lessons = [];

  late int lessonIndex;
  String email = SharedPrefs.user?.email ?? '';

  List<String> tabNames = ['Information', 'Lessons'];
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    lessonIndex = widget.index;
    getVideo();
  }

  void getProgress() {
    learProgServices
        .getLessonProgress(
            docIdCourse: widget.docIdCourse, lessonId: lesson.lessonId)
        .then((value) {
      if (value == null) {
        learProg = LearningProgressModel(isCompleted: false, progress: 0.0);
        learProgServices.createLessonProgress(
          docIdCourse: widget.docIdCourse,
          lessonId: lesson.lessonId,
          value: learProg,
        );
        setState(() {});
      }
      learProg = value ?? LearningProgressModel();
      setState(() {});
    });
  }

  void getVideo() {
    lessonServices.getLessons(widget.docIdCourse).then((values) {
      lessons = values;
      lesson = lessons[lessonIndex];

      getProgress();

      controller = YoutubePlayerController(
        initialVideoId: lesson.videoPath!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          loop: false,
        ),
      )..addListener(updateProgress);

      setState(() {});
    }).catchError((onError) {
      debugPrint('Lỗi khi tải video: $onError');
    });
  }

  void updateProgress() {
    if (controller == null) return;
    if (controller!.metadata.duration.inSeconds == 0) return;

    final duration = controller!.metadata.duration.inSeconds;
    final position = controller!.value.position.inSeconds;

    double progress = position / duration;

    setState(() {
      learProg.progress = progress;
    });
    widget.updateProg?.call();
    saveProgress(progress);
  }

  void saveProgress(double progress) {
    if (lesson.lessonId == null || widget.docIdCourse.isEmpty) return;

    bool isCompleted = progress >= 0.9;

    LearningProgressModel updatedProgress = LearningProgressModel(
      progress: progress,
      isCompleted: isCompleted,
    );

    learProgServices
        .updateLessonProgress(
          docIdCourse: widget.docIdCourse,
          lessonId: lesson.lessonId ?? '',
          value: updatedProgress,
        )
        .then((_) {})
        .catchError((error) {
      debugPrint('Lỗi khi lưu tiến độ: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBar(
        backgroundColor: AppColor.bgColor,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: const Icon(Icons.arrow_back_ios_new,
              size: 22.0, color: AppColor.textColor),
        ),
        title: Text(
          lesson.name ?? '',
          style: AppStyles.STYLE_24.copyWith(color: AppColor.textColor),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Stack(
            children: [
              Positioned.fill(
                child: controller == null
                    ? _loadingVideo()
                    : YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: controller!,
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
              _informationPositioned(),
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

  Widget _informationPositioned() {
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
              children: List.generate(tabNames.length, (idx) {
                final tabName = tabNames[idx];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectIndex = idx),
                    child: Container(
                      height: 45.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: idx == selectIndex
                            ? AppColor.blue
                            : Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Text(tabName,
                          style: AppStyles.STYLE_14.copyWith(
                            color: idx == selectIndex
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
            index: selectIndex,
            children: [
              _buildInformation(),
              _buildLessonTab(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10.0),
        Text(
          'Tiến độ: ',
          style: AppStyles.STYLE_14.copyWith(
            color: AppColor.black,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10.0),
        LinearProgressIndicator(
          value: learProg.progress ?? 0.0,
          backgroundColor: AppColor.grey,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColor.blue),
        ),
        const SizedBox(height: 10.0),
        Text(
          'Description ',
          style: AppStyles.STYLE_16.copyWith(
            color: AppColor.black,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4.6),
        Text(
          textAlign: TextAlign.center,
          lesson.description ?? '-:-',
          style: AppStyles.STYLE_14.copyWith(
            color: AppColor.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildLessonTab() {
    return Column(
      children: List.generate(
        lessons.length,
        (index) => GestureDetector(
          onTap: () {
            lessonIndex = index;
            lesson = lessons[lessonIndex];
            controller?.load(lesson.videoPath!);
            setState(() {});
          },
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
                    'Lesson ${index + 1}: ${lessons[index].name}',
                    style: AppStyles.STYLE_14.copyWith(
                      color: lessonIndex == index
                          ? AppColor.textColor
                          : AppColor.greyText,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.play_circle,
                      color:
                          lessonIndex == index ? AppColor.blue : AppColor.grey),
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
