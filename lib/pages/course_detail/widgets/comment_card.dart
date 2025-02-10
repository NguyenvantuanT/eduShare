import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/app_rating_bar.dart';
import 'package:chat_app/components/mv_simmer.dart';
import 'package:chat_app/models/comment_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  const CommentCard(
    this.comment, {
    super.key,
    required this.onRatingUpdate,
  });
  final CommentModel comment;
  final Function(double) onRatingUpdate;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(26.0)),
              child: CachedNetworkImage(
                imageUrl: comment.avatar ?? "",
                height: 20.0 * 2,
                width: 20.0 * 2,
                fit: BoxFit.cover,
                errorWidget: (context, _, __) => const AppSimmer(
                  height: 20.0 * 2,
                  width: 20.0 * 2,
                ),
                placeholder: (_,__) => const AppSimmer(
                  height: 20.0 * 2,
                  width: 20.0 * 2,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              comment.name ?? "",
              style: AppStyles.STYLE_14.copyWith(
                  color: AppColor.textColor, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45.0),
          child: Text(
            comment.comment ?? "",
            style: AppStyles.STYLE_14.copyWith(
              color: AppColor.textColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45.0),
          child: AppRatingBar(
            onRatingUpdate: onRatingUpdate,
            rating: comment.rating ?? 0.0,
          ),
        )
      ],
    );
  }
}
