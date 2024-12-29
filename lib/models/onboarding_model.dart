import 'package:chat_app/resource/img/app_images.dart';

class OnboardingModel {
  String? imagePath;
  String? text;
}

final onboardings = [
  OnboardingModel()
    ..imagePath = AppImages.imageOnBoarding1
    ..text =
        "Chào mừng đến với EduShare! Tìm kiếm và chia sẻ những tài liệu học tập hữu ích với cộng đồng. Hãy bắt đầu hành trình học tập của bạn ngay hôm nay!",
  OnboardingModel()
    ..imagePath = AppImages.imageOnBoarding2
    ..text =
        "Kết nối với những người cùng chí hướng và học hỏi từ những người có kinh nghiệm. EduShare giúp bạn mở rộng mạng lưới và cùng nhau phát triển kiến thức.",
  OnboardingModel()
    ..imagePath = AppImages.imageOnBoarding3
    ..text =
        "Đừng giữ kiến thức chỉ cho riêng mình! Hãy chia sẻ tài nguyên học tập và giúp đỡ người khác cùng tiến bộ. Cùng EduShare xây dựng cộng đồng học tập mạnh mẽ!",
];
