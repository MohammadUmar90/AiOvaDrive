import 'package:ovadrive/model/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPro extends StateNotifier<List<ChatModel>> {
  ChatPro() : super([]);
  void add(ChatModel chatModel) {
    state = [...state, chatModel];
  }

  void removeTyping() {
    state = state..removeWhere((chat) => chat.id == 'typing');
  }
}

final chatProvider = StateNotifierProvider<ChatPro, List<ChatModel>>(
  (ref) => ChatPro(),
);
