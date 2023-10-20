import 'package:ovadrive/widgets/text_voice.dart';
import 'package:flutter/material.dart';

class ToggleButtonSend extends StatefulWidget {
  final VoidCallback _sendTextMessage;
  final VoidCallback _sendVoiceMessage;
  final bool _isReplying;
  final bool _isListening;
  final InputMode _inputMode;
  const ToggleButtonSend({
    super.key,
    required InputMode inputMode,
    required VoidCallback sendTextMessage,
    required VoidCallback sendVoiceMessage,
    required bool isReplying,
    required bool isListening,
  })  : _inputMode = inputMode,
        _sendTextMessage = sendTextMessage,
        _sendVoiceMessage = sendVoiceMessage,
        _isReplying = isReplying,
        _isListening = isListening;

  @override
  State<ToggleButtonSend> createState() => _ToggleButtonSendState();
}

class _ToggleButtonSendState extends State<ToggleButtonSend> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff41c4ff), // Change the background color here
        foregroundColor: Color(0xff000000),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      onPressed: widget._isReplying
          ? null
          : widget._inputMode == InputMode.text
              ? widget._sendTextMessage
              : widget._sendVoiceMessage,
      child: Icon(
        widget._inputMode == InputMode.text
            ? Icons.send
            : widget._isListening
                ? Icons.mic_off
                : Icons.mic,
      ),
    );
  }
}
