import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AppRatingBar extends StatelessWidget {
  const AppRatingBar({
    super.key,
    required this.onRatingUpdate,
    this.fullIcon = Icons.star,
    this.halfIcon = Icons.star_half,
    this.emptyIcon = Icons.star_border,
    this.size = 16.8,
    this.color = Colors.blue,
    this.itemCount = 5,
    required this.rating,
  });

  final Function(double) onRatingUpdate;
  final IconData fullIcon;
  final IconData halfIcon;
  final IconData emptyIcon;
  final double size;
  final Color color;
  final int itemCount;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      itemSize: size,
      initialRating: rating,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: itemCount,
      // itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      ratingWidget: RatingWidget(
        full: Icon(fullIcon, color: color),
        half: Icon(halfIcon, color: color),
        empty: Icon(emptyIcon, color: color),
      ),
      onRatingUpdate: onRatingUpdate,
    );
  }
}
