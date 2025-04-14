Xây dựng app nhắc nhở kiến thức, bài tập trên Android bằng Fullter

🧱 Cấu Trúc Dự Án

lib/
├── components/             # Các thành phần UI dùng lại (buttons, inputs, dialogs, ...)
├── models/                 # Các lớp dữ liệu (Course, User, Lecture, ...)
├── pages/                  # Các màn hình chính của app (Home, Login, Detail, ...)
├── resource/           
│   ├── img/                # Thư mục hình ảnh
│   └── themes/             # Cấu hình màu sắc, chủ đề, style
├── services/           
│   ├── local/              # Dịch vụ lưu trữ local (SharedPreferences, SQLite, ...)
│   └── remote/             # Giao tiếp với backend hoặc Firebase
├── utils/                  # Các hàm tiện ích (validator, formatter, logger, ...)
├── firebase_options.dart   # Cấu hình Firebase tự động tạo
└── main.dart               # Điểm khởi chạy ứng dụng

🚀 Hướng Dẫn Chạy Dự Án
1. Cài đặt các công cụ cần thiết
Flutter SDK (>= 3.10.0)

Dart SDK (>= 3.0.0)

IDE: Android Studio hoặc Visual Studio Code

Thiết bị/emulator Android hoặc iOS

2. Clone repository

git clone https://github.com/NguyenvantuanT/eduShare.git

3. Cài đặt dependencies

flutter pub get

4. Chạy ứng dụng

Kết nối thiết bị hoặc mở trình giả lập, sau đó chạy:

flutter run

5. Build APK (tùy chọn)

flutter build apk --release
