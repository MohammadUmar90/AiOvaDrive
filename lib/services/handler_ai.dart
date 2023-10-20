import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class HandlerAI {
  final _openAI = OpenAI.instance.build(
    token: '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',
    baseOption: HttpSetup(receiveTimeout: 20000),
  );

  // Create a buffer to store conversation history
  final List<String> conversationBuffer = [];

  Future<String> getResponse(String message) async {
    try {
      // Add the user's message to the conversation buffer
      conversationBuffer.add('User: $message');

      // Create a single string with the entire conversation history
      final conversationHistory = conversationBuffer.join('\n');

      final request =
          CompleteText(prompt: conversationHistory, model: kTranslateModelV3);

      final response = await _openAI.onCompleteText(request: request);
      if (response != null) {
        // Extract and return the AI's response
        final aiResponse = response.choices[0].text.trim(); // Added null safety

        // Add the AI's response to the conversation buffer
        conversationBuffer.add(aiResponse);

        return aiResponse;
      }
      return 'Something went wrong with the AI response';
    } catch (e) {
      return 'Bad Request';
    }
  }

  void dispose() {
    _openAI.close();
  }
}
