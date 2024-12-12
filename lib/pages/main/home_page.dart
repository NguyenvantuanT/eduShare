import 'dart:async';

import 'package:chat_app/components/app_dialog.dart';
import 'package:chat_app/models/messager_model.dart';
import 'package:chat_app/pages/main/widgets/messages_group.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/mess_services.dart';
import 'package:chat_app/themes/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  MessServices messServices = MessServices();
  FocusNode messFocus = FocusNode();

  void _scrollScreen() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 100.0,
      duration: const Duration(milliseconds: 2600),
      curve: Curves.easeOut,
    );
  }

  final Stream<QuerySnapshot> messStream = FirebaseFirestore.instance
      .collection('database')
      .orderBy('id', descending: true)
      .snapshots();

  void _sendMessage() {
    MessagerModel mess = MessagerModel()
      ..avatar = SharedPrefs.user?.avatar
      ..createBy = SharedPrefs.user?.email
      ..id = '${DateTime.now().millisecondsSinceEpoch}'
      ..text = messageController.text.trim()
      ..isRecalled = false;
    _scrollScreen();
    messServices.addMess(mess);
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                List<MessagerModel> messagers = snapshot.data?.docs
                        .map((e) => MessagerModel.toJson(
                            e.data() as Map<String, dynamic>)
                          ..docId = e.id)
                        .toList() ??
                    [];
                return SlidableAutoCloseBehavior(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0)
                        .copyWith(top: 16.0, bottom: 20.0),
                    itemCount: messagers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                    itemBuilder: (context, index) {
                      MessagerModel mess = messagers.reversed.toList()[index];
                      final isMe = mess.createBy == SharedPrefs.user?.email;
                      final isRecall = mess.isRecalled ?? false;
                      return MessagesGroup(
                        mess,
                        isMe: isMe,
                        isRecall: isRecall,
                        onDeleteMess: (context) {
                          messServices.deleteMes(mess.docId ?? "");
                        },
                        onEditMess: (context) async {
                          mess = await AppDialog.editMess(context, mess);
                          messServices.updateMess(mess);
                          messFocus.unfocus();
                        },
                        onFalseRecallMess: (context) {
                          messServices.updateMess(mess..isRecalled = false);
                        },
                        onRecallMess: (context) {
                          messServices.updateMess(mess..isRecalled = true);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 24.0),
        child: TextField(
          controller: messageController,
          focusNode: messFocus,
          onTap: () => Timer(
            const Duration(milliseconds: 600),
            () => _scrollScreen(),
          ),
          style: const TextStyle(color: AppColor.orange),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.white,
            hintStyle: const TextStyle(
              color: Color(0xffB7B8BA),
              fontSize: 14.0,
            ),
            hintText: 'Messager here',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            suffixIcon: GestureDetector(
              onTap: _sendMessage,
              child: const Icon(Icons.send, color: Colors.brown),
            ),
          ),
        ),
      ),
    );
  }
}
