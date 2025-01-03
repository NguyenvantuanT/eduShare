import 'dart:io';

import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MakeLessonPage extends StatefulWidget {
  const MakeLessonPage({super.key, required this.video});

  final String video;

  @override
  State<MakeLessonPage> createState() => _MakeLessonPageState();
}

class _MakeLessonPageState extends State<MakeLessonPage> {
  final nameLessonsController = TextEditingController();
  final describeController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  bool isLoading = false;
  File? videoFile;
  VideoPlayerController? videoController;

  Future<void> pickVideo() async {
    setState(() => isLoading = true);
    try {
      final video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        videoFile = File(video.path);
        await videoController?.dispose();
        videoController = VideoPlayerController.file(videoFile!);
        await videoController!.initialize();
        await videoController!.play();
      }
    } catch (e) {
      print('Error picking video: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video));
    _controller.initialize().then((_) {
      _controller.play();
      _controller.setLooping(true);
      setState(() {});
    });
  }

  @override
  void dispose() {
    videoController?.dispose();
    nameLessonsController.dispose();
    describeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Text(
            'Name Your Lesson?',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          AppTextField(
            controller: nameLessonsController,
            labelText: "e.g., lesson ...",
            textInputAction: TextInputAction.next,
            validator: Validator.required,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Description ?',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          _buildTextFieldDes(),
          const SizedBox(height: 20.0),
          Text(
            'Video File?',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),

          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),

          // Pick Video Button
          AppElevatedButton.outline(
            text: isLoading ? 'Loading...' : 'Pick Video',
            onPressed: isLoading ? null : pickVideo,
          ),

          const SizedBox(height: 30.0),

          AppElevatedButton(
            isDisable: isLoading,
            text: 'Make Course',
            onPressed: () {
              // Handle course creation
            },
          ),
        ],
      ),
    );
  }

  TextField _buildTextFieldDes() {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        );
    return TextField(
      maxLines: 5,
      textAlign: TextAlign.start,
      controller: describeController,
      decoration: InputDecoration(
          border: outlineInputBorder(AppColor.grey),
          focusedBorder: outlineInputBorder(AppColor.grey),
          enabledBorder: outlineInputBorder(AppColor.grey),
          labelText: 'e.g., describe...',
          labelStyle: AppStyles.STYLE_14.copyWith(
            color: AppColor.textColor,
          )),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.bgColor,
      title: Text(
        'Create Lesson',
        style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColor.textColor),
      ),
    );
  }
}
