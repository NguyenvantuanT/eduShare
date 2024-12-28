import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/messager_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MessagesGroup extends StatelessWidget {
  const MessagesGroup(
    this.chat, {
    super.key,
    this.onDeleteMess,
    this.onEditMess,
    this.onRecallMess,
    this.onFalseRecallMess,
    this.isMe = false,
    this.isRecall = false,
  });

  final MessagerModel chat;
  final bool isMe;
  final bool isRecall;
  final Function(BuildContext)? onDeleteMess;
  final Function(BuildContext)? onEditMess;
  final Function(BuildContext)? onRecallMess;
  final Function(BuildContext)? onFalseRecallMess;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(chat.id),
      startActionPane: isMe ? null : _buildActionPaneOne(chat),
      endActionPane: isMe
          ? isRecall
              ? _buildActionPaneThree(chat)
              : _buildActionPaneTwo(context, chat)
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isMe) ...[_buildAvatar(chat), const SizedBox(width: 6.0)],
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: _buildMessagerBox(context, chat, isMe, isRecall),
          ),
          if (isMe) ...[
            const SizedBox(width: 6.0),
            _buildAvatar(chat),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(MessagerModel chat) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: CachedNetworkImage(
        imageUrl: chat.avatar ?? "",
        width: 32,
        height: 32.0,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => const CircleAvatar(
          radius: 16.0,
          backgroundColor: Colors.orange,
          child: Icon(Icons.error_outline, color: Colors.white),
        ),
        placeholder: (_, __) => const Center(
          child: SizedBox.square(
            dimension: 24.0,
            child: CircularProgressIndicator(strokeWidth: 2.6),
          ),
        ),
      ),
    );
  }

  Widget _buildMessagerBox(
    BuildContext context,
    MessagerModel chat,
    bool isMe,
    bool isRecall,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: isMe ? AppColor.grey.withOpacity(0.5) : AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMe
              ? isRecall
                  ? 0.0
                  : 16.0
              : 2.0),
          topRight: Radius.circular(isMe
              ? isRecall
                  ? 0.0
                  : 2.0
              : 16.0),
          bottomLeft: Radius.circular(isMe ? 2.0 : 16.0),
          bottomRight: Radius.circular(isMe ? 16.0 : 2.0),
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.68,
      ),
      child: Text(
        isRecall ? 'The message is recalled' : chat.text ?? "",
        style: TextStyle(color: isRecall ? AppColor.blue : AppColor.orange),
      ),
    );
  }

  ActionPane _buildActionPaneTwo(BuildContext context, MessagerModel chat) {
    return ActionPane(
      motion: const DrawerMotion(),
      children: [
        SlidableAction(
          onPressed: onDeleteMess,
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
        ),
        SlidableAction(
          onPressed: onRecallMess,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          icon: Icons.beach_access,
        ),
        SlidableAction(
          onPressed: onEditMess,
          backgroundColor: const Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.edit,
        ),
      ],
    );
  }

  ActionPane _buildActionPaneThree(MessagerModel chat) {
    return ActionPane(
      motion: const DrawerMotion(),
      children: [
        SlidableAction(
          onPressed: onDeleteMess,
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
        ),
        SlidableAction(
          onPressed: onFalseRecallMess,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          icon: Icons.beach_access,
        ),
        SlidableAction(
          onPressed: (_) {},
          backgroundColor: const Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.cancel_outlined,
        ),
      ],
    );
  }

  ActionPane _buildActionPaneOne(MessagerModel chat) {
    return ActionPane(
      motion: const DrawerMotion(),
      children: [
        SlidableAction(
          onPressed: onDeleteMess,
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
        ),
        SlidableAction(
          onPressed: (_) {},
          backgroundColor: const Color(0xFF21B7CA),
          foregroundColor: Colors.white,
          icon: Icons.cancel_outlined,
        ),
      ],
    );
  }
}
