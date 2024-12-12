import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.avatar,
    this.radius = 26.0,
    this.isActive = false,
  });

  final String? avatar;
  final double radius;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(1.0),
          decoration: const BoxDecoration(
              color: AppColor.orange, shape: BoxShape.circle),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CachedNetworkImage(
                  imageUrl: avatar ?? "",
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => CircleAvatar(
                    radius: radius * 2,
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.error_outline, color: Colors.white),
                  ),
                  placeholder: (_, __) => SizedBox.square(
                    dimension: radius * 2,
                    child: const Center(
                      child: SizedBox.square(
                        dimension: 24.6,
                        child: CircularProgressIndicator(
                          color: AppColor.pink,
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          child: CircleAvatar(
            backgroundColor: AppColor.white,
            radius: radius / 4.6 + 1.8,
            child: CircleAvatar(
              backgroundColor: isActive ? AppColor.green : AppColor.yellow,
              radius: radius / 4.6,
            ),
          ),
        ),
      ],
    );
  }
}
