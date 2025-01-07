import 'package:chat_app/components/app_show_modal_bottom.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/lesson_services.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({
    super.key,
    required this.docIdCourse,
    required this.index,
  });

  final String docIdCourse;
  final int index;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  LessonServices lessonServices = LessonServices();
  YoutubePlayerController? controller;
  LessonModel lesson = LessonModel();
  List<LessonModel> lessons = [];
  late int lessonIndex;

  @override
  void initState() {
    super.initState();
    getVideo();
    lessonIndex = widget.index;
  }

  void getVideo() {
    lessonServices.getVideos(widget.docIdCourse).then((values) {
      lessons = values;
      lesson = lessons[lessonIndex];
      controller = YoutubePlayerController(
        initialVideoId: lesson.videoPath!,
        flags: const YoutubePlayerFlags(),
      );
      setState(() {});
    }).catchError((onError) {
      debugPrint('object $onError');
    });
    ;
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
      bottom: 56.0,
      child: ListView(
        children: [
          Text(
            'All Lessons',
            style: AppStyles.STYLE_16_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 15.0),
          GestureDetector(
            onTap: () {
              AppShowModalBottom.showAllLesson(context, lessons, lessonIndex);
            },
            child: Container(
              height: 48.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: AppColor.white,
                border: Border.all(color: AppColor.grey, width: 1.2),
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Lesson $lessonIndex : ',
                      style: AppStyles.STYLE_14.copyWith(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4.0),
                  Text(lesson.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.STYLE_14
                          .copyWith(color: AppColor.textColor)),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColor.grey,
                    size: 30.0,
                  )
                ],
              ),
            ),
          ),
          _buildLessonTab(),
          const SizedBox(height: 15.0),
          Row(
            children: [
              Text('Duration: ',
                  style: AppStyles.STYLE_14.copyWith(
                    color: AppColor.textColor,
                  )),
              const SizedBox(width: 4.6),
              Text('10h',
                  style: AppStyles.STYLE_14.copyWith(
                    color: AppColor.textColor,
                  )),
            ],
          ),
          const SizedBox(height: 10.0),
          const Text(
            '------ Description ------',
            style: TextStyle(
                color: AppColor.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.6),
          Text(
            lesson.description ?? '-:-',
            style: const TextStyle(
              color: AppColor.black,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  GridView _buildLessonTab() {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 6.8,
        crossAxisSpacing: 0.0,
        mainAxisExtent: 20.0,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: List.generate(
        lessons.length,
        (index) => GestureDetector(
          onTap: () {
            lessonIndex = index;
            lesson = lessons[lessonIndex];
            controller?.load(lesson.videoPath!);
            setState(() {});
          },
          child: Text(
            'Lesson ${index + 1}',
            style: AppStyles.STYLE_14.copyWith(
                color:
                    index == lessonIndex ? AppColor.textColor : AppColor.grey,
                fontWeight:
                    index == lessonIndex ? FontWeight.w600 : FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
