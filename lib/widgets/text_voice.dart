import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ovadrive/model/chat_model.dart';
import 'package:ovadrive/providers/chat_pro.dart';
import 'package:ovadrive/services/handler_ai.dart';
import 'package:ovadrive/services/voice_handler.dart';
import 'package:ovadrive/widgets/toggle_button.dart';

enum InputMode {
  text,
  voice,
}

class TextVoice extends ConsumerStatefulWidget {
  const TextVoice({Key? key}) : super(key: key);

  @override
  ConsumerState<TextVoice> createState() => _TextVoiceState();
}

class _TextVoiceState extends ConsumerState<TextVoice> {
  InputMode _inputMode = InputMode.voice;
  final _messageControl = TextEditingController();
  final HandlerAI _openAI = HandlerAI();
  final VoiceHandler voiceHandler = VoiceHandler();
  final FlutterTts flutterTts = FlutterTts();
  var _isReplying = false;
  var _isListening = false;

  @override
  void initState() {
    voiceHandler.initSpeech();
    super.initState();
    initTextToSpeech();
    startListening();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> startListening() async {
    if (voiceHandler.isEnabled) {
      await voiceHandler.startListening();
      setListeningState(true);
    }
  }

  @override
  void dispose() {
    _messageControl.dispose();
    _openAI.dispose();
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageControl,
            onChanged: (value) {
              value.isNotEmpty
                  ? setInputMode(InputMode.text)
                  : setInputMode(InputMode.voice);
            },
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        ToggleButtonSend(
          isListening: _isListening,
          isReplying: _isReplying,
          inputMode: _inputMode,
          sendTextMessage: () {
            final message = _messageControl.text;
            _messageControl.clear();
            sendTextMessage(message);
          },
          sendVoiceMessage: sendVoiceMessage,
        ),
      ],
    );
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendTextMessage(String message) async {
    setReplyingState(true);
    addToChatList(
      message,
      true,
      DateTime.now().toString(),
    );
    addToChatList('OvaDrive Is Typing....', false, 'typing');
    setInputMode(InputMode.voice);

    // Turn off the microphone
    setListeningState(false);
    final aiResponse = await _openAI.getResponse(message);
    removeTyping();
    addToChatList(
      aiResponse,
      false,
      DateTime.now().toString(),
    );
    setReplyingState(false);

    // Start system speaking
    await systemSpeak(aiResponse);
  }

  Future<void> systemSpeak(String content) async {
    // Turn off the microphone
    await voiceHandler.stopListening();
    setListeningState(false);

    await flutterTts.speak(content);

    // Wait for the speech to finish
    await flutterTts.awaitSpeakCompletion(true);

    // Turn on the microphone
    setListeningState(true);
    final user = await voiceHandler.startListening();
    sendTextMessage(user);

    if (user.toLowerCase().contains("exit conversation")) {
      await voiceHandler
          .stopListening(); // Stop listening when the conversation ends
      addToChatList(
          "Goodbye! If you need assistance later, just say 'Hey Ova'.",
          false,
          DateTime.now().toString());
      await Future.delayed(Duration(milliseconds: 10000));
      addToChatList(
          "I'm still here to assist you. Just say 'Hey Ova' to start a new conversation.",
          false,
          DateTime.now().toString());
      await Future.delayed(Duration(milliseconds: 15000));
      setListeningState(true);
      final user = await voiceHandler.startListening();
      if (user.toLowerCase().contains("hi over")) {
        startOvaConversation();
      }
    }
  }

  Future<void> sendVoiceMessage() async {
    if (!voiceHandler.isEnabled) {
      print('Not Supported');
      return;
    }

    setListeningState(true);
    final result = await voiceHandler.startListening();
    setListeningState(false);

    if (result.toLowerCase().contains("hi over")) {
      startOvaConversation();
    } else {
      sendTextMessage(result);
    }
  }

  void startOvaConversation() async {
    setInputMode(InputMode.voice);
    addToChatList("Hey there! I am AiOvaDrive. How can I assist you today?",
        false, DateTime.now().toString());
    final userMessage = await voiceHandler.startListening();
    sendTextMessage(userMessage);
  }

  void removeTyping() {
    final chats = ref.read(chatProvider.notifier);
    chats.removeTyping();
  }

  void setReplyingState(bool isReplying) {
    setState(() {
      _isReplying = isReplying;
    });
  }

  void setListeningState(bool isListening) {
    setState(() {
      _isListening = isListening;
    });
  }

  void addToChatList(String message, bool isMe, String id) {
    final chats = ref.read(chatProvider.notifier);
    chats.add(
      ChatModel(
        id: id,
        message: message,
        isMe: isMe,
      ),
    );
  }
}
