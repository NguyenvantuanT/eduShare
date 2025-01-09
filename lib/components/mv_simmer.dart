import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppSimmer extends StatelessWidget {
  const AppSimmer({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade400,
      enabled: true,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          border: Border.all(color: Colors.grey),
        ),
      ),
    );
  }
}
