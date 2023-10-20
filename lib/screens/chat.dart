import 'package:ovadrive/providers/chat_pro.dart';
import 'package:ovadrive/widgets/app_bar.dart';
import 'package:ovadrive/widgets/chat_item.dart';
import 'package:ovadrive/model/chat_model.dart';
import 'package:ovadrive/widgets/text_voice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color(0xfff3fcfe),
          appBar: MyAppBar(),
          body: Column(
            children: [
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  final chats = ref.watch(chatProvider).reversed.toList();
                  return ListView.builder(
                    reverse: true,
                    itemCount: chats.length,
                    itemBuilder: (context, index) => ChatItem(
                      text: chats[index].message,
                      isMe: chats[index].isMe,
                    ),
                  );
                }),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextVoice(),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }
}
